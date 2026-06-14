// The simulation screen — the product's core experience. A user practices a
// live, voice-driven sales conversation against a lip-synced Rive avatar.
//
// Built from the mockup "Simulation" + "Warmup" sections with the elevation
// directives applied: fade-from-black entrance, an ambient pulse on the avatar
// backdrop, slide-up chat bubbles, character-by-character streaming text with a
// blinking cursor, a pulsing/rippling mic button, AnimatedSwitcher state
// crossfades, and a fade-to-white hand-off into the scorecard.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/focus_ring.dart';
import '../../../core/widgets/pulsing_dots.dart';
import '../../dashboard/domain/scenario.dart';
import '../data/simulation_exception.dart';
import '../domain/chat_message.dart';
import '../domain/simulation_state.dart';
import 'rive_avatar.dart';
import 'rive_avatar_controller.dart';
import 'simulation_controller.dart';
import 'simulation_ui_state.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key, required this.scenarioId});

  final String scenarioId;

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  bool _entered = false;
  bool _ending = false;

  @override
  void initState() {
    super.initState();
    // Fade in from black once the first frame is up (entrance directive).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entered = true);
    });
  }

  SimulationControllerProvider get _provider =>
      simulationControllerProvider(widget.scenarioId);

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _endSession() async {
    if (_ending) return;
    setState(() => _ending = true);
    try {
      final sessionId = await ref.read(_provider.notifier).endSession();
      if (!mounted) return;
      if (sessionId != null) {
        context.go(RoutePaths.scorecardPath(sessionId));
      } else {
        context.go(RoutePaths.dashboard);
      }
    } on SimulationException catch (error) {
      if (!mounted) return;
      setState(() => _ending = false);
      _showSnack(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _ending = false);
      _showSnack('Something went wrong ending the session.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final scenario = ref.watch(scenarioByIdProvider(widget.scenarioId));

    // Surface recoverable errors as a snackbar, then clear so they fire once.
    ref.listen(_provider.select((s) => s.errorMessage), (_, message) {
      if (message != null && message.isNotEmpty) {
        _showSnack(message);
        ref.read(_provider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.simulationBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: AppMotion.slow,
              switchInCurve: AppMotion.curve,
              child: _body(state, scenario),
            ),
          ),
          // Entrance: black veil that fades out on first frame.
          IgnorePointer(
            ignoring: _entered,
            child: AnimatedOpacity(
              opacity: _entered ? 0 : 1,
              duration: AppMotion.slow,
              child: const ColoredBox(
                color: Colors.black,
                child: SizedBox.expand(),
              ),
            ),
          ),
          // End-session: fade to white, then the scorecard loads.
          if (_ending) const _EndingVeil(),
        ],
      ),
    );
  }

  Widget _body(SimulationUiState state, Scenario? scenario) {
    switch (state.status) {
      case SimulationState.loading:
      case SimulationState.warmingUp:
        return const _WarmingUpView(key: ValueKey('warmup'));
      case SimulationState.error:
        return _WarmupErrorView(
          key: const ValueKey('error'),
          message: state.errorMessage,
          onRetry: () => ref.read(_provider.notifier).retry(),
        );
      case SimulationState.ready:
      case SimulationState.listening:
      case SimulationState.processing:
      case SimulationState.avatarSpeaking:
      case SimulationState.ended:
        return _ConversationView(
          key: const ValueKey('conversation'),
          state: state,
          scenario: scenario,
          avatarController: ref.read(_provider.notifier).avatarController,
          onMicTap: () => ref.read(_provider.notifier).toggleMic(),
          onEnableMic: () => ref.read(_provider.notifier).toggleMic(),
          onEnd: _endSession,
        );
    }
  }
}

// ============================================================ warming up view

class _WarmingUpView extends StatelessWidget {
  const _WarmingUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dots inside a soft primary glow (warmup elevation).
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: const [_GlowOrb(), PulsingDots(size: 10)],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Warming up your coach…', style: AppTextStyles.subheading),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Spinning up the voice — this only takes a moment.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A slow-breathing radial glow used behind the warmup dots.
class _GlowOrb extends StatefulWidget {
  const _GlowOrb();

