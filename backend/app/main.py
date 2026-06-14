"""FastAPI application entrypoint: CORS, lifespan clients, routers, health check."""

from __future__ import annotations

from contextlib import asynccontextmanager
from typing import AsyncIterator

import httpx
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from openai import AsyncOpenAI

from app.config import get_settings
from app.routers import chat, scenarios, scoring, stt

# Generous timeout so a Modal cold start (which can take >15s) doesn't abort
# in-flight TTS/STT calls.
_MODAL_TIMEOUT = httpx.Timeout(120.0, connect=10.0)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    settings = get_settings()
    app.state.settings = settings
    app.state.http_client = httpx.AsyncClient(timeout=_MODAL_TIMEOUT)
    app.state.openai = AsyncOpenAI(api_key=settings.openai_api_key)
    try:
        yield
    finally:
        await app.state.http_client.aclose()
        await app.state.openai.close()


app = FastAPI(title="SlickSale API", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=get_settings().allowed_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(scenarios.router)
app.include_router(chat.router)
app.include_router(stt.router)
app.include_router(scoring.router)


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok"}
