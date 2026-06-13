import 'package:flutter/material.dart';

import '../theme.dart';

/// Score number that counts up from 0 to [value] on first build (design
/// elevation directive: 600ms, easeOutCubic) and re-animates from the
/// current value whenever [value] changes. Displays the rounded integer.
class CountUpNumber extends StatelessWidget {
  const CountUpNumber({
    super.key,
    required this.value,
    required this.style,
    this.textAlign,
  });

  final num value;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: AppMotion.countUp,
      curve: AppMotion.curve,
      builder: (context, animated, _) => Text(
        '${animated.round()}',
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