  @override
  State<_GlowOrb> createState() => _GlowOrbState();
}

class _GlowOrbState extends State<_GlowOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.10 + 0.12 * t),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================== error view

class _WarmupErrorView extends StatelessWidget {
  const _WarmupErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 44,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                "Couldn't start the session",
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message ?? 'Please check your connection and try again.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'Try again', onPressed: onRetry),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Back to dashboard',
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go(RoutePaths.dashboard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================== conversation view

class _ConversationView extends StatelessWidget {
  const _ConversationView({
    super.key,
    required this.state,
    required this.scenario,
    required this.avatarController,
    required this.onMicTap,
    required this.onEnableMic,
    required this.onEnd,
  });

  final SimulationUiState state;
  final Scenario? scenario;
  final RiveAvatarController avatarController;
  final VoidCallback onMicTap;
  final VoidCallback onEnableMic;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final scenario = this.scenario;
    final characterName = scenario?.characterName ?? 'Coach';
    final title = scenario == null
        ? 'Practice session'
        : '${scenario.name} · ${scenario.characterName}';

    return SafeArea(
      child: Column(
        children: [
          _TopBar(title: title, onEnd: onEnd),
          _AvatarArea(controller: avatarController),
          Expanded(
            child: _ChatLog(
              messages: state.messages,
              characterName: characterName,
            ),
          ),
          _MicArea(
            state: state,
            characterName: characterName,
            onMicTap: onMicTap,
            onEnableMic: onEnableMic,
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onEnd});

  final String title;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _EndSessionButton(onTap: onEnd),
        ],
      ),
    );
  }
}

// =============================================================== avatar area

class _AvatarArea extends StatefulWidget {
  const _AvatarArea({required this.controller});

  final RiveAvatarController controller;

  @override
  State<_AvatarArea> createState() => _AvatarAreaState();
}

class _AvatarAreaState extends State<_AvatarArea>
    with SingleTickerProviderStateMixin {
  // Ambient pulse: backdrop opacity drifts 0.06 -> 0.10 over a 4s cycle so the
  // scene feels alive even at rest (elevation directive).
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_pulse.value);
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.75,
                colors: [
                  AppColors.primary.withValues(alpha: 0.06 + 0.04 * t),
                  Colors.transparent,
                ],
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: RiveAvatar(controller: widget.controller),
          ),
        ),
      ),
    );
  }
}

// ================================================================== chat log

class _ChatLog extends StatefulWidget {
  const _ChatLog({required this.messages, required this.characterName});

  final List<ChatMessage> messages;
  final String characterName;

  @override
  State<_ChatLog> createState() => _ChatLogState();
}

class _ChatLogState extends State<_ChatLog> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _toBottom(animate: false),
    );
  }

  @override
  void didUpdateWidget(_ChatLog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // messages is a fresh list only when content actually changed.
    if (!identical(oldWidget.messages, widget.messages)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
    }
  }

  void _toBottom({bool animate = true}) {
    if (!_scroll.hasClients) return;
    final target = _scroll.position.maxScrollExtent;
    if (animate) {
      _scroll.animateTo(
        target,
        duration: AppMotion.medium,
        curve: AppMotion.curve,
      );
    } else {
      _scroll.jumpTo(target);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return const SizedBox.shrink();
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView.separated(
          controller: _scroll,
          padding: const EdgeInsets.all(AppSpacing.xl),
          itemCount: widget.messages.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final message = widget.messages[index];
            return _ChatBubble(
              key: ValueKey(message.timestamp.microsecondsSinceEpoch),
              message: message,
              characterName: widget.characterName,
            );
          },
        ),
      ),
    );
  }
}

class _ChatBubble extends StatefulWidget {
  const _ChatBubble({
    super.key,
    required this.message,
    required this.characterName,
  });

  final ChatMessage message;
  final String characterName;

