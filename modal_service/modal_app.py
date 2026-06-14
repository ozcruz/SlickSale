"""SlickSale TTS + STT service on Modal.

A single GPU container (T4, scale-to-zero) loads three models once at startup:

  * Coqui VITS (``tts_models/en/vctk/vits``, MIT licensed) for speech synthesis
  * torchaudio's MMS_FA forced-alignment pipeline for phoneme/word timing
  * openai-whisper "small" (the open-source model, NOT the API) for STT

Weights are cached in a Modal Volume so cold starts don't re-download them.

It exposes one FastAPI app (so a single base URL serves both routes):

  POST /synthesize  {"text": "..."}            -> {audio_b64, sample_rate, visemes}
  POST /transcribe  multipart audio (webm/wav) -> {"text": "..."}

Run the smoke test with::

    modal run modal_app.py
"""

from __future__ import annotations

import base64
import io
import os
import tempfile

import modal

from viseme_map import REST, phoneme_to_viseme, viseme_name

APP_NAME = "slicksale-tts"
TTS_MODEL = "tts_models/en/vctk/vits"
WHISPER_MODEL = "small"
OUTPUT_SAMPLE_RATE = 22050  # VITS VCTK native rate; echoed back to the client.
CACHE_DIR = "/cache"

app = modal.App(APP_NAME)

# All model weights live here so they survive cold starts.
volume = modal.Volume.from_name("slicksale-tts-cache", create_if_missing=True)

# espeak-ng -> IPA phonemes (via Coqui), ffmpeg -> Whisper decoding webm/wav,
# libsndfile -> soundfile WAV encoding.
image = (
    modal.Image.debian_slim(python_version="3.11")
    .apt_install("espeak-ng", "libsndfile1", "ffmpeg")
    .pip_install_from_requirements("requirements.txt")
    .env(
        {
            "COQUI_TOS_AGREED": "1",
            "TTS_HOME": f"{CACHE_DIR}/tts",
            "XDG_DATA_HOME": f"{CACHE_DIR}/xdg",
            "TORCH_HOME": f"{CACHE_DIR}/torch",
            "HF_HOME": f"{CACHE_DIR}/hf",
            "NUMBA_CACHE_DIR": f"{CACHE_DIR}/numba",
        }
    )
    .add_local_python_source("viseme_map")
)


