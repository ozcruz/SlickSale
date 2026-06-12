import 'package:flutter/material.dart';

import '../theme.dart';
import 'focus_ring.dart';

enum AppButtonVariant { primary, outline, ghost }

enum AppButtonSize { medium, large }

/// Design-system button with the elevation-directive micro-interactions:
/// 0.97 press scale, hover color shift, keyboard focus ring, click cursor,
/// dimmed disabled state, InkSparkle splash (NoSplash for ghost), and an
/// in-place spinner for loading that keeps the button's size stable.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.loading = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool loading;
  final Widget? icon;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.loading;

  @override
  Widget build(BuildContext context) {
    final Color background = switch (widget.variant) {
      AppButtonVariant.primary =>
        _hovered && _enabled ? AppColors.primaryHover : AppColors.primary,
      AppButtonVariant.outline ||
      AppButtonVariant.ghost =>
        _hovered && _enabled ? AppColors.surfaceHover : Colors.transparent,
    };
    // Every variant carries a border so all variants share exact metrics.
    final Color borderColor = switch (widget.variant) {
      AppButtonVariant.outline =>
        _hovered && _enabled ? AppColors.textTertiary : AppColors.border,
      _ => Colors.transparent,
    };
    final Color foreground = switch (widget.variant) {
      AppButtonVariant.primary => AppColors.textOnPrimary,
      AppButtonVariant.outline => AppColors.textPrimary,
      AppButtonVariant.ghost =>
        _hovered && _enabled ? AppColors.textPrimary : AppColors.textSecondary,
    };

    final bool large = widget.size == AppButtonSize.large;
    final TextStyle labelStyle = large
        ? AppTextStyles.subheading
            .copyWith(fontWeight: FontWeight.w700, color: foreground)
        : AppTextStyles.body.copyWith(
            fontWeight: widget.variant == AppButtonVariant.primary
                ? FontWeight.w600
                : FontWeight.w500,
            color: foreground,
          );
    final BorderRadius radius = large ? AppRadii.lgRadius : AppRadii.mdRadius;
    final EdgeInsets padding = large
        ? AppComponentMetrics.buttonPaddingLarge
        : AppComponentMetrics.buttonPadding;

    final Widget labelRow = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final Widget content = Stack(
      alignment: Alignment.center,
      children: [
        // Keep the label in the tree while loading so size never jumps.
        Opacity(opacity: widget.loading ? 0 : 1, child: labelRow),
        if (widget.loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foreground,
            ),
          ),
      ],
    );

    final Widget button = AnimatedScale(
      scale: _pressed && _enabled ? AppMotion.pressScale : 1,
      duration: AppMotion.press,
      curve: Curves.easeOut,
      child: FocusRing(
        focused: _focused,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: AppMotion.hover,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            border: Border.all(color: borderColor),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _enabled ? widget.onPressed : null,
              borderRadius: radius,
              splashFactory: widget.variant == AppButtonVariant.ghost
                  ? NoSplash.splashFactory
                  : InkSparkle.splashFactory,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              mouseCursor: _enabled
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              onHover: (hovered) => setState(() => _hovered = hovered),
              onFocusChange: (focused) => setState(
                  () => _focused = focused && keyboardFocusVisible),
              onHighlightChanged: (pressed) =>
                  setState(() => _pressed = pressed),
              child: Padding(padding: padding, child: content),
            ),
          ),
        ),
      ),
    );

    return AnimatedOpacity(
      // Loading buttons stay fully opaque; only true disabled states dim.
      opacity: _enabled || widget.loading ? 1 : AppMotion.disabledOpacity,
      duration: AppMotion.hover,
      child: button,
    );
  }
}
