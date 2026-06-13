// Mirrors the "Dashboard" mockup home tab with the engagement directives
// now wired to live Firestore data: credits pill (scarcity), streak bar
// (loss aversion), recent sessions with relative recency, and a motivating
// empty state. Deviations: the gradient Start Practice CTA stays solid
// indigo (design system bans gradients).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_link.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../core/widgets/stagger_in.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../stats/data/session_repository.dart';
import '../../stats/domain/session.dart';
import '../../stats/domain/session_stats.dart';
import '../../stats/presentation/widgets/session_card.dart';
import 'widgets/credits_pill.dart';
import 'widgets/streak_bar.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final sessionsAsync = ref.watch(sessionsProvider);

    final Widget child;
    if (profileAsync.hasError || sessionsAsync.hasError) {
      child = Align(
        key: const ValueKey('error'),
        alignment: Alignment.topCenter,
        child: ErrorState(
          onRetry: () {
            ref.invalidate(currentUserProfileProvider);
            ref.invalidate(sessionsProvider);
          },
        ),
      );
    } else if (!profileAsync.hasValue || !sessionsAsync.hasValue) {
      child = const _HomeSkeleton(key: ValueKey('loading'));
    } else {
      child = _HomeContent(
        key: const ValueKey('data'),
        profile: profileAsync.value,
        sessions: sessionsAsync.requireValue,
      );
    }

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
      child: child,
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    super.key,
    required this.profile,
    required this.sessions,
  });

  final AppUser? profile;
  final List<Session> sessions;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _firstName {
    final name = profile?.displayName.trim() ?? '';
    return name.isEmpty ? 'there' : name.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    final recent = sessions.take(3).toList();
    final remaining = (AppConfig.freeSessionAllowance - sessions.length)
        .clamp(0, AppConfig.freeSessionAllowance);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        StaggerIn(
          index: 0,
          child: Text('$_greeting, $_firstName', style: AppTextStyles.display),
        ),
        const SizedBox(height: AppSpacing.xs),
        StaggerIn(
          index: 1,
          child: Text(
            'Ready to sharpen your pitch?',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        StaggerIn(
          index: 2,
          child: Row(children: [CreditsPill(remaining: remaining)]),
        ),
        const SizedBox(height: AppSpacing.xxl),
        StaggerIn(
          index: 3,
          child: AppButton(
            label: 'Start Practice',
            size: AppButtonSize.large,
            onPressed: () => context.push(RoutePaths.scenarios),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        // No streak bar before the first-ever session: the empty state below
        // carries the motivation; "start a new streak" implies a lost one.
        if (sessions.isNotEmpty) ...[
          StaggerIn(
            index: 4,
            child: StreakBar(
              streak: computeStreak(sessions),
              practicedToday: practicedToday(sessions),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
        StaggerIn(
          index: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Sessions', style: AppTextStyles.subheading),
              if (sessions.isNotEmpty)
                AppLink(
                  label: 'View all',
                  onTap: () => context.go(RoutePaths.dashboardStats),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (recent.isEmpty)
          StaggerIn(
            index: 6,
            child: EmptyState(
              icon: Icons.rocket_launch_rounded,
              title: 'Ready for your first practice?',
              message: 'Pick a scenario and start selling.',
              actionLabel: 'Pick a Scenario',
              onAction: () => context.push(RoutePaths.scenarios),
            ),
          )
        else
          for (var i = 0; i < recent.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            StaggerIn(
              index: 6 + i,
              child: SessionCard(
                session: recent[i],
                onTap: () =>
                    context.push(RoutePaths.scorecardPath(recent[i].id)),
              ),
            ),
          ],
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: const [
          SkeletonBox(width: 280, height: 30),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(width: 190, height: 16),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(width: 170, height: 28, radius: AppRadii.full),
          SizedBox(height: AppSpacing.xxl),
          SkeletonBox(height: 56, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.xxl),
          SkeletonBox(height: 72, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.xxl),
          SkeletonBox(width: 150, height: 18),
          SizedBox(height: AppSpacing.lg),
          SkeletonBox(height: 76, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 76, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 76, radius: AppRadii.lg),
        ],
      ),
    );
  }
}
