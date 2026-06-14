"""POST /score — grade a full conversation with OpenAI Structured Outputs."""

from __future__ import annotations

from fastapi import APIRouter, HTTPException, Request

from app.models.schemas import ScoreRequest, ScoreResponse
from app.scenarios.prompts import SYSTEM_PROMPTS
from app.services.scoring import score_conversation

router = APIRouter()


@router.post("/score", response_model=ScoreResponse)
async def score(req: ScoreRequest, request: Request) -> ScoreResponse:
    if req.scenario_id not in SYSTEM_PROMPTS:
        raise HTTPException(status_code=404, detail=f"Unknown scenario_id: {req.scenario_id}")
    if not req.history:
        raise HTTPException(status_code=400, detail="Conversation history is empty")

    try:
        result = await score_conversation(
            request.app.state.openai,
            req.history,
            req.scenario_id,
            req.user_experience_level,
        )
    except Exception as exc:  # OpenAI / parsing failure
        raise HTTPException(status_code=502, detail=f"Scoring failed: {exc}") from exc

    return ScoreResponse(**result.model_dump())
