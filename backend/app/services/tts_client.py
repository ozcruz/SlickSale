"""Thin async client for the Modal TTS + STT service.

Both endpoints hang off the same MODAL_TTS_URL base. Modal cold starts are slow,
so the shared httpx client is configured with a generous timeout in main.py.
"""

from __future__ import annotations

from typing import Any

import httpx


async def synthesize(client: httpx.AsyncClient, base_url: str, text: str) -> dict[str, Any]:
    """Call Modal POST /synthesize. Returns {audio_b64, sample_rate, visemes}."""
    response = await client.post(f"{base_url}/synthesize", json={"text": text})
    response.raise_for_status()
    return response.json()


async def transcribe(
    client: httpx.AsyncClient,
    base_url: str,
    audio_bytes: bytes,
    filename: str,
    content_type: str,
) -> str:
    """Forward an audio upload to Modal POST /transcribe. Returns the text."""
    files = {"file": (filename, audio_bytes, content_type)}
    response = await client.post(f"{base_url}/transcribe", files=files)
    response.raise_for_status()
    return str(response.json().get("text", ""))
