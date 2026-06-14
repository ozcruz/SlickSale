"""Streaming sentence chunker for TTS.

Accumulates streamed LLM tokens and yields complete sentences as soon as a real
sentence boundary appears. A boundary is a run of .!? followed by whitespace,
EXCEPT:

  * abbreviations  — "Mr.", "Mrs.", "Dr.", "Inc." ...
  * decimals       — "3.5", "$10.99"  (dot is followed by a digit, not space)
  * ellipsis       — "..."            (a run of two or more dots)

Bad chunking produces weird TTS pauses, so these exceptions matter. Example:
"Dr. Smith said the ROI is 3.5x. That's impressive." -> 2 sentences, not 4.
"""

from __future__ import annotations

import re

# Words that legitimately end in a period and should NOT end a sentence.
_ABBREVIATIONS: frozenset[str] = frozenset(
    {
        "mr", "mrs", "ms", "dr", "prof", "sr", "jr", "st",
        "vs", "inc", "ltd", "co", "corp", "etc", "approx", "dept",
        "fig", "no", "vol", "rev", "gen", "gov", "sen",
    }
)

# A run of one or more sentence terminators.
_TERMINATORS = re.compile(r"[.!?]+")


def _preceding_word(text: str, dot_index: int) -> str:
    """The alphabetic word immediately before the character at dot_index."""
    i = dot_index - 1
    chars: list[str] = []
    while i >= 0 and text[i].isalpha():
        chars.append(text[i])
        i -= 1
    return "".join(reversed(chars))


class SentenceChunker:
    """Feed it streamed text; it hands back complete sentences."""

    def __init__(self) -> None:
        self._buffer = ""

    def add(self, text: str) -> list[str]:
        """Append streamed text and return any sentences that are now complete."""
        self._buffer += text
        sentences: list[str] = []
        while True:
            cut = self._find_boundary()
            if cut is None:
                break
            sentence = self._buffer[:cut].strip()
            if sentence:
                sentences.append(sentence)
            self._buffer = self._buffer[cut:].lstrip()
        return sentences

    def flush(self) -> str | None:
        """Return whatever text remains (the final sentence), then clear."""
        remaining = self._buffer.strip()
        self._buffer = ""
        return remaining or None

    def _find_boundary(self) -> int | None:
        """Index just past the first real terminator run, or None if none yet."""
        for match in _TERMINATORS.finditer(self._buffer):
            end = match.end()
            # Terminator at the very end of the buffer: we can't tell yet whether
            # it's a real boundary (more tokens may follow), so wait.
            if end >= len(self._buffer):
                continue
            # Must be followed by whitespace. This is what naturally excludes
            # decimals ("3.5" -> dot is followed by a digit).
            if not self._buffer[end].isspace():
                continue
            run = match.group()
            # Ellipsis: two or more dots with no ! or ? is a pause, not an end.
            if set(run) == {"."} and len(run) >= 2:
                continue
            # Single dot: skip if it closes a known abbreviation.
            if run == "." and _preceding_word(self._buffer, match.start()).lower() in _ABBREVIATIONS:
                continue
            return end
        return None
