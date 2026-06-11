# SlickSale Backend

FastAPI server providing chat (SSE streaming), speech-to-text,

scenario management, and AI scoring endpoints.

## Tech stack

- Python 3.11

- FastAPI + sse-starlette

- OpenAI API (chat completions, whisper)

- httpx (async HTTP client for calling Modal TTS)

- Pydantic v2 for models and settings

## Architecture

- `app/main.py` — FastAPI app, CORS, lifespan, health check

- `app/config.py` — Pydantic BaseSettings (all config from env vars)

- `app/routers/` — one file per endpoint group (chat, stt, scenarios, scoring)

- `app/services/` — business logic (LLM streaming, TTS client, sentence chunker)

- `app/models/schemas.py` — Pydantic request/response models

- `app/prompts/` — LLM system prompts (master wrapper + scenarios)

## Key endpoints

- `POST /chat` — SSE stream. Streams LLM tokens, fires TTS per

  sentence, returns text + audio + visemes interleaved. Core endpoint.

- `POST /transcribe` — proxy to OpenAI Whisper

- `GET /scenarios` — returns scenario list (never exposes systemPrompt)

- `POST /score` — calls GPT-4o for structured scoring JSON

## Rules

- NO API keys in code. Everything from environment variables.

- ALL I/O is async. No blocking calls on the event loop.

- Type hints on every function.

- Proper HTTPException with meaningful status codes.

- The sentence chunker must handle edge cases: abbreviations (Mr. Dr.),

  decimals ($10.99), ellipsis (...).

- TTS calls fire per-sentence via asyncio.create_task — parallel with

  continued LLM streaming. Don't wait for TTS before sending next text.

## Running locally

cd backend pip install -r requirements.txt cp .env.example .env  # fill in your keys uvicorn app.main:app --reload --port 8000

## Session end detection

The LLM appends `[SESSION_COMPLETE:CLOSED]` or `[SESSION_COMPLETE:LOST]`

to its final message. The chat router strips these tags before sending

to the client, then emits a separate `session_complete` SSE event. The

frontend never sees the raw tags.
