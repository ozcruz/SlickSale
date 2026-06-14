"""Conversation scoring via OpenAI Structured Outputs.

Structured Outputs guarantee the response conforms to ScoreResult's schema,
unlike the older json_object mode which only guarantees valid JSON.
"""

from __future__ import annotations

from openai import AsyncOpenAI
from pydantic import BaseModel

from app.models.schemas import ChatMessage
from app.scenarios.prompts import SCENARIOS_BY_ID

SCORING_MODEL = "gpt-4o"


class ScoreResult(BaseModel):
    """Schema the LLM must conform to (OpenAI Structured Outputs target)."""

    overall_score: float
    category_scores: dict[str, float]
    feedback: str
    tips: list[str]


def _system_prompt(level: str) -> str:
    return (
        "You are an expert sales coach. Analyze this sales conversation and "
        f"score the seller's performance. The seller's experience level is {level}.\n\n"
        "Score these categories from 0-100:\n"
        "- Objection Handling: how well did they address concerns and pushbacks?\n"
        "- Rapport Building: did they build trust and connection?\n"
        "- Closing Technique: did they move toward a close effectively?\n"
        "- Discovery Questions: did they ask good questions to understand needs?\n"
        "- Active Listening: did they acknowledge and build on what the prospect said?\n\n"
        "Also provide:\n"
        "- An overall score (weighted average, not simple average — weight "
        "Objection Handling and Closing higher for advanced users, Discovery and "
        "Rapport higher for beginners)\n"
        "- A brief feedback summary (3-4 sentences)\n"
        "- 2-3 specific, actionable tips based on what happened in THIS conversation "
        "(not generic advice — reference specific moments from the transcript)"
    )


def _format_transcript(history: list[ChatMessage], scenario_id: str) -> str:
    """Render the conversation with the seller and prospect clearly labeled."""
    scenario = SCENARIOS_BY_ID.get(scenario_id)
    lines: list[str] = []
    if scenario is not None:
        lines.append(
            f"Scenario: {scenario.name} — the prospect is {scenario.character_name}, "
            f"{scenario.character_role}. {scenario.description}"
        )
        lines.append("")
    lines.append("Transcript:")
    for message in history:
        speaker = "Seller" if message.role == "user" else "Prospect"
        lines.append(f"{speaker}: {message.content}")
    return "\n".join(lines)


async def score_conversation(
    client: AsyncOpenAI,
    history: list[ChatMessage],
    scenario_id: str,
    user_experience_level: str,
) -> ScoreResult:
    """Score a full conversation and return the parsed, schema-conformant result."""
    messages = [
        {"role": "system", "content": _system_prompt(user_experience_level)},
        {"role": "user", "content": _format_transcript(history, scenario_id)},
    ]
    completion = await client.beta.chat.completions.parse(
        model=SCORING_MODEL,
        messages=messages,
        response_format=ScoreResult,
    )
    result = completion.choices[0].message.parsed
    if result is None:  # refusal or empty parse — surface a clear error upstream
        raise ValueError("Scoring model returned no parsed result")
    return result
