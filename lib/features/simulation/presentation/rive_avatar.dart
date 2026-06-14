import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import 'rive_avatar_controller.dart';

/// Renders `avatar.riv` and lip-syncs it. Loads with `Factory.rive` (the Rive
/// renderer — NOT `Factory.flutter`; this matters for viseme rendering, per
/// .claude/rules/rive-lipsync.md) and drives the single integer `visemeID`
/// state-machine input from [controller].
///
/// If the file or runtime fails to load, it shows a calm fallback orb instead
/// of crashing — the rest of the simulation (voice, chat, scoring) keeps
/// working without lip-sync.
class RiveAvatar extends StatefulWidget {
  const RiveAvatar({super.key, required this.controller});

  final RiveAvatarController controller;

  @override
  State<RiveAvatar> createState() => _RiveAvatarState();
}

class _RiveAvatarState extends State<RiveAvatar> {
  File? _file;
  RiveWidgetController? _riveController;
  NumberInput? _visemeInput;
  int _lastWritten = -1;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_applyViseme);
    _load();
  }

  Future<void> _load() async {
    try {
      final file = await File.asset(
        AppAssets.avatarRive,
        riveFactory: Factory.rive,
      );
      if (!mounted) {
        file?.dispose();
        return;
      }
      if (file == null) {
        setState(() => _failed = true);
        return;
      }
      final controller = RiveWidgetController(file);
      // avatar.riv lip-syncs via a state-machine integer input named
      // `visemeID` (see .claude/rules/rive-lipsync.md). The newer data-binding
      // API doesn't apply here — this file exposes an input, not a view model —
      // so the (doc-)deprecated input accessor is the correct, intended tool.
      // ignore: deprecated_member_use
      final visemeInput = controller.stateMachine.number('visemeID');
      setState(() {
        _file = file;
        _riveController = controller;
        _visemeInput = visemeInput;
      });
      _applyViseme();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  /// Writes the current viseme into Rive, change-gated so a duplicate value
  /// never re-triggers the state machine (would jitter the Breath layer).
  void _applyViseme() {
    final input = _visemeInput;
    if (input == null) return;
    final id = widget.controller.visemeId;
    if (id == _lastWritten) return;
    _lastWritten = id;
    input.value = id.toDouble();
  }

  @override
  void didUpdateWidget(RiveAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_applyViseme);
      widget.controller.addListener(_applyViseme);
      _lastWritten = -1;
      _applyViseme();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_applyViseme);
    _visemeInput?.dispose();
    _riveController?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _riveController;
    if (_failed || controller == null) {
      return const _AvatarFallback();
    }
    return RiveWidget(controller: controller, fit: Fit.contain);
  }
}

/// Shown while the avatar loads or if it fails — a soft orb that matches the
/// avatar area's backdrop so the screen never looks broken.
class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 168,
        height: 168,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.primaryMutedBorder, width: 2),
        ),
        child: const Icon(
          Icons.person_rounded,
          size: 72,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
