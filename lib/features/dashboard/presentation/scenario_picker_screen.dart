// Mirrors the "Scenarios" mockup: full-width cards with a difficulty-colored
// top accent strip, character avatar, difficulty badge, and a two-line
// description. Elevation beyond the mockup: staggered entrance, hover lift
// (translateY -2px / 200ms) with border highlight, 0.97 press scale.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/interactive_card.dart';
import '../../../core/widgets/stagger_in.dart';
import '../domain/scenario.dart';

/// Badge/accent/avatar colors per difficulty (mockup: beginner=green,
/// intermediate=yellow, advanced=red).
extension on ScenarioDifficulty {
  Color get color => switch (this) {
        ScenarioDifficulty.beginner => AppColors.success,
        ScenarioDifficulty.intermediate => AppColors.warning,
        ScenarioDifficulty.advanced => AppColors.error,
      };

  Color get mutedColor => switch (this) {
        ScenarioDifficulty.beginner => AppColors.successMuted,
        ScenarioDifficulty.intermediate => AppColors.warningMuted,
        ScenarioDifficulty.advanced => AppColors.errorMuted,
      };
}

class ScenarioPickerScreen extends ConsumerWidget {
  const ScenarioPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenarios = ref.watch(scenariosProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppComponentMetrics.dashboardMaxWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xxl,
              ),
              children: [
                StaggerIn(
                  index: 0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go(RoutePaths.dashboard),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.textSecondary,
                        tooltip: 'Back',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                StaggerIn(
                  index: 1,
                  child: Text(
                    'Choose a Scenario',
                    // Mockup `.picker-header h2`: heading size at weight 700.
                    style: AppTextStyles.heading
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                StaggerIn(
                  index: 2,
                  child: Text(
                    'Pick a challenge and start practicing.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                for (var i = 0; i < scenarios.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.md),
                  StaggerIn(
                    index: 3 + i,
                    child: _ScenarioCard(scenario: scenarios[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    final difficulty = scenario.difficulty;

    return InteractiveCard(
      onTap: () =>
          context.push(RoutePaths.simulationPath(scenario.id)),
      padding: EdgeInsets.zero,
      borderRadius: AppRadii.xlRadius,
      clipBehavior: Clip.antiAlias,
      hoverTranslateY: AppMotion.hoverLift,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mockup `.scenario-card::before`: difficulty-colored accent strip.
          Container(
            height: AppComponentMetrics.scenarioAccentHeight,
            color: difficulty.color,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppComponentMetrics.scenarioAvatarSize,
                      height: AppComponentMetrics.scenarioAvatarSize,
                      decoration: BoxDecoration(
                        color: difficulty.mutedColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        scenario.characterName.characters.first,
                        style: AppTextStyles.avatarInitial.copyWith(
                          color: difficulty.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.name,
                            style: AppTextStyles.subheading
                                .copyWith(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${scenario.characterName} · '
                            '${scenario.characterRole}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _DifficultyBadge(difficulty: difficulty),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  scenario.description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mockup `.badge`: pill, muted background, colored uppercase label.
class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final ScenarioDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppComponentMetrics.badgePadding,
      decoration: BoxDecoration(
        color: difficulty.mutedColor,
        borderRadius: AppRadii.fullRadius,
      ),
      child: Text(
        difficulty.label.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          fontWeight: FontWeight.w600,
          color: difficulty.color,
        ),
      ),
    );
  }
}
