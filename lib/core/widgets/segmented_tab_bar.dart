import 'package:flutter/material.dart';

import '../theme.dart';
import 'focus_ring.dart';

/// Segmented control matching the mockup `.dash-tabs` pattern: a row of tab
/// buttons inside a surface container with a 1px border. Elevated beyond the
/// mockup with an animated sliding pill behind the active tab.
class SegmentedTabBar extends StatelessWidget {
  const SegmentedTabBar({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final int count = labels.length;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              duration: AppMotion.medium,
              curve: AppMotion.curve,
              alignment: Alignment(
                count == 1 ? 0 : -1 + 2 * index / (count - 1),
                0,
              ),
              child: FractionallySizedBox(
                widthFactor: 1 / count,
                heightFactor: 1,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadii.mdRadius,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < count; i++)
                Expanded(
                  child: _TabButton(
                    label: labels[i],
                    active: i == index,
                    onTap: () => onChanged(i),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatefulWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final Color color = widget.active
        ? AppColors.textPrimary
        : _hovered
            ? AppColors.textSecondary
            : AppColors.textTertiary;

    return FocusRing(
      focused: _focused,
      borderRadius: AppRadii.mdRadius,
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: AnimatedDefaultTextStyle(
              duration: AppMotion.hover,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
              child: Text(widget.label, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
