import 'package:flutter/material.dart';

import '../theme.dart';

/// 2px primary outline shown on keyboard focus (accessibility directive).
/// Rendered as a zero-blur spread ring so it sits outside the child's bounds
/// without shifting layout — it reads as an outline, not a shadow.
class FocusRing extends StatelessWidget {
  const FocusRing({
    super.key,
    required this.focused,
    required this.borderRadius,
    required this.child,
  });

  final bool focused;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.hover,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: focused
            ? const [
                BoxShadow(
                  color: AppColors.borderFocus,
                  spreadRadius: AppComponentMetrics.focusRingWidth,
                ),
              ]
            : const [],
      ),
      child: child,
    );
  }
}

/// True when focus changes should render a visible ring — i.e. the user is
/// navigating with the keyboard, not clicking with the mouse.
bool get keyboardFocusVisible =>
    FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
