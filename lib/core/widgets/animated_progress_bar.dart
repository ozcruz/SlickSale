import 'package:flutter/material.dart';

import '../theme.dart';

/// Mockup `.progress-bar` + `.progress-fill`, elevated per the design
/// directive: the fill animates from 0 to [value] on appear (400ms,
/// easeOutCubic) and re-animates on value changes.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
  });

  /// Fill fraction, 0..1.
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppComponentMetrics.progressBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.surfaceHover,
        borderRadius: AppRadii.fullRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1)),
        duration: AppMotion.entrance,
        curve: AppMotion.curve,
        builder: (context, animated, _) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: animated,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadii.fullRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
