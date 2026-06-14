"""POST /chat — stream the prospect's reply as SSE.

As the LLM streams, completed sentences are emitted immediately as `text_delta`
events and, in parallel, sent to Modal for TTS. Each TTS result comes back as
`audio_chunk` + `viseme` events tagged with a sentence_index so the frontend can
correlate them. Firing TTS per sentence (rather than waiting for the full reply)
is what keeps the avatar responsive.
"""

from __future__ import annotations

import asyncio
import json
import re
from typing import Any, AsyncIterator

import httpx
from fastapi import APIRouter, HTTPException, Request
from sse_starlette.sse import EventSourceResponse

from app.models.schemas import ChatRequest
from app.scenarios.prompts import SYSTEM_PROMPTS
from app.services import tts_client
from app.services.sentence_chunker import SentenceChunker

router = APIRouter()

CHAT_MODEL = "gpt-4o"

# The LLM may append a completion tag; the frontend must never see the raw tag.
_SESSION_TAG = re.compile(r"\[SESSION_COMPLETE:(CLOSED|LOST)\]")

# Sentinel pushed onto the queue when the LLM stream is fully consumed.
_PRODUCER_DONE = "__producer_done__"


def _sse(event: str, data: dict[str, Any]) -> dict[str, str]:
    return {"event": event, "data": json.dumps(data)}


@router.post("/chat")
async def chat(req: ChatRequest, request: Request) -> EventSourceResponse:
    system_prompt = SYSTEM_PROMPTS.get(req.scenario_id)
    if system_prompt is None:
        raise HTTPException(status_code=404, detail=f"Unknown scenario_id: {req.scenario_id}")

    openai = request.app.state.openai
    http_client: httpx.AsyncClient = request.app.state.http_client
    modal_url: str = request.app.state.settings.modal_base_url

    messages: list[dict[str, str]] = [{"role": "system", "content": system_prompt}]
    messages += [{"role": m.role, "content": m.content} for m in req.history]
    messages.append({"role": "user", "content": req.text})

    async def event_generator() -> AsyncIterator[dict[str, str]]:
        queue: asyncio.Queue[tuple[str, Any]] = asyncio.Queue()
        tts_tasks: list[asyncio.Task] = []
        session_status: str | None = None

        async def run_tts(sentence: str, index: int) -> None:
            try:
                result = await tts_client.synthesize(http_client, modal_url, sentence)
                await queue.put(
                    ("audio_chunk", {"audio_b64": result.get("audio_b64", ""), "sentence_index": index})
                )
                await queue.put(
                    ("viseme", {"visemes": result.get("visemes", []), "sentence_index": index})
                )
            except Exception as exc:
                # One failed sentence shouldn't kill the whole stream.
                await queue.put(("audio_error", {"sentence_index": index, "detail": str(exc)}))

        async def produce() -> None:
            nonlocal session_status
            chunker = SentenceChunker()
            index = 0

            def handle(sentence: str) -> None:
                nonlocal index, session_status
                clean = _SESSION_TAG.sub("", sentence)
                match = _SESSION_TAG.search(sentence)
                if match:
                    session_status = match.group(1)
                clean = clean.strip()
                if not clean:
                    return
                queue.put_nowait(("text_delta", {"text": clean}))
                tts_tasks.append(asyncio.create_task(run_tts(clean, index)))
                index += 1

            try:
                stream = await openai.chat.completions.create(
                    model=CHAT_MODEL, messages=messages, stream=True
                )
                async for chunk in stream:
                    if not chunk.choices:
                        continue
                    delta = chunk.choices[0].delta.content or ""
                    if not delta:
                        continue
                    for sentence in chunker.add(delta):
                        handle(sentence)
                tail = chunker.flush()
                if tail:
                    handle(tail)
            except Exception as exc:
                queue.put_nowait(("error", {"detail": str(exc)}))
            finally:
                queue.put_nowait((_PRODUCER_DONE, None))

        producer = asyncio.create_task(produce())
        producer_done = False
        try:
            while True:
                event, data = await queue.get()
                if event == _PRODUCER_DONE:
                    producer_done = True
                else:
                    yield _sse(event, data)
                if producer_done and all(t.done() for t in tts_tasks) and queue.empty():
                    break

            await producer  # surface any unexpected producer crash
            if session_status is not None:
                yield _sse("session_complete", {"status": session_status})
            yield _sse("done", {})
        finally:
            producer.cancel()
            for task in tts_tasks:
                task.cancel()

    return EventSourceResponse(event_generator())