@app.cls(
    gpu="T4",
    image=image,
    volumes={CACHE_DIR: volume},
    max_containers=2,
    scaledown_window=60,
)
class TTSModel:
    """Holds the warm models and does the actual synthesis / alignment / STT."""

    @modal.enter()
    def load(self) -> None:
        import torch
        import torchaudio
        import whisper
        from TTS.api import TTS

        for sub in ("tts", "xdg", "torch", "hf", "numba", "whisper"):
            os.makedirs(f"{CACHE_DIR}/{sub}", exist_ok=True)

        self.device = "cuda" if torch.cuda.is_available() else "cpu"

        # --- Coqui VITS (multi-speaker; pick a stable default speaker) ---
        self.tts = TTS(TTS_MODEL, progress_bar=False).to(self.device)
        speakers = getattr(self.tts, "speakers", None)
        self.speaker = speakers[0] if speakers else None
        self.tts_sample_rate = self.tts.synthesizer.output_sample_rate

        # --- torchaudio MMS_FA forced alignment ---
        self.fa_bundle = torchaudio.pipelines.MMS_FA
        self.fa_model = self.fa_bundle.get_model().to(self.device)
        self.fa_tokenizer = self.fa_bundle.get_tokenizer()
        self.fa_aligner = self.fa_bundle.get_aligner()
        self.fa_sample_rate = self.fa_bundle.sample_rate

        # --- Whisper (small) ---
        self.whisper_model = whisper.load_model(
            WHISPER_MODEL, device=self.device, download_root=f"{CACHE_DIR}/whisper"
        )

        # --- espeak phonemizer (optional; falls back to graphemes) ---
        self.phonemizer = None
        try:
            from TTS.tts.utils.text.phonemizers import ESpeak

            self.phonemizer = ESpeak(language="en-us")
        except Exception as exc:  # pragma: no cover - environment dependent
            print(f"espeak phonemizer unavailable, using grapheme fallback: {exc}")

        # Persist anything just downloaded so the next cold start is fast.
        try:
            volume.commit()
        except Exception as exc:  # pragma: no cover
            print(f"volume commit skipped: {exc}")

    # ------------------------------------------------------------------ #
    # Synthesis
    # ------------------------------------------------------------------ #
    def _synthesize(self, text: str) -> dict:
        import numpy as np
        import soundfile as sf
        import torch
        import torchaudio

        text = (text or "").strip()
        if not text:
            return {"audio_b64": "", "sample_rate": OUTPUT_SAMPLE_RATE, "visemes": []}

        kwargs: dict = {"text": text}
        if self.speaker is not None:
            kwargs["speaker"] = self.speaker
        if getattr(self.tts, "is_multi_lingual", False):
            kwargs["language"] = "en"
        wav = np.asarray(self.tts.tts(**kwargs), dtype=np.float32)

        total_ms = int(round(len(wav) / self.tts_sample_rate * 1000))
        visemes = self._build_visemes(wav, text, total_ms, torch, torchaudio)

        buffer = io.BytesIO()
        sf.write(buffer, wav, self.tts_sample_rate, format="WAV", subtype="PCM_16")
        audio_b64 = base64.b64encode(buffer.getvalue()).decode("ascii")

        return {
            "audio_b64": audio_b64,
            "sample_rate": self.tts_sample_rate,
            "visemes": visemes,
        }

    def _build_visemes(self, wav, text: str, total_ms: int, torch, torchaudio) -> list[dict]:
        """Force-align the synthesized audio, then map units -> visemes.

        MMS_FA gives accurate per-word (and per-character) timing. Within each
        word we lay phonemes (espeak) or characters across the word's span. Any
        failure degrades gracefully to an even time-distribution so the avatar
        always has something to animate.
        """
        try:
            word_spans = self._align(wav, text, torch, torchaudio)
            if not word_spans:
                return _merge_visemes(_evenly_distribute(text, total_ms))

            events: list[tuple[int, int, int]] = []  # (viseme_id, start_ms, end_ms)
            for original, _norm, start_ms, end_ms, char_spans in word_spans:
                phonemes = self._phonemize(original)
                if phonemes:
                    events.extend(_spread_units(phonemes, start_ms, end_ms))
                else:
                    events.extend(
                        (phoneme_to_viseme(ch), cs, ce) for ch, cs, ce in char_spans
                    )
            return _merge_visemes(_with_rest_gaps(events, total_ms))
        except Exception as exc:  # pragma: no cover - alignment is best-effort
            print(f"alignment failed, using even distribution: {exc}")
            return _merge_visemes(_evenly_distribute(text, total_ms))

    def _align(self, wav, text: str, torch, torchaudio):
        """Return [(original_word, norm_word, start_ms, end_ms, char_spans)]."""
        words = _normalize_words(text)
        if not words:
            return []
        transcript = [norm for _orig, norm in words]

        waveform = torch.from_numpy(wav).unsqueeze(0)
        if self.tts_sample_rate != self.fa_sample_rate:
            waveform = torchaudio.functional.resample(
                waveform, self.tts_sample_rate, self.fa_sample_rate
            )

        with torch.inference_mode():
            emission, _ = self.fa_model(waveform.to(self.device))
            token_spans = self.fa_aligner(emission[0], self.fa_tokenizer(transcript))

        num_frames = emission.size(1)
        ratio = waveform.size(1) / num_frames / self.fa_sample_rate  # frame -> seconds
        spans = []
        for (original, norm), word_tokens in zip(words, token_spans):
            if not word_tokens:
                continue
            start_ms = int(round(word_tokens[0].start * ratio * 1000))
            end_ms = int(round(word_tokens[-1].end * ratio * 1000))
            char_spans = []
            for ch, tok in zip(norm, word_tokens):
                char_spans.append(
                    (ch, int(round(tok.start * ratio * 1000)), int(round(tok.end * ratio * 1000)))
                )
            spans.append((original, norm, start_ms, end_ms, char_spans))
        return spans

    def _phonemize(self, word: str) -> list[str]:
        """Best-effort IPA phonemes for a single word ([] if unavailable)."""
        if self.phonemizer is None:
            return []
        try:
            raw = self.phonemizer.phonemize(word, separator="|")
        except Exception:
            return []
        phonemes: list[str] = []
        for chunk in str(raw).replace(" ", "|").split("|"):
            chunk = chunk.strip()
            if chunk:
                phonemes.append(chunk)
        return phonemes

    # ------------------------------------------------------------------ #
    # Transcription
    # ------------------------------------------------------------------ #
    def _transcribe(self, audio_bytes: bytes, suffix: str) -> str:
        if not suffix.startswith("."):
            suffix = "." + suffix
        tmp_path = None
        try:
            with tempfile.NamedTemporaryFile(suffix=suffix, delete=False) as tmp:
                tmp.write(audio_bytes)
                tmp_path = tmp.name
            result = self.whisper_model.transcribe(tmp_path, language="en")
            return str(result.get("text", "")).strip()
        finally:
            if tmp_path and os.path.exists(tmp_path):
                os.remove(tmp_path)

    # ------------------------------------------------------------------ #
    # Remote entrypoints
    # ------------------------------------------------------------------ #
    @modal.method()
    def synthesize(self, text: str) -> dict:
        """Remote method used by the smoke test (`modal run`)."""
        return self._synthesize(text)

    @modal.asgi_app()
    def web(self):
        from fastapi import FastAPI, File, UploadFile
        from pydantic import BaseModel
        from starlette.concurrency import run_in_threadpool

        class SynthesizeBody(BaseModel):
            text: str

        web_app = FastAPI(title="SlickSale TTS/STT")

        @web_app.get("/health")
        async def health() -> dict:
            return {"status": "ok"}

        @web_app.post("/synthesize")
        async def synthesize(body: SynthesizeBody) -> dict:
            return await run_in_threadpool(self._synthesize, body.text)

        @web_app.post("/transcribe")
        async def transcribe(file: UploadFile = File(...)) -> dict:
            data = await file.read()
            suffix = os.path.splitext(file.filename or "")[1] or ".webm"
            text = await run_in_threadpool(self._transcribe, data, suffix)
            return {"text": text}

        return web_app


