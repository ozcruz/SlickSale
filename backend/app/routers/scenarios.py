"""GET /scenarios — the public scenario catalog (no system prompts)."""

from __future__ import annotations

from fastapi import APIRouter

from app.models.schemas import ScenarioInfo
from app.scenarios.prompts import SCENARIOS

router = APIRouter()


@router.get("/scenarios", response_model=list[ScenarioInfo])
async def list_scenarios() -> list[ScenarioInfo]:
    return [
        ScenarioInfo(
            id=s.id,
            name=s.name,
            character_name=s.character_name,
            description=s.description,
            difficulty=s.difficulty,
        )
        for s in SCENARIOS
    ]
