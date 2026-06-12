// Mirrors the "Settings" mockup tab. Deviations + elevations:
// - Profile rows are read-only for Phase 1 (no chevrons): editing flows
//   don't exist yet and a chevron that does nothing would mislead.
// - "Delete Account" omitted until a real deletion flow exists (showing a
//   destructive control that does nothing is worse than its absence).
// - Added: shimmer skeleton while the profile loads, hover states on the
//   actionable row, inline spinner while signing out.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../core/widgets/stagger_in.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controllers.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

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
        data: (profile) => _SettingsContent(
          key: const ValueKey('data'),
          profile: profile,
        ),
        loading: () => const _SettingsSkeleton(key: ValueKey('loading')),
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

class _SettingsContent extends ConsumerWidget {
  const _SettingsContent({super.key, required this.profile});

  final AppUser? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signOutState = ref.watch(signOutControllerProvider);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        _Section(
          index: 0,
          title: 'Profile',
          children: [
            _InfoRow(label: 'Name', value: profile?.displayName ?? '—'),
            _InfoRow(label: 'Email', value: profile?.email ?? '—'),
            _InfoRow(
              label: 'Experience Level',
              value: profile?.experienceLevel.label ?? '—',
            ),
            _InfoRow(label: 'Industry', value: profile?.industry ?? '—'),
          ],
        ),
        _Section(
          index: 1,
          title: 'App',
          children: const [
            _InfoRow(
              label: 'About SlickSale',
              value: 'Version ${AppConfig.appVersion}',
            ),
          ],
        ),
        _Section(
          index: 2,
          title: 'Account',
          children: [
            _ActionRow(
              label: 'Sign Out',
              icon: Icons.logout_rounded,
              loading: signOutState.isLoading,
              onTap: signOutState.isLoading
                  ? null
                  : () =>
                      ref.read(signOutControllerProvider.notifier).signOut(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Overline title + bordered group (mockup `.settings-section` +
/// `.settings-group`).
class _Section extends StatelessWidget {
  const _Section({
    required this.index,
    required this.title,
    required this.children,
  });

  final int index;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return StaggerIn(
      index: index,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: AppTextStyles.overline),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadii.lgRadius,
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const Divider(),
                    children[i],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: AppSpacing.lg),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.label,
    required this.icon,
    required this.onTap,
    this.loading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      mouseCursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
            if (loading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _SettingsSkeleton extends StatelessWidget {
  const _SettingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: const [
          SkeletonBox(width: 60, height: 12),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(height: 224, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.xl),
          SkeletonBox(width: 40, height: 12),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(height: 56, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.xl),
          SkeletonBox(width: 70, height: 12),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(height: 56, radius: AppRadii.lg),
        ],
      ),
    );
  }
}
