// Mirrors the "Settings" mockup tab. Profile rows now carry a real Edit
// Profile flow (modal dialog), App gains Send Feedback (mailto), and
// Account gains Delete Account — which, per the v1 spec, confirms and then
// signs out; permanent data removal ships with a real deletion backend.
// Elevations: shimmer skeleton while the profile loads, hover states on
// actionable rows, inline spinner while signing out.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants.dart';
import '../../../core/extensions.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/interactive_card.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../core/widgets/stagger_in.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controllers.dart';
import 'edit_profile_dialog.dart';

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

  Future<void> _sendFeedback(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: AppConfig.feedbackEmail,
      query: 'subject=${Uri.encodeComponent('SlickSale Feedback')}',
    );
    var opened = false;
    try {
      opened = await launchUrl(uri);
    } on Exception {
      opened = false;
    }
    if (!opened && context.mounted) {
      context.showAppSnackBar(
        'Could not open your email app. Reach us at '
        '${AppConfig.feedbackEmail}.',
        isError: true,
      );
    }
  }

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete account?'),
            content: const Text(
              "You'll be signed out immediately. To have your data "
              'permanently removed, send us a note via Send Feedback.',
            ),
            actions: [
              AppButton(
                label: 'Cancel',
                variant: AppButtonVariant.ghost,
                expand: false,
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              _DangerButton(
                label: 'Delete Account',
                onTap: () => Navigator.of(dialogContext).pop(true),
              ),
            ],
          ),
        ) ??
        false;
    // v1 deletion: sign out only (per spec); a real deletion flow comes
    // with backend support.
    if (confirmed) {
      await ref.read(signOutControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signOutState = ref.watch(signOutControllerProvider);
    final user = profile;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        _Section(
          index: 0,
          title: 'Profile',
          children: [
            _InfoRow(label: 'Name', value: user?.displayName ?? '—'),
            _InfoRow(label: 'Email', value: user?.email ?? '—'),
            _InfoRow(
              label: 'Experience Level',
              value: user?.experienceLevel.label ?? '—',
            ),
            _InfoRow(label: 'Industry', value: user?.industry ?? '—'),
            if (user != null)
              _ActionRow(
                label: 'Edit Profile',
                icon: Icons.edit_rounded,
                onTap: () => EditProfileDialog.show(context, user),
              ),
          ],
        ),
        _Section(
          index: 1,
          title: 'App',
          children: [
            const _InfoRow(
              label: 'About SlickSale',
              value: 'Version ${AppConfig.appVersion}',
            ),
            _ActionRow(
              label: 'Send Feedback',
              icon: Icons.mail_outline_rounded,
              onTap: () => _sendFeedback(context),
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
            _ActionRow(
              label: 'Delete Account',
              icon: Icons.delete_outline_rounded,
              danger: true,
              onTap: signOutState.isLoading
                  ? null
                  : () => _confirmDeleteAccount(context, ref),
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
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool loading;

  /// Mockup `.settings-row.danger`: destructive rows render in error red.
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.textTertiary;

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
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: danger ? AppColors.error : AppColors.textPrimary,
              ),
            ),
            if (loading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}

/// Destructive confirm button (error-muted fill, error text) — the dialog
/// counterpart of the simulation screen's End Session pill.
class _DangerButton extends StatelessWidget {
  const _DangerButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      onTap: onTap,
      padding: AppComponentMetrics.buttonPadding,
      borderRadius: AppRadii.mdRadius,
      backgroundColor: AppColors.errorMuted,
      hoverBackgroundColor: AppColors.errorMutedBorder,
      borderColor: AppColors.errorMutedBorder,
      hoverBorderColor: AppColors.error,
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.error,
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
          SkeletonBox(height: 280, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.xl),
          SkeletonBox(width: 40, height: 12),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(height: 112, radius: AppRadii.lg),
          SizedBox(height: AppSpacing.xl),
          SkeletonBox(width: 70, height: 12),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(height: 112, radius: AppRadii.lg),
        ],
      ),
    );
  }
}
