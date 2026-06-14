"""POST /transcribe — forward an audio upload to Modal's self-hosted Whisper."""

from __future__ import annotations

import httpx
from fastapi import APIRouter, File, HTTPException, Request, UploadFile

from app.models.schemas import TranscribeResponse
from app.services import tts_client

router = APIRouter()


@router.post("/transcribe", response_model=TranscribeResponse)
async def transcribe(request: Request, file: UploadFile = File(...)) -> TranscribeResponse:
    settings = request.app.state.settings
    client: httpx.AsyncClient = request.app.state.http_client

    audio_bytes = await file.read()
    if not audio_bytes:
        raise HTTPException(status_code=400, detail="Empty audio upload")

    try:
        text = await tts_client.transcribe(
            client,
            settings.modal_base_url,
            audio_bytes,
            file.filename or "audio.webm",
            file.content_type or "audio/webm",
        )
    except httpx.HTTPStatusError as exc:
        raise HTTPException(
            status_code=502, detail=f"Transcription service error: {exc.response.status_code}"
        ) from exc
    except httpx.HTTPError as exc:
        raise HTTPException(status_code=504, detail=f"Transcription service unreachable: {exc}") from exc

    return TranscribeResponse(text=text)
