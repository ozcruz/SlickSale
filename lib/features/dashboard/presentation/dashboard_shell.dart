// Mirrors the mockup `.dash-layout` + `.dash-tabs`: an 800px-max centered
// column with a segmented tab control (Home / Stats / Settings) on top.
// Elevation beyond mockup: the active-tab pill slides between tabs.
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
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
