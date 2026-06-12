import 'package:flutter/material.dart';

import '../constants.dart';
import '../theme.dart';

/// Brand wordmark with optional tagline (mockup `.auth-logo`).
/// Deviation from mockup: the gradient wordmark is rendered solid indigo —
/// the design system bans gradients outside the avatar backdrop.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.tagline});

  final String? tagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppConfig.appName, style: AppTextStyles.logo),
        if (tagline != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            tagline!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
