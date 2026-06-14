/// The 8 Rive visemes, indexed exactly as the `avatar.riv` state machine's
/// integer `visemeID` input expects (0=REST … 7=SS). See
/// .claude/rules/rive-lipsync.md. The backend emits the string ids; the
/// scheduler converts to these indices before driving the avatar.
const List<String> visemeNames = [
  'REST', // 0
  'AA', // 1
  'EE', // 2
  'MM', // 3
  'FF', // 4
  'OO', // 5
  'LL', // 6
  'SS', // 7
];

/// The neutral / mouth-closed viseme — the resting state between sentences.
const int restVisemeId = 0;

/// Maps a wire viseme id ("AA", "OO", …) to its Rive integer. Unknown ids
/// fall back to REST so the avatar never freezes on an unmapped sound.
int visemeIdFromName(String name) {
  final index = visemeNames.indexOf(name);
  return index < 0 ? restVisemeId : index;
}
