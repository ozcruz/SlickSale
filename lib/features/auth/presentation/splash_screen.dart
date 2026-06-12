import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/pulsing_dots.dart';

/// Shown while auth state / profile resolve on startup, so users never see a
/// flash of the login screen (or a bare spinner). Pulsing dots match the
/// mockup "warmup" pattern.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(),
            SizedBox(height: AppSpacing.xl),
            PulsingDots(),
          ],
        ),
      ),
    );
  }
}
