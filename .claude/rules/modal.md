Loads only when editing Modal TTS code.

---

globs:

  - "modal_service/**"

---

# Modal TTS + STT Rules

GPU text-to-speech, forced alignment, and speech-to-text on Modal.

## Stack

- coqui-tts from PyPI (Idiap fork, NOT abandoned original repo)

- torchaudio built-in forced alignment pipeline for viseme timing

- openai-whisper (open-source model, NOT the API) for STT

- Modal T4 GPU, scale-to-zero

## Forced alignment

Use torchaudio's built-in pipeline instead of loading transformers

directly:

    import torchaudio

    bundle = torchaudio.pipelines.MMS_FA  # multilingual forced alignment

    # or WAV2VEC2_ASR_BASE_960H for English-only

    model = bundle.get_model()

    aligner = torchaudio.functional.forced_align(

        log_probs, targets, input_lengths, target_lengths

    )

This is faster and more integrated than loading via transformers.

## STT (self-hosted Whisper)

Runs on the same Modal T4 that already runs TTS. The GPU is already

warm from the TTS warmup call at simulation start, so marginal cost

is ~$0.0001 per transcription (~60x cheaper than OpenAI API).

- Use the "small" model (~244MB, <1s inference on T4, good accuracy)

- Load in the same @app.cls @enter() method alongside Coqui and wav2vec2

- Cache weights in the same Modal Volume

- POST /transcribe endpoint:

  Request: multipart audio file (webm or wav)

  Response: {"text": "transcribed text"}

  Implementation: write uploaded bytes to temp file, run

  self.whisper_model.transcribe(temp_path, language="en"),

  return result["text"], clean up temp file

## Viseme IDs

REST, AA, EE, MM, FF, OO, LL, SS (8 total, matching Rive)

## Rules

- Model weights cached in Modal Volume (no re-download on cold start)

- Every phoneme must map to a viseme. Unmapped → REST.

- Pin all dependency versions

- GPU: T4, max_containers=2, scaledown_window=60
