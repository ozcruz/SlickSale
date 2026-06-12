import 'package:flutter/material.dart';

import '../theme.dart';
import 'focus_ring.dart';

/// Inline text link (mockup `.auth-footer a`): primary color, hover shifts to
/// the lighter indigo with an underline, keyboard-focusable.
class AppLink extends StatefulWidget {
  const AppLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<AppLink> createState() => _AppLinkState();
}

class _AppLinkState extends State<AppLink> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final Color color =
        _hovered ? AppColors.primaryHover : AppColors.primary;

    return FocusRing(
      focused: _focused,
      borderRadius: AppRadii.smRadius,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppRadii.smRadius,
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          onHover: (hovered) => setState(() => _hovered = hovered),
          onFocusChange: (focused) =>
              setState(() => _focused = focused && keyboardFocusVisible),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            child: AnimatedDefaultTextStyle(
              duration: AppMotion.hover,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                decoration:
                    _hovered ? TextDecoration.underline : TextDecoration.none,
                decorationColor: color,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}
