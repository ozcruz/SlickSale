import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

/// Mockup `.credits-pill` ("⚡ 2 free sessions remaining"), elevated per the
/// design directive with a gentle looping border glow: the border color
/// breathes between the muted and full primary-muted tones. (Implemented as
/// a border-color pulse — the design system bans shadows and gradients.)
class CreditsPill extends StatefulWidget {
  const CreditsPill({super.key, required this.remaining});

  final int remaining;

  @override
  State<CreditsPill> createState() => _CreditsPillState();
}

class _CreditsPillState extends State<CreditsPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.pulse,
  )..repeat(reverse: true);
  late final CurvedAnimation _glow = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _glow.dispose();
    _controller.dispose();
    super.dispose();
  }

  String get _label => switch (widget.remaining) {
        0 => 'No free sessions left',
        1 => '1 free session remaining',
        final n => '$n free sessions remaining',
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) => Container(
        padding: AppComponentMetrics.pillPadding,
        decoration: BoxDecoration(
          color: AppColors.primaryMuted,
          borderRadius: AppRadii.fullRadius,
          border: Border.all(
            color: Color.lerp(
              AppColors.primaryMutedBorder,
              AppColors.primaryHover,
              0.45 * _glow.value,
            )!,
          ),
        ),
        child: child,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⚡', style: TextStyle(fontSize: 12)),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryHover,
            ),
          ),
        ],
      ),
    );
  }
}
