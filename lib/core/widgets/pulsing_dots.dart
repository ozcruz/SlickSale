import 'package:flutter/material.dart';

import '../theme.dart';

/// Three pulsing dots (mockup "warmup" pattern). The app-wide loading
/// indicator — never show a bare CircularProgressIndicator on a screen.
class PulsingDots extends StatefulWidget {
  const PulsingDots({super.key, this.size = 8, this.color = AppColors.primary});

  final double size;
  final Color color;

  @override
  State<PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) _dot(i),
          ],
        );
      },
    );
  }

  Widget _dot(int index) {
    // Each dot runs the same pulse, offset by 0.15 of the cycle.
    var phase = _controller.value - index * 0.15;
    if (phase < 0) phase += 1;
    final wave = 1 - (2 * phase - 1).abs(); // 0 -> 1 -> 0 over the cycle
    final eased = Curves.easeInOut.transform(wave);
    final opacity = 0.3 + 0.7 * eased;
    final scale = 0.8 + 0.4 * eased;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: opacity),
          ),
        ),
      ),
    );
  }
}