  @override
  State<_ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<_ChatBubble>
    with SingleTickerProviderStateMixin {
  // Slide-up + fade-in entrance (200ms) as the bubble appears.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
  )..forward();
  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _entrance,
    curve: AppMotion.curve,
  );

  @override
  void dispose() {
    _curved.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == ChatRole.user;
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : AppColors.surfaceElevated,
        borderRadius: AppRadii.lgRadius,
        border: isUser ? null : Border.all(color: AppColors.border),
      ),
      child: isUser
          ? Text(
              widget.message.content,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textOnPrimary,
              ),
            )
          : _StreamingText(
              text: widget.message.content,
              streaming: widget.message.isStreaming,
              style: AppTextStyles.body,
            ),
    );

    return FadeTransition(
      opacity: _curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(_curved),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Text(widget.characterName, style: AppTextStyles.overline),
              const SizedBox(height: AppSpacing.xs),
            ],
            bubble,
          ],
        ),
      ),
    );
  }
}

/// Reveals [text] character-by-character with a blinking cursor while more is
/// arriving — the streaming-text elevation. Keeps revealing across rebuilds so
/// the cursor flows naturally as deltas land.
class _StreamingText extends StatefulWidget {
  const _StreamingText({
    required this.text,
    required this.streaming,
    required this.style,
  });

  final String text;
  final bool streaming;
  final TextStyle style;

  @override
  State<_StreamingText> createState() => _StreamingTextState();
}

class _StreamingTextState extends State<_StreamingText>
    with SingleTickerProviderStateMixin {
  int _shown = 0;
  Timer? _reveal;
  late final AnimationController _cursor = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _shown = widget.streaming ? 0 : widget.text.length;
    _ensureRevealing();
  }

  @override
  void didUpdateWidget(_StreamingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text.length < _shown) {
      _shown = widget.text.length; // text was replaced/shrunk
    }
    _ensureRevealing();
  }

  void _ensureRevealing() {
    if (_shown >= widget.text.length) {
      _reveal?.cancel();
      _reveal = null;
      return;
    }
    _reveal ??= Timer.periodic(const Duration(milliseconds: 32), (_) {
      if (!mounted) return;
      if (_shown >= widget.text.length) {
        _reveal?.cancel();
        _reveal = null;
        setState(() {});
        return;
      }
      // Reveal one char normally, more when far behind so we never lag badly.
      final remaining = widget.text.length - _shown;
      setState(() => _shown += remaining > 60 ? (remaining ~/ 30) : 1);
    });
  }

  @override
  void dispose() {
    _reveal?.cancel();
    _cursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.text.substring(
      0,
      _shown.clamp(0, widget.text.length),
    );
    final showCursor = widget.streaming || _shown < widget.text.length;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: visible, style: widget.style),
          if (showCursor)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: AnimatedBuilder(
                animation: _cursor,
                builder: (context, _) => Opacity(
                  opacity: _cursor.value < 0.5 ? 1 : 0,
                  child: Container(
                    width: 2,
                    height: (widget.style.fontSize ?? 14) * 1.1,
                    margin: const EdgeInsets.only(left: 2),
                    color: AppColors.primaryHover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =================================================================== mic area

class _MicArea extends StatelessWidget {
  const _MicArea({
    required this.state,
    required this.characterName,
    required this.onMicTap,
    required this.onEnableMic,
  });

  final SimulationUiState state;
  final String characterName;
  final VoidCallback onMicTap;
  final VoidCallback onEnableMic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      child: state.micDenied
          ? _MicDeniedPrompt(onEnable: onEnableMic)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MicButton(
                  status: state.status,
                  enabled: state.canToggleMic,
                  onTap: onMicTap,
                ),
                const SizedBox(height: AppSpacing.md),
                _MicHint(state: state, characterName: characterName),
              ],
            ),
    );
  }
}

class _MicHint extends StatelessWidget {
  const _MicHint({required this.state, required this.characterName});

  final SimulationUiState state;
  final String characterName;

  @override
  Widget build(BuildContext context) {
    final String label;
    if (state.prospectEndedCall) {
      label = 'Call ended — end the session to see your score';
    } else {
      label = switch (state.status) {
        SimulationState.listening => 'Listening… tap to send',
        SimulationState.processing => 'Thinking…',
        SimulationState.avatarSpeaking => '$characterName is speaking…',
        _ => 'Tap to speak',
      };
    }
    return AnimatedSwitcher(
      duration: AppMotion.tabFade,
      child: Text(
        label,
        key: ValueKey(label),
        style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
      ),
    );
  }
}

