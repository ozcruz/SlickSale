import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

/// Inline form error that animates open/closed (design elevation directive:
/// smooth state transitions instead of popping content).
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      alignment: Alignment.topCenter,
      child: message == null
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorMuted,
                borderRadius: AppRadii.mdRadius,
                border: Border.all(color: AppColors.errorMutedBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      message!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
