// Phase-1 placeholder: real scoring UI (hero score, category breakdown,
// coach feedback) arrives in Phase 3 per the "Scorecard" mockup.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/stagger_in.dart';

class ScorecardScreen extends StatelessWidget {
  const ScorecardScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppComponentMetrics.authCardMaxWidth,
            ),
            child: StaggerIn(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadii.xlRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Scorecard',
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Scoring for session "$sessionId" arrives in Phase 3.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: 'Back to Dashboard',
                      variant: AppButtonVariant.outline,
                      onPressed: () => context.go(RoutePaths.dashboard),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
