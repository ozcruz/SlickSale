"""Phoneme-to-viseme mapping.

The forced-alignment pipeline emits phonemes (IPA when espeak is available) or
falls back to raw graphemes. Either way every symbol must resolve to exactly one
of the 8 viseme IDs the Rive state machine understands:

    0 = REST/SIL   neutral / closed
    1 = AA         mouth wide open      (AA, AH, AE)
    2 = EE         wide smile shape     (EE, IH, IY)
    3 = MM         lips closed          (MM, BM, PP)
    4 = FF         lower lip tuck       (FF, VV)
    5 = OO         rounded              (OO, UW, OH, AO; also RR)
    6 = LL         tongue tip up        (LL, N, T, D)
    7 = SS         teeth close          (SS, ZZ, CH, SH, JH)

Anything unmapped (including TH/DH and KK/GG, which aren't worth a dedicated
shape) falls back to REST.
"""

from __future__ import annotations

# Index = viseme ID; value = the string id sent over the wire / used by Rive.
VISEME_NAMES: list[str] = ["REST", "AA", "EE", "MM", "FF", "OO", "LL", "SS"]

REST, AA, EE, MM, FF, OO, LL, SS = range(8)

# ARPAbet (CMUdict) phonemes plus the shorthand symbols named in the spec.
# Stress digits (AH0/AH1/AH2) are stripped before lookup.
_ARPABET_TO_VISEME: dict[str, int] = {
    # --- vowels ---
    "AA": AA, "AE": AA, "AH": AA, "AX": AA, "AY": AA,
    "EH": EE, "EY": EE, "IH": EE, "IY": EE, "IX": EE, "EE": EE,
    "AO": OO, "AW": OO, "OW": OO, "OY": OO, "UH": OO, "UW": OO, "UX": OO, "OH": OO,
    "ER": OO, "AXR": OO, "RR": OO,
    # --- consonants ---
    "B": MM, "P": MM, "M": MM, "EM": MM, "BM": MM, "PP": MM, "MM": MM,
    "F": FF, "V": FF, "FF": FF, "VV": FF,
    "D": LL, "T": LL, "N": LL, "L": LL, "NG": LL, "NX": LL, "DX": LL,
    "EL": LL, "EN": LL, "LL": LL,
    "S": SS, "Z": SS, "SH": SS, "ZH": SS, "CH": SS, "JH": SS, "ZZ": SS, "SS": SS,
    "W": OO, "WH": OO, "R": OO,
    "Y": EE,
    # explicitly REST: dental fricatives, velars, glottal
    "TH": REST, "DH": REST, "K": REST, "G": REST, "KK": REST, "GG": REST,
    "HH": REST, "H": REST, "Q": REST,
}

# IPA symbols espeak-ng emits for English. Length (ː) and stress (ˈ ˌ) marks are
# stripped before lookup; common diphthongs are listed explicitly.
_IPA_TO_VISEME: dict[str, int] = {
    # --- vowels / diphthongs ---
    "i": EE, "ɪ": EE, "e": EE, "ɛ": EE, "eɪ": EE, "ej": EE,
    "æ": AA, "a": AA, "ɑ": AA, "ɒ": AA, "ʌ": AA, "ə": AA, "ɐ": AA,
    "ɜ": AA, "aɪ": AA, "aj": AA,
    "ɔ": OO, "o": OO, "oʊ": OO, "ow": OO, "ʊ": OO, "u": OO, "ʉ": OO,
    "ɵ": OO, "aʊ": OO, "aw": OO, "ɔɪ": OO, "ɔj": OO, "ɚ": OO, "ɝ": OO,
    # --- consonants ---
    "p": MM, "b": MM, "m": MM,
    "f": FF, "v": FF,
    "t": LL, "d": LL, "n": LL, "l": LL, "ɫ": LL, "ŋ": LL, "ɾ": LL,
    "s": SS, "z": SS, "ʃ": SS, "ʒ": SS, "tʃ": SS, "dʒ": SS, "ts": SS, "dz": SS,
    "w": OO, "r": OO, "ɹ": OO, "ɻ": OO,
    "j": EE,
    # explicitly REST
    "θ": REST, "ð": REST, "k": REST, "ɡ": REST, "g": REST,
    "h": REST, "ʔ": REST, "x": REST, "ç": REST,
}

# Single-letter fallback used when only raw graphemes are available.
_GRAPHEME_TO_VISEME: dict[str, int] = {
    "a": AA, "e": EE, "i": EE, "o": OO, "u": OO, "y": EE,
    "b": MM, "p": MM, "m": MM,
    "f": FF, "v": FF,
    "d": LL, "t": LL, "n": LL, "l": LL,
    "s": SS, "z": SS, "c": SS, "j": SS, "x": SS,
    "w": OO, "r": OO, "q": OO,
    "g": REST, "k": REST, "h": REST,
}

_STRESS_AND_LENGTH = "ˈˌˑːʲʷˠˤ̃ʰ'"


def viseme_name(viseme_id: int) -> str:
    """Return the wire/Rive string id for a numeric viseme id (REST if out of range)."""
    if 0 <= viseme_id < len(VISEME_NAMES):
        return VISEME_NAMES[viseme_id]
    return VISEME_NAMES[REST]


def phoneme_to_viseme(phoneme: str) -> int:
    """Map a single phoneme (ARPAbet or IPA) or grapheme to a viseme id.

    Tries ARPAbet first (stress-stripped, upper-cased), then IPA, then a raw
    single-letter fallback. Unknown symbols resolve to REST so the avatar never
    freezes on an unmapped sound.
    """
    if not phoneme:
        return REST
    raw = phoneme.strip()
    if not raw:
        return REST

    # ARPAbet: drop trailing stress digits, upper-case.
    arpa = raw.upper().rstrip("0123456789")
    if arpa in _ARPABET_TO_VISEME:
        return _ARPABET_TO_VISEME[arpa]

    # IPA: strip stress / length / diacritic marks, try whole then first symbol.
    ipa = "".join(c for c in raw if c not in _STRESS_AND_LENGTH)
    if ipa in _IPA_TO_VISEME:
        return _IPA_TO_VISEME[ipa]
    if ipa and ipa[0] in _IPA_TO_VISEME:
        return _IPA_TO_VISEME[ipa[0]]

    # Grapheme fallback.
    low = raw.lower()
    if low in _GRAPHEME_TO_VISEME:
        return _GRAPHEME_TO_VISEME[low]
    if low and low[0] in _GRAPHEME_TO_VISEME:
        return _GRAPHEME_TO_VISEME[low[0]]

    return REST


def phoneme_to_viseme_name(phoneme: str) -> str:
    """Convenience: map a phoneme straight to its viseme string id."""
    return viseme_name(phoneme_to_viseme(phoneme))
