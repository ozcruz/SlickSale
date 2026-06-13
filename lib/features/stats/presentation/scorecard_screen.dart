// Mirrors the "Scorecard" mockup: hero score, category breakdown vs the
// user's running averages, coach feedback with numbered tips, and
// Practice Again / Back to Dashboard actions. Deviations + elevations:
// hero number renders in the score color, not the mockup gradient (design
// system bans gradients); the hero counts up and the bars animate in.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/formatters.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/count_up_number.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../core/widgets/stagger_in.dart';
import '../data/session_repository.dart';
import '../domain/session.dart';
import '../domain/session_stats.dart';
import 'widgets/category_score_row.dart';

class ScorecardScreen extends ConsumerWidget {
  const ScorecardScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionProvider(sessionId));
    // Full history for the "vs avg" comparisons; while it streams in, the
    // viewed session alone serves as the baseline (all deltas read "—").
    final allSessions = ref.watch(sessionsProvider).value;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppComponentMetrics.dashboardMaxWidth,
            ),
            child: AnimatedSwitcher(
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
              child: sessionAsync.when(
                skipLoadingOnReload: true,
                data: (session) => session == null
                    ? const _SessionNotFound(key: ValueKey('missing'))
                    : _ScorecardContent(
                        key: const ValueKey('data'),
                        session: session,
                        allSessions: allSessions ?? [session],
                      ),
                loading: () =>
                    const _ScorecardSkeleton(key: ValueKey('loading')),
                error: (error, _) => ListView(
                  key: const ValueKey('error'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.xxl,
                  ),
                  children: [
                    ErrorState(
                      message: "Couldn't load this scorecard.",
                      onRetry: () =>
                          ref.invalidate(sessionProvider(sessionId)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Back to Dashboard',
                      variant: AppButtonVariant.ghost,
                      onPressed: () => context.go(RoutePaths.dashboard),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScorecardContent extends StatelessWidget {
  const _ScorecardContent({
    super.key,
    required this.session,
    required this.allSessions,
  });

  final Session session;
  final List<Session> allSessions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      children: [
        StaggerIn(
          index: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xxxl,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.xlRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text('OVERALL SCORE', style: AppTextStyles.overline),
                const SizedBox(height: AppSpacing.sm),
                CountUpNumber(
                  value: session.overallScore,
                  style: AppTextStyles.scoreHero.copyWith(
                    color: AppColors.scoreColor(session.overallScore),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  session.scenarioName,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  formatSessionTimestamp(session.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
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
              score: session.categoryScores[category.key] ?? 0,
              delta: (session.categoryScores[category.key] ?? 0) -
                  averageCategoryScore(allSessions, category),
              trendSuffix: ' vs avg',
              colorScore: true,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        StaggerIn(index: 7, child: _FeedbackCard(session: session)),
        const SizedBox(height: AppSpacing.xl),
        StaggerIn(
          index: 8,
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Practice Again',
                  onPressed: () => context.push(
                    RoutePaths.simulationPath(session.scenarioId),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: 'Back to Dashboard',
                  variant: AppButtonVariant.outline,
                  onPressed: () => context.go(RoutePaths.dashboard),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mockup `.feedback-card`: coach prose plus numbered, border-separated tips.
class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.xlRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Coach Feedback', style: AppTextStyles.subheading),
          const SizedBox(height: AppSpacing.lg),
          Text(
            session.feedbackSummary,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (session.tips.isNotEmpty) const SizedBox(height: AppSpacing.lg),
          for (final (i, tip) in session.tips.indexed)
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryMuted,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.overline.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SessionNotFound extends StatelessWidget {
  const _SessionNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      children: [
        EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Session not found',
          message: "This session doesn't exist or may have been removed.",
          actionLabel: 'Back to Dashboard',
          onAction: () => context.go(RoutePaths.dashboard),
        ),
      ],
    );
  }
}

class _ScorecardSkeleton extends StatelessWidget {
  const _ScorecardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        children: const [
          SkeletonBox(height: 240, radius: AppRadii.xl),
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
          SkeletonBox(height: 220, radius: AppRadii.xl),
          SizedBox(height: AppSpacing.xl),
          SkeletonBox(height: 44, radius: AppRadii.md),
        ],
      ),
    );
  }
}
