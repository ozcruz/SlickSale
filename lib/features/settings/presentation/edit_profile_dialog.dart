import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/interactive_card.dart';
import '../../auth/domain/app_user.dart';
import 'settings_controllers.dart';

/// Modal editor for the mutable profile fields (name, experience level,
/// industry — email is the sign-in identity and stays read-only). Saves via
/// [ProfileEditController]; the profile stream refreshes the tab on success.
class EditProfileDialog extends ConsumerStatefulWidget {
  const EditProfileDialog({super.key, required this.profile});

  final AppUser profile;

  static Future<void> show(BuildContext context, AppUser profile) =>
      showDialog<void>(
        context: context,
        builder: (context) => EditProfileDialog(profile: profile),
      );

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.profile.displayName);
  late ExperienceLevel _level = widget.profile.experienceLevel;
  late String _industry = widget.profile.industry;

  @override
  void initState() {
    super.initState();
    // Re-evaluate the Save button as the user types.
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _valid => _nameController.text.trim().isNotEmpty;

  Future<void> _save() async {
    final updated = widget.profile.copyWith(
      displayName: _nameController.text.trim(),
      experienceLevel: _level,
      industry: _industry,
    );
    final ok =
        await ref.read(profileEditControllerProvider.notifier).save(updated);
    if (ok && mounted) {
      Navigator.of(context).pop();
      context.showAppSnackBar('Profile updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(profileEditControllerProvider);
    final saving = saveState.isLoading;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppComponentMetrics.authCardMaxWidth,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Profile', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'Name',
                controller: _nameController,
                hintText: 'Alex Morgan',
                enabled: !saving,
                autofillHints: const [AutofillHints.name],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Experience Level', style: AppTextStyles.inputLabel),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final level in ExperienceLevel.values)
                    _ChoicePill(
                      label: level.label,
                      selected: _level == level,
                      onTap: saving
                          ? null
                          : () => setState(() => _level = level),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Industry', style: AppTextStyles.inputLabel),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final industry in industryOptions)
                    _ChoicePill(
                      label: industry.label,
                      selected: _industry == industry.label,
                      onTap: saving
                          ? null
                          : () => setState(() => _industry = industry.label),
                    ),
                ],
              ),
              if (saveState.hasError) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  "Couldn't save your changes. Please try again.",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Cancel',
                      variant: AppButtonVariant.ghost,
                      onPressed: saving
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Save',
                      loading: saving,
                      onPressed: _valid && !saving ? _save : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact selectable pill (the dialog-sized cousin of the onboarding
/// selection cards): primary border + muted fill when selected.
class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      onTap: onTap,
      padding: AppComponentMetrics.pillPadding,
      borderRadius: AppRadii.fullRadius,
      backgroundColor:
          selected ? AppColors.primaryMuted : AppColors.surfaceElevated,
      hoverBackgroundColor:
          selected ? AppColors.primaryMuted : AppColors.surfaceHover,
      borderColor: selected ? AppColors.primary : AppColors.border,
      hoverBorderColor: selected ? AppColors.primary : AppColors.textTertiary,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
