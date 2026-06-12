import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/interactive_card.dart';

/// Onboarding selection card (mockup `.selection-card`). Selected state:
/// primary border + primary-muted fill. Two layouts:
/// - [SelectionCard.horizontal]: icon left, text right, check on the far
///   right — used when options stack vertically.
/// - [SelectionCard.grid]: centered icon over label — used in 2-col grids.
class SelectionCard extends StatelessWidget {
  const SelectionCard.horizontal({
    super.key,
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
    this.description,
  }) : _grid = false;

  const SelectionCard.grid({
    super.key,
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
    this.description,
  }) : _grid = true;

  final String emoji;
  final String label;
  final String? description;
  final bool selected;
  final VoidCallback onTap;
  final bool _grid;

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor:
          selected ? AppColors.primaryMuted : AppColors.surfaceElevated,
      hoverBackgroundColor:
          selected ? AppColors.primaryMuted : AppColors.surfaceHover,
      borderColor: selected ? AppColors.primary : AppColors.border,
      hoverBorderColor: selected ? AppColors.primary : AppColors.textTertiary,
      child: _grid ? _gridContent() : _horizontalContent(),
    );
  }

  Widget _horizontalContent() {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              if (description != null)
                Text(
                  description!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
        AnimatedOpacity(
          opacity: selected ? 1 : 0,
          duration: AppMotion.hover,
          child: const Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _gridContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        if (description != null) ...[
          const SizedBox(height: 2),
          Text(
            description!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
