// Mirrors the mockup `.dash-layout` + `.dash-tabs`: an 800px-max centered
// column with a segmented tab control (Home / Stats / Settings) on top.
// Elevation beyond mockup: the active-tab pill slides between tabs, and tab
// content cross-fades on switch (150ms per the design directive).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/segmented_tab_bar.dart';
import '../../../core/widgets/stagger_in.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppComponentMetrics.dashboardMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  StaggerIn(
                    index: 0,
                    child: SegmentedTabBar(
                      labels: const ['Home', 'Stats', 'Settings'],
                      index: navigationShell.currentIndex,
                      onChanged: (index) => navigationShell.goBranch(
                        index,
                        initialLocation:
                            index == navigationShell.currentIndex,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Expanded(
                    child: _TabFade(
                      index: navigationShell.currentIndex,
                      child: navigationShell,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fades the branch container back in whenever the active tab changes. The
/// IndexedStack underneath switches instantly, so against the near-black
/// background this reads as a 150ms cross-fade without giving up the
/// per-branch state that StatefulShellRoute preserves.
class _TabFade extends StatefulWidget {
  const _TabFade({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_TabFade> createState() => _TabFadeState();
}

class _TabFadeState extends State<_TabFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.tabFade,
    value: 1,
  );
  late final CurvedAnimation _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void didUpdateWidget(_TabFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _opacity.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}
