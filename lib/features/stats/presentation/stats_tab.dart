// Mirrors the "Stats" mockup tab on live Firestore data: overall-score hero,
// five-category breakdown with trend arrows (last 3 sessions vs all-time,
// the score-progression directive), and full session history. Deviations +
// elevations: the gradient hero number renders in the score color instead
// (design system bans gradients); the hero counts up and the bars animate in.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/count_up_number.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../core/widgets/stagger_in.dart';
import '../data/session_repository.dart';
import '../domain/session.dart';
import '../domain/session_stats.dart';
import 'widgets/category_score_row.dart';
import 'widgets/session_card.dart';

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsProvider);

    return AnimatedSwitcher(
      duration: AppMotion.medium,
      switchInCurve: AppMotion.curve,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: sessionsAsync.when(
        skipLoadingOnReload: true,
        data: (sessions) => sessions.isEmpty
            ? const _StatsEmpty(key: ValueKey('empty'))
            : _StatsContent(key: const ValueKey('data'), sessions: sessions),
        loading: () => const _StatsSkeleton(key: ValueKey('loading')),
        error: (error, _) => Align(
          key: const ValueKey('error'),
          alignment: Alignment.topCenter,
          child: ErrorState(
            onRetry: () => ref.invalidate(sessionsProvider),
          ),
        ),
      ),
    );
  }
}

class _StatsContent extends StatelessWidget {
  const _StatsContent({super.key, required this.sessions});

  /// Newest-first, never empty.
  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
    final overall = averageOverallScore(sessions);

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
                CountUpNumber(
                  value: overall,
                  style: AppTextStyles.statHero.copyWith(
                    color: AppColors.scoreColor(overall),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('OVERALL SCORE', style: AppTextStyles.overline),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  sessions.length == 1
                      ? 'Based on 1 session'
                      : 'Based on ${sessions.length} sessions',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
        for (final (i, category) in ScoreCategory.values.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          StaggerIn(
            index: 2 + i,
            child: CategoryScoreRow(
              label: category.label,
              score: averageCategoryScore(sessions, category),
              delta: categoryTrend(sessions, category),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        StaggerIn(
          index: 7,
          child: Text('Session History', style: AppTextStyles.subheading),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final (i, session) in sessions.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          StaggerIn(
            index: 8 + i,
            child: SessionCard(
              session: session,
              onTap: () =>
                  context.push(RoutePaths.scorecardPath(session.id)),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatsEmpty extends StatelessWidget {
  const _StatsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        EmptyState(
          icon: Icons.insights_rounded,
          title: 'No stats yet',
          message:
              'Complete your first practice session to see your scores, '
              'trends, and history here.',
          actionLabel: 'Start Practicing',
          onAction: () => context.push(RoutePaths.scenarios),
        ),
      ],
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: const [
          SkeletonBox(height: 180, radius: AppRadii.xl),
          SizedBox(height: AppSpacing.xl),
          SkeletonBox(width: 170, height: 18),
          SizedBox(height: AppSpacing.lg),
          SkeletonBox(height: 56, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 56, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 56, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 56, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 56, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.xl),
          SkeletonBox(width: 150, height: 18),
          SizedBox(height: AppSpacing.lg),
          SkeletonBox(height: 76, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 76, radius: AppRadii.lg),
        ],
      ),
    );
  }
}
