
Loads only when editing Python backend code.

---

globs:

  - "backend/**"

---

# Backend Rules

Python FastAPI server. Separate project from Flutter — has its own

requirements.txt, Dockerfile, virtual environment.

## Architecture

- app/main.py — FastAPI app, CORS, lifespan, health check

- app/config.py — Pydantic BaseSettings (all config from env vars)

- app/routers/ — one file per endpoint group

- app/services/ — business logic (LLM, TTS client, sentence chunker)

- app/prompts/ — LLM system prompts

## Rules

- No API keys in code. Everything from environment variables.

- All I/O is async. No blocking calls.

- Type hints on every function.

- HTTPException with meaningful status codes for errors.

- TTS calls fire per-sentence via asyncio.create_task — parallel

  with LLM streaming. Don't wait for TTS before sending next text.

## Scoring endpoint

Use OpenAI Structured Outputs for the scoring response, NOT the

older json_object mode. Structured Outputs guarantee schema conformance.

Define a Pydantic model for the score response:

    class ScoreResult(BaseModel):

        overall_score: float

        category_scores: dict[str, float]

        feedback: str

        tips: list[str]

Use the SDK's beta parse method:

    completion = await client.beta.chat.completions.parse(

        model="gpt-4o",

        messages=messages,

        response_format=ScoreResult,

    )

    result = completion.choices[0].message.parsed

This replaces response_format={"type": "json_object"} which only

guarantees valid JSON, not schema conformance.

## STT routing

POST /transcribe forwards audio to Modal /transcribe endpoint

(NOT OpenAI Whisper API). Use httpx.AsyncClient (same client used

for TTS calls). Handle Modal cold start gracefully — same timeout

strategy as TTS.

## Session end detection

LLM appends [SESSION_COMPLETE:CLOSED] or [SESSION_COMPLETE:LOST].

Chat router strips tags, emits separate SSE event. Frontend never

sees raw tags.

## Sentence chunker

Split on .!? but NOT on: abbreviations (Mr. Dr. Inc.), decimals

($10.99), or ellipsis (...). Bad chunking = weird TTS pauses.
