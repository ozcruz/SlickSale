import 'package:flutter/material.dart';

import '../theme.dart';
import 'focus_ring.dart';

/// Surface card (mockup `.card`) with the `.card-hover` interactions when
/// tappable: hover elevation + border shift, 0.97 press scale, keyboard
/// focus ring, click cursor. Color overrides let callers express selected
/// states (e.g. onboarding selection cards).
class InteractiveCard extends StatefulWidget {
  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.borderRadius = AppRadii.lgRadius,
    this.backgroundColor = AppColors.surface,
    this.hoverBackgroundColor = AppColors.surfaceElevated,
    this.borderColor = AppColors.border,
    this.hoverBorderColor = AppColors.borderFocus,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color hoverBackgroundColor;
  final Color borderColor;
  final Color hoverBorderColor;

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool tappable = widget.onTap != null;
    final Color background =
        _hovered && tappable ? widget.hoverBackgroundColor : widget.backgroundColor;
    final Color border =
        _hovered && tappable ? widget.hoverBorderColor : widget.borderColor;

    final Widget card = AnimatedContainer(
      duration: AppMotion.hover,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: background,
        borderRadius: widget.borderRadius,
        border: Border.all(color: border),
      ),
      child: tappable
          ? Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: widget.borderRadius,
                splashFactory: NoSplash.splashFactory,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                mouseCursor: SystemMouseCursors.click,
                onHover: (hovered) => setState(() => _hovered = hovered),
                onFocusChange: (focused) =>
                    setState(() => _focused = focused && keyboardFocusVisible),
                onHighlightChanged: (pressed) =>
                    setState(() => _pressed = pressed),
                child: Padding(padding: widget.padding, child: widget.child),
              ),
            )
          : Padding(padding: widget.padding, child: widget.child),
    );

    if (!tappable) return card;

    return AnimatedScale(
      scale: _pressed ? AppMotion.pressScale : 1,
      duration: AppMotion.press,
      curve: Curves.easeOut,
      child: FocusRing(
        focused: _focused,
        borderRadius: widget.borderRadius,
        child: card,
      ),
    );
  }
}
