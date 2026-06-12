import 'package:flutter/material.dart';

import '../theme.dart';
import 'app_button.dart';

/// Friendly inline failure state with a retry action, used wherever an
/// AsyncValue resolves to an error.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.message = "Couldn't load your data.",
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 28,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Try again',
              variant: AppButtonVariant.outline,
              expand: false,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
