import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../core/widgets/app_button.dart';

/// Router error page. The home button goes to '/' and lets the redirect
/// logic pick the right destination for the current auth state.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: AppTextStyles.statHero.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "This page doesn't exist.",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Take me home',
              variant: AppButtonVariant.outline,
              expand: false,
              onPressed: () => context.go(RoutePaths.splash),
            ),
          ],
        ),
      ),
    );
  }
}
