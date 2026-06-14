"""Manual smoke test for the SlickSale backend.

Assumes the server is running on localhost:8000 (override with BACKEND_URL) and
that OPENAI_API_KEY and MODAL_TTS_URL are configured. Run with:

    python test_chat.py
"""

from __future__ import annotations

import json
import os
from collections import Counter

import httpx

BASE_URL = os.environ.get("BACKEND_URL", "http://localhost:8000")
SCENARIO_ID = "skeptical_cfo"


def _rule(title: str) -> None:
    print(f"\n{'=' * 60}\n{title}\n{'=' * 60}")


def test_scenarios(client: httpx.Client) -> None:
    _rule("GET /scenarios")
    resp = client.get(f"{BASE_URL}/scenarios")
    resp.raise_for_status()
    for scenario in resp.json():
        print(
            f"  {scenario['id']:<18} {scenario['name']:<24} "
            f"{scenario['characterName']:<8} [{scenario['difficulty']}]"
        )


def _iter_sse(resp: httpx.Response):
    """Yield (event, data_dict) pairs from an SSE response."""
    event = "message"
    data_lines: list[str] = []
    for line in resp.iter_lines():
        if line == "":  # event delimiter
            if data_lines:
                raw = "\n".join(data_lines)
                try:
                    data = json.loads(raw)
                except json.JSONDecodeError:
                    data = {"raw": raw}
                yield event, data
            event, data_lines = "message", []
        elif line.startswith(":"):
            continue  # comment / keep-alive
        elif line.startswith("event:"):
            event = line[len("event:"):].strip()
        elif line.startswith("data:"):
            data_lines.append(line[len("data:"):].strip())


def test_chat(client: httpx.Client) -> None:
    _rule("POST /chat (SSE stream)")
    payload = {
        "text": "Hi Jamie, I'd love 15 minutes to show how our CRM cuts your sales cycle.",
        "history": [],
        "scenario_id": SCENARIO_ID,
    }
    counts: Counter[str] = Counter()
    with client.stream("POST", f"{BASE_URL}/chat", json=payload) as resp:
        resp.raise_for_status()
        for event, data in _iter_sse(resp):
            counts[event] += 1
            if event == "text_delta":
                print(f"  [text_delta]  {data['text']}")
            elif event == "audio_chunk":
                b64 = data.get("audio_b64", "")
                print(f"  [audio_chunk] sentence={data['sentence_index']} audio_b64={len(b64)} chars")
            elif event == "viseme":
                print(f"  [viseme]      sentence={data['sentence_index']} visemes={len(data.get('visemes', []))}")
            elif event == "done":
                print("  [done]")
            else:
                print(f"  [{event}] {data}")
    print(f"\n  event totals: {dict(counts)}")
    for required in ("text_delta", "audio_chunk", "viseme"):
        assert counts[required] > 0, f"missing {required} events"


def test_score(client: httpx.Client) -> None:
    _rule("POST /score")
    payload = {
        "scenario_id": SCENARIO_ID,
        "user_experience_level": "intermediate",
        "history": [
            {"role": "user", "content": "Hi Jamie, thanks for the time. What's your biggest CRM headache today?"},
            {"role": "assistant", "content": "Honestly? Cost. We're not paying more for features we won't use."},
            {"role": "user", "content": "Fair. If I showed a 3-month payback from shorter sales cycles, would that change things?"},
            {"role": "assistant", "content": "Maybe. But integration with our stack worries me more than payback math."},
            {"role": "user", "content": "We integrate natively with your ERP, so there's no migration cost. Want to see it live?"},
        ],
    }
    resp = client.post(f"{BASE_URL}/score", json=payload)
    resp.raise_for_status()
    score = resp.json()
    print(f"  overall_score : {score['overall_score']}")
    print("  category_scores:")
    for category, value in score["category_scores"].items():
        print(f"    - {category}: {value}")
    print(f"  feedback      : {score['feedback']}")
    print("  tips:")
    for tip in score["tips"]:
        print(f"    - {tip}")


def main() -> None:
    print(f"Testing backend at {BASE_URL}")
    # Long read timeout: /chat waits on Modal TTS, which can cold-start slowly.
    with httpx.Client(timeout=httpx.Timeout(180.0, connect=10.0)) as client:
        test_scenarios(client)
        test_chat(client)
        test_score(client)
    print("\nAll checks passed.")


if __name__ == "__main__":
    main()
