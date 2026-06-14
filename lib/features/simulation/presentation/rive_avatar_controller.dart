import 'package:flutter/foundation.dart';

/// The bridge between the [VisemeScheduler] (timing) and the [RiveAvatar]
/// widget (rendering). The scheduler calls [setViseme]; the widget listens and
/// writes the value into the Rive `visemeID` input.
///
/// Critical (see .claude/rules/rive-lipsync.md): only notify when the value
/// actually CHANGES. Writing the input every tick re-evaluates the state
/// machine and micro-resets the Breath layer, causing visible chest vibration.
/// This is the first of two change-gates — the widget gates the native write
/// again as a safety net.
class RiveAvatarController extends ChangeNotifier {
  int _visemeId = 0;

  int get visemeId => _visemeId;

  void setViseme(int id) {
    if (id == _visemeId) return;
    _visemeId = id;
    notifyListeners();
  }
}
