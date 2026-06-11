Loads only when editing Modal TTS code.

---

globs:

  - "modal_service/**"

---

# Modal TTS Rules

GPU text-to-speech + forced alignment on Modal.

## Stack

- coqui-tts from PyPI (Idiap fork, NOT abandoned original repo)

- torchaudio.functional.forced_align with wav2vec2 (NOT MFA)

- Modal T4 GPU, scale-to-zero

## Viseme IDs

REST, AA, EE, MM, FF, OO, LL, SS (8 total, matching Rive)

## Rules

- Model weights cached in Modal Volume (no re-download on cold start)

- wav2vec2 alignment (~100-300ms), never MFA (5-60s)

- Every phoneme must map to a viseme. Unmapped → REST.

- Pin all dependency versions

- GPU: T4, max_containers=2, scaledown_window=60
