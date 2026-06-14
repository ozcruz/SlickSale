"""The practice scenarios and their LLM system prompts.

Single source of truth for both the public scenario catalog (GET /scenarios)
and the system prompts that drive the chat (never exposed to the client).
Mirrors the Phase 2 frontend catalog in lib/features/dashboard/domain/scenario.dart.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class ScenarioDef:
    id: str
    name: str
    character_name: str
    character_role: str
    description: str
    difficulty: str  # "beginner" | "intermediate" | "advanced"
    system_prompt: str


SCENARIOS: list[ScenarioDef] = [
    ScenarioDef(
        id="skeptical_cfo",
        name="The Skeptical CFO",
        character_name="Jamie",
        character_role="CFO",
        description=(
            "Jamie is the CFO at a 200-person SaaS company. You're pitching "
            "your CRM solution. Expect pushback on price, integrations, and "
            "ROI. Jamie is direct and doesn't suffer fluff."
        ),
        difficulty="intermediate",
        system_prompt=(
            "You are Jamie, a skeptical CFO at a 200-person SaaS company. "
            "The seller is pitching a CRM. Push back on price, integrations, "
            "and ROI. Stay in character. Be terse and analytical. "
            "Don't be easily convinced — make them work for it. Ask pointed "
            "questions about implementation timeline and hidden costs."
        ),
    ),
    ScenarioDef(
        id="gatekeeper",
        name="The Gatekeeper",
        character_name="Alex",
        character_role="EA",
        description=(
            "Alex is an executive assistant at a Fortune 500 company. Your "
            "job is to get past them to the decision maker. Alex is polite "
            "but firm — they've heard every trick."
        ),
        difficulty="beginner",
        system_prompt=(
            "You are Alex, an executive assistant at a Fortune 500 company. "
            "Block cold callers politely but firmly. You've heard every "
            "sales trick. If the caller is genuinely compelling and "
            "respectful, you might transfer them — but make them earn it. "
            "Never break character."
        ),
    ),
    ScenarioDef(
        id="budget_objection",
        name="The Budget Objection",
        character_name="Morgan",
        character_role="VP Ops",
        description=(
            "Morgan is the VP of Operations. They're interested in your "
            "product but hit you with 'we don't have budget right now.' "
            "Classic stall. Can you reframe the value?"
        ),
        difficulty="advanced",
        system_prompt=(
            "You are Morgan, VP of Operations at a mid-size company. You're "
            "genuinely interested in the seller's product but your budget "
            "is tight. Default to 'we don't have budget right now' and "
            "'let's revisit next quarter.' If the seller reframes the "
            "conversation around ROI, cost of inaction, or flexible payment "
            "terms convincingly, start warming up. Be realistic — don't "
            "cave easily but don't be unreasonable either."
        ),
    ),
]

SCENARIOS_BY_ID: dict[str, ScenarioDef] = {s.id: s for s in SCENARIOS}

# scenario_id -> system prompt string (used by the chat router).
SYSTEM_PROMPTS: dict[str, str] = {s.id: s.system_prompt for s in SCENARIOS}
