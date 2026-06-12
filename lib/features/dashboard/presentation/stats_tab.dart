// Placeholder for the "Stats" mockup tab. Deviations + elevations:
// - Gradient hero number -> plain text (design system bans gradients).
// - Real category breakdown / session history arrive with scoring (Phase 3);
//   until then this renders an honest empty state in the mockup's hero-card
//   structure with staggered entrance.
import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/stagger_in.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        StaggerIn(
          index: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.xlRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text(
                  '—',
                  style: AppTextStyles.statHero.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('OVERALL SCORE', style: AppTextStyles.overline),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Complete your first session to see your score.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        StaggerIn(
          index: 1,
          child: Text('Category Breakdown', style: AppTextStyles.subheading),
        ),
        const SizedBox(height: AppSpacing.lg),
        StaggerIn(
          index: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.lgRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Objection handling, rapport building, closing technique, '
              'discovery questions, and active listening will be scored '
              'here after each practice session.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
