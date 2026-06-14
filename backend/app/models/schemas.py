"""Pydantic request/response models and SSE event payloads."""

from __future__ import annotations

from pydantic import BaseModel, Field


class ChatMessage(BaseModel):
    """One turn of conversation. role is "user" (seller) or "assistant" (prospect)."""

    role: str
    content: str


class ChatRequest(BaseModel):
    text: str
    history: list[ChatMessage] = Field(default_factory=list)
    scenario_id: str


# /transcribe receives a multipart file upload (handled via UploadFile in the
# router), so there is no request body model — only this response shape.
class TranscribeResponse(BaseModel):
    text: str


class ScoreRequest(BaseModel):
    history: list[ChatMessage]
    scenario_id: str
    user_experience_level: str


class ScoreResponse(BaseModel):
    overall_score: float
    category_scores: dict[str, float]
    feedback: str
    tips: list[str]


class ScenarioInfo(BaseModel):
    """Client-facing scenario metadata. System prompts are never exposed."""

    id: str
    name: str
    character_name: str = Field(serialization_alias="characterName")
    description: str
    difficulty: str


class VisemeEvent(BaseModel):
    id: str
    start_ms: int
    duration_ms: int


# ---- SSE event data payloads (serialized into the `data:` field) ----
class TextDelta(BaseModel):
    text: str


class AudioChunk(BaseModel):
    audio_b64: str
    sentence_index: int


class VisemeData(BaseModel):
    visemes: list[VisemeEvent]
    sentence_index: int


class Done(BaseModel):
    pass
