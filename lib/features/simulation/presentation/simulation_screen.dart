// Phase-1 placeholder: the Rive avatar, chat, and mic flow arrive in
// Phase 2. What's already real per the mockup "Simulation" screen:
// - near-black sim background, blurred top bar (backdrop blur directive),
//   End Session pill, and the one gradient the design system allows — the
//   subtle radial avatar backdrop.
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/focus_ring.dart';
import '../../../core/widgets/stagger_in.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key, required this.scenarioId});

  final String scenarioId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.simulationBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StaggerIn(
                    index: 0,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // The avatar backdrop is the design system's single
                        // permitted gradient.
                        gradient: RadialGradient(
                          colors: [AppColors.primaryMuted, Colors.transparent],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface,
                            border: Border.all(
                              color: AppColors.primaryMutedBorder,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Rive avatar\nrenders here',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  StaggerIn(
                    index: 1,
                    child: Text(
                      'Simulation coming in Phase 2',
                      style: AppTextStyles.subheading,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  StaggerIn(
                    index: 2,
                    child: Text(
                      'Live conversation, lip-synced avatar, and voice input '
                      'land here.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.simulationBackground.withValues(
                      alpha: 0.7,
                    ),
                    border: const Border(
                      bottom: BorderSide(color: AppColors.borderSubtle),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Scenario: $scenarioId',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        _EndSessionButton(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(RoutePaths.dashboard);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mockup `.sim-end-btn`: error-muted pill.
class _EndSessionButton extends StatefulWidget {
  const _EndSessionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_EndSessionButton> createState() => _EndSessionButtonState();
}

class _EndSessionButtonState extends State<_EndSessionButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusRing(
      focused: _focused,
      borderRadius: AppRadii.mdRadius,
      child: AnimatedContainer(
        duration: AppMotion.hover,
        decoration: BoxDecoration(
          color: _hovered ? AppColors.errorMutedBorder : AppColors.errorMuted,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: AppColors.errorMutedBorder),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadii.mdRadius,
            splashFactory: NoSplash.splashFactory,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            onHover: (hovered) => setState(() => _hovered = hovered),
            onFocusChange: (focused) =>
                setState(() => _focused = focused && keyboardFocusVisible),
            child: Padding(
              padding: AppComponentMetrics.pillPadding,
              child: Text(
                'End Session',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