class _MicButton extends StatefulWidget {
  const _MicButton({
    required this.status,
    required this.enabled,
    required this.onTap,
  });

  final SimulationState status;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton> with TickerProviderStateMixin {
  bool _hovered = false;

  // Continuous breathing ring while recording.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );
  // One-shot ripple when the user taps.
  late final AnimationController _ripple = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );

  bool get _recording => widget.status == SimulationState.listening;

  @override
  void initState() {
    super.initState();
    if (_recording) _pulse.repeat();
  }

  @override
  void didUpdateWidget(_MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_recording && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!_recording && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    _ripple.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    _ripple.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = widget.status == SimulationState.processing;
    final background = _recording
        ? AppColors.error
        : (widget.enabled
              ? (_hovered ? AppColors.primaryHover : AppColors.primary)
              : AppColors.surfaceElevated);

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_recording)
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) =>
                      _Ring(progress: _pulse.value, color: AppColors.error),
                ),
              AnimatedBuilder(
                animation: _ripple,
                builder: (context, _) => _ripple.isAnimating
                    ? _Ring(progress: _ripple.value, color: AppColors.primary)
                    : const SizedBox.shrink(),
              ),
              AnimatedScale(
                scale: _hovered && widget.enabled && !_recording ? 1.05 : 1,
                duration: AppMotion.hover,
                child: AnimatedContainer(
                  duration: AppMotion.hover,
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: AppMotion.fast,
                    child: isProcessing
                        ? const SizedBox(
                            key: ValueKey('spin'),
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : Icon(
                            _recording ? Icons.stop_rounded : Icons.mic_rounded,
                            key: ValueKey(_recording),
                            color: widget.enabled || _recording
                                ? AppColors.textOnPrimary
                                : AppColors.textTertiary,
                            size: 26,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An expanding, fading ring used for the mic pulse and tap ripple.
class _Ring extends StatelessWidget {
  const _Ring({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = 64 + 56 * progress;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.35 * (1 - progress)),
      ),
    );
  }
}

class _MicDeniedPrompt extends StatelessWidget {
  const _MicDeniedPrompt({required this.onEnable});

  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mic_off_rounded,
            size: 32,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Microphone access is needed to practice. Enable it in your '
            'browser, then try again.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Enable microphone',
            size: AppButtonSize.medium,
            expand: false,
            icon: const Icon(
              Icons.mic_rounded,
              size: 16,
              color: AppColors.textOnPrimary,
            ),
            onPressed: onEnable,
          ),
        ],
      ),
    );
  }
}

// ============================================================ shared widgets

/// Fade-to-white veil shown while the session is scored, then the scorecard
/// loads behind it (end-session transition directive).
class _EndingVeil extends StatefulWidget {
  const _EndingVeil();

  @override
  State<_EndingVeil> createState() => _EndingVeilState();
}

class _EndingVeilState extends State<_EndingVeil> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _shown ? 1 : 0,
      duration: AppMotion.slow,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PulsingDots(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Scoring your session…',
                style: AppTextStyles.body.copyWith(color: AppColors.background),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mockup `.sim-end-btn`: an unobtrusive error-muted pill (placed to avoid
/// accidental taps).
class _EndSessionButton extends StatefulWidget {
  const _EndSessionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_EndSessionButton> createState() => _EndSessionButtonState();
}

class _EndSessionButtonState extends State<_EndSessionButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusRing(
      focused: _focused,
      borderRadius: AppRadii.mdRadius,
      child: AnimatedContainer(
        duration: AppMotion.hover,
        decoration: BoxDecoration(
          color: _hovered ? AppColors.errorMutedBorder : AppColors.errorMuted,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: AppColors.errorMutedBorder),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadii.mdRadius,
            splashFactory: NoSplash.splashFactory,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            onHover: (hovered) => setState(() => _hovered = hovered),
            onFocusChange: (focused) =>
                setState(() => _focused = focused && keyboardFocusVisible),
            child: Padding(
              padding: AppComponentMetrics.pillPadding,
              child: Text(
                'End Session',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
