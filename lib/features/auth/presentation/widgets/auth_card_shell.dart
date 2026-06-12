import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

/// Centered card layout shared by the auth + onboarding screens
/// (mockup `.auth-card` / `.onboard-card`: surface bg, 1px border,
/// 16px radius, 48px/32px padding).
class AuthCardShell extends StatelessWidget {
  const AuthCardShell({
    super.key,
    required this.children,
    this.maxWidth = AppComponentMetrics.authCardMaxWidth,
  });

  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadii.xlRadius,
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xxxl,
                horizontal: AppSpacing.xxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
