import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

/// Mockup `.streak-bar` (engagement directive: streaks displayed
/// prominently, and a broken streak should read as a loss). Three states:
/// - active & practiced today: celebrate, keep rolling
/// - active & not yet today: urgency to practice before the day ends
/// - broken (no session today or yesterday): "Start a new streak"
/// The flame pulses (1.0 -> 1.1, 2s loop) while a streak is alive and sits
/// dimmed when it's broken.
class StreakBar extends StatelessWidget {
  const StreakBar({
    super.key,
    required this.streak,
    required this.practicedToday,
  });

  final int streak;
  final bool practicedToday;

  bool get _alive => streak > 0;

  String get _title =>
      _alive ? '$streak-day streak' : 'Start a new streak';

  String get _subtitle {
    if (!_alive) return 'Practice today to get back on track.';
    if (practicedToday) return 'You practiced today — keep it rolling.';
    return 'Keep it going! Practice today to stay on track.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (_alive)
            const _PulsingFlame()
          else
            const Opacity(opacity: AppMotion.disabledOpacity, child: _Flame()),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  _subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Flame extends StatelessWidget {
  const _Flame();

  @override
  Widget build(BuildContext context) {
    return const Text('🔥', style: TextStyle(fontSize: 24));
  }
}

class _PulsingFlame extends StatefulWidget {
  const _PulsingFlame();

  @override
  State<_PulsingFlame> createState() => _PulsingFlameState();
}

class _PulsingFlameState extends State<_PulsingFlame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.pulse,
  )..repeat(reverse: true);
  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: AppMotion.pulseScale,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: const _Flame());
  }
}