# ---------------------------------------------------------------------- #
# Viseme post-processing helpers (pure functions, no GPU state)
# ---------------------------------------------------------------------- #
def _normalize_words(text: str) -> list[tuple[str, str]]:
    """Split into (original, alignment-normalized) word pairs.

    The normalized form keeps only a-z (MMS_FA's English token set); words that
    normalize to empty (pure numbers/punctuation) are dropped from alignment.
    """
    pairs: list[tuple[str, str]] = []
    for token in text.split():
        norm = "".join(c for c in token.lower() if "a" <= c <= "z")
        if norm:
            pairs.append((token, norm))
    return pairs


def _spread_units(units: list[str], start_ms: int, end_ms: int) -> list[tuple[int, int, int]]:
    """Lay a word's phonemes/chars evenly across its [start, end] span."""
    span = max(end_ms - start_ms, 1)
    n = len(units)
    out: list[tuple[int, int, int]] = []
    for i, unit in enumerate(units):
        u_start = start_ms + span * i // n
        u_end = start_ms + span * (i + 1) // n
        out.append((phoneme_to_viseme(unit), u_start, max(u_end, u_start + 1)))
    return out


def _with_rest_gaps(events: list[tuple[int, int, int]], total_ms: int, gap_ms: int = 90) -> list[tuple[int, int, int]]:
    """Insert REST events into silences between aligned words and at the edges."""
    if not events:
        return [(REST, 0, total_ms)]
    events = sorted(events, key=lambda e: e[1])
    filled: list[tuple[int, int, int]] = []
    cursor = 0
    for vid, start, end in events:
        if start - cursor >= gap_ms:
            filled.append((REST, cursor, start))
        filled.append((vid, start, end))
        cursor = max(cursor, end)
    if total_ms - cursor >= gap_ms:
        filled.append((REST, cursor, total_ms))
    return filled


def _evenly_distribute(text: str, total_ms: int) -> list[tuple[int, int, int]]:
    """Last-resort fallback: spread every spoken character across the duration."""
    chars = [c for c in text if c.isalpha()]
    if not chars or total_ms <= 0:
        return [(REST, 0, max(total_ms, 1))]
    n = len(chars)
    return [
        (phoneme_to_viseme(ch), total_ms * i // n, total_ms * (i + 1) // n)
        for i, ch in enumerate(chars)
    ]


def _merge_visemes(events: list[tuple[int, int, int]]) -> list[dict]:
    """Merge adjacent identical visemes and emit the wire format."""
    out: list[dict] = []
    for vid, start, end in events:
        duration = max(end - start, 1)
        if out and out[-1]["id"] == viseme_name(vid):
            out[-1]["duration_ms"] += duration
            continue
        out.append({"id": viseme_name(vid), "start_ms": start, "duration_ms": duration})
    return out


# ---------------------------------------------------------------------- #
# Smoke test
# ---------------------------------------------------------------------- #
@app.local_entrypoint()
def main(text: str = "Hello, I understand your concern about pricing.") -> None:
    import wave

    result = TTSModel().synthesize.remote(text)
    audio = base64.b64decode(result["audio_b64"])
    with wave.open(io.BytesIO(audio)) as handle:
        duration = handle.getnframes() / handle.getframerate()

    print(f"text:        {text!r}")
    print(f"sample_rate: {result['sample_rate']} Hz")
    print(f"audio:       {duration:.2f}s ({len(audio)} bytes)")
    print(f"visemes:     {len(result['visemes'])}")
    if result["visemes"]:
        preview = ", ".join(v["id"] for v in result["visemes"][:12])
        print(f"first ids:   {preview}")
