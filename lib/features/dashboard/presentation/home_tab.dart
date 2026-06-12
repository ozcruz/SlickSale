// Mirrors the "Dashboard" mockup home tab. Deviations + elevations:
// - Gradient Start Practice CTA -> solid indigo (design system bans
//   gradients outside the avatar backdrop).
// - Credits pill and streak bar omitted: no credits/streak data exists yet
//   and fake numbers would lie. Recent Sessions renders an honest empty
//   state until sessions exist (Phase 2+).
// - Added: shimmer skeleton while the profile loads, AnimatedSwitcher
//   fade+slide between loading/data/error, staggered content entrance.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../core/widgets/stagger_in.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);

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
      child: profileAsync.when(
        skipLoadingOnReload: true,
        data: (profile) => _HomeContent(
          key: const ValueKey('data'),
          profile: profile,
        ),
        loading: () => const _HomeSkeleton(key: ValueKey('loading')),
        error: (error, _) => Align(
          key: const ValueKey('error'),
          alignment: Alignment.topCenter,
          child: ErrorState(
            onRetry: () => ref.invalidate(currentUserProfileProvider),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({super.key, required this.profile});

  final AppUser? profile;

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
        const SizedBox(height: AppSpacing.xxl),
        StaggerIn(
          index: 2,
          child: AppButton(
            label: 'Start Practice',
            size: AppButtonSize.large,
            onPressed: () =>
                context.push(RoutePaths.simulationPath('demo')),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        StaggerIn(
          index: 3,
          child: Text('Recent Sessions', style: AppTextStyles.subheading),
        ),
        const SizedBox(height: AppSpacing.lg),
        const StaggerIn(index: 4, child: _EmptySessions()),
      ],
    );
  }
}

class _EmptySessions extends StatelessWidget {
  const _EmptySessions();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history_rounded,
            size: 28,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No sessions yet',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your first practice session will show up here.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
          SizedBox(height: AppSpacing.xxl),
          SkeletonBox(height: 56, radius: AppRadii.lg),
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
