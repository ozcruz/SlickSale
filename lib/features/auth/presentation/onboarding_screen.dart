// Mirrors the "Onboarding" mockup. Deviations + elevations:
// - Experience step has 3 options (the ExperienceLevel enum) instead of the
//   mockup's 4 ("Expert" is not in the data model), laid out as full-width
//   rows rather than a 2-col grid — rows read better for 3 options.
// - Industry cards drop the description line (categories are
//   self-explanatory; keeps all 5 options visible without scrolling).
// - Added: animated progress dots (done=green, active=indigo per mockup),
//   300ms eased page transitions, per-step staggered entrance, selection
//   check marks, disabled-state dimming on Continue until the step is valid.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/stagger_in.dart';
import '../domain/app_user.dart';
import 'auth_controllers.dart';
import 'widgets/auth_card_shell.dart';
import 'widgets/error_banner.dart';
import 'widgets/selection_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const int _stepCount = 3;

  final _pageController = PageController();
  final _nameController = TextEditingController();
  int _step = 0;
  ExperienceLevel? _level;
  String? _industry;

  static const List<({String emoji, String label, String description})>
      _levels = [
    (emoji: '🌱', label: 'Beginner', description: 'New to sales'),
    (emoji: '📈', label: 'Intermediate', description: '1-3 years'),
    (emoji: '🏆', label: 'Advanced', description: '3+ years'),
  ];

  static const List<({String emoji, String label})> _industries = [
    (emoji: '☁️', label: 'SaaS'),
    (emoji: '🛡️', label: 'Insurance'),
    (emoji: '🏠', label: 'Real Estate'),
    (emoji: '🛍️', label: 'Retail'),
    (emoji: '✨', label: 'Other'),
  ];

  @override
  void initState() {
    super.initState();
    // Re-evaluate the Continue button as the user types their name.
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool get _stepValid => switch (_step) {
        0 => _nameController.text.trim().isNotEmpty,
        1 => _level != null,
        _ => _industry != null,
      };

  void _goToStep(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: AppMotion.slow,
      curve: AppMotion.curve,
    );
  }

  void _next() {
    if (!_stepValid) return;
    if (_step < _stepCount - 1) {
      _goToStep(_step + 1);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final ok = await ref.read(onboardingControllerProvider.notifier).complete(
          displayName: _nameController.text.trim(),
          experienceLevel: _level!,
          industry: _industry!,
        );
    // The router would also redirect once the profile stream emits; going
    // directly just makes it feel instant.
    if (ok && mounted) context.go(RoutePaths.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(onboardingControllerProvider);
    final saving = submitState.isLoading;

    return AuthCardShell(
      maxWidth: AppComponentMetrics.onboardingCardMaxWidth,
      children: [
        _ProgressDots(step: _step, count: _stepCount),
        const SizedBox(height: AppSpacing.xxl),
        SizedBox(
          height: 380,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _NameStep(
                controller: _nameController,
                enabled: !saving,
                onSubmitted: _next,
              ),
              _LevelStep(
                levels: _levels,
                selected: _level,
                onSelect: (level) => setState(() => _level = level),
              ),
              _IndustryStep(
                industries: _industries,
                selected: _industry,
                onSelect: (industry) => setState(() => _industry = industry),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ErrorBanner(
          message: submitState.hasError
              ? friendlyAuthError(submitState.error!)
              : null,
        ),
        Row(
          children: [
            if (_step > 0) ...[
              AppButton(
                label: 'Back',
                variant: AppButtonVariant.ghost,
                expand: false,
                onPressed: saving ? null : () => _goToStep(_step - 1),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: AppButton(
                label: _step == _stepCount - 1 ? 'Finish' : 'Continue',
                loading: saving,
                onPressed: _stepValid && !saving ? _next : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Mockup `.onboard-progress`: done = green, active = indigo, upcoming = dim.
class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.step, required this.count});

  final int step;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AnimatedContainer(
              duration: AppMotion.medium,
              curve: AppMotion.curve,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: AppRadii.fullRadius,
                color: i < step
                    ? AppColors.success
                    : i == step
                        ? AppColors.primary
                        : AppColors.surfaceHover,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggerIn(
          index: 0,
          child: Text(
            title,
            // Mockup `.step-title`: heading size at weight 700.
            style: AppTextStyles.heading.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        StaggerIn(
          index: 1,
          child: Text(
            subtitle,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.controller,
    required this.enabled,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _StepHeader(
            title: "What's your name?",
            subtitle: 'Your AI coach will use it during practice sessions.',
          ),
          StaggerIn(
            index: 2,
            child: AppTextField(
              label: 'Name',
              controller: controller,
              hintText: 'Alex Morgan',
              enabled: enabled,
              autofocus: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              onSubmitted: (_) => onSubmitted(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelStep extends StatelessWidget {
  const _LevelStep({
    required this.levels,
    required this.selected,
    required this.onSelect,
  });

  final List<({String emoji, String label, String description})> levels;
  final ExperienceLevel? selected;
  final ValueChanged<ExperienceLevel> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _StepHeader(
            title: "What's your sales experience?",
            subtitle: 'This helps us tailor scenarios to your skill level.',
          ),
          for (var i = 0; i < levels.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            StaggerIn(
              index: 2 + i,
              child: SelectionCard.horizontal(
                emoji: levels[i].emoji,
                label: levels[i].label,
                description: levels[i].description,
                selected: selected == ExperienceLevel.values[i],
                onTap: () => onSelect(ExperienceLevel.values[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IndustryStep extends StatelessWidget {
  const _IndustryStep({
    required this.industries,
    required this.selected,
    required this.onSelect,
  });

  final List<({String emoji, String label})> industries;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _StepHeader(
            title: 'What do you sell?',
            subtitle: "We'll theme your practice scenarios around it.",
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.6,
            children: [
              for (var i = 0; i < industries.length; i++)
                StaggerIn(
                  index: 2 + i,
                  child: SelectionCard.grid(
                    emoji: industries[i].emoji,
                    label: industries[i].label,
                    selected: selected == industries[i].label,
                    onTap: () => onSelect(industries[i].label),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
