import 'package:flutter/material.dart';

import '../../../../core/extensions.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/animated_progress_bar.dart';

/// Mockup `.category-row` / `.score-cat-row`: category name, animated
/// progress bar, score, and a trend cell. [delta] is in score points
/// (≈ percent on the 0-100 scale): positive renders "↑ 6%", negative
/// "↓ 2%", and anything that rounds to 0 renders "—". [trendSuffix]
/// (" vs avg" on the scorecard) is dropped on compact widths.
class CategoryScoreRow extends StatelessWidget {
  const CategoryScoreRow({
    super.key,
    required this.label,
    required this.score,
    required this.delta,
    this.trendSuffix = '',
    this.colorScore = false,
  });

  final String label;

  /// 0-100.
  final double score;
  final double delta;
  final String trendSuffix;

  /// Scorecard rows color the number by score; stats rows leave it neutral
  /// (the bar already carries the color), per the mockup.
  final bool colorScore;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompact;
    final rounded = delta.round();

    final String trendText;
    final Color trendColor;
    if (rounded == 0) {
      trendText = '—';
      trendColor = AppColors.textTertiary;
    } else {
      final arrow = rounded > 0 ? '↑' : '↓';
      final suffix = compact ? '' : trendSuffix;
      trendText = '$arrow ${rounded.abs()}%$suffix';
      trendColor = rounded > 0 ? AppColors.success : AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: compact
                ? AppComponentMetrics.categoryBarWidthCompact
                : AppComponentMetrics.categoryBarWidth,
            child: AnimatedProgressBar(
              value: score / 100,
              color: AppColors.scoreColor(score),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          SizedBox(
            width: 32,
            child: Text(
              '${score.round()}',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScore
                    ? AppColors.scoreColor(score)
                    : AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          SizedBox(
            width: compact || trendSuffix.isEmpty ? 48 : 96,
            child: Text(
              trendText,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: trendColor,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
