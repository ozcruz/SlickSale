// Smoke tests for the design-system widgets (no Firebase dependency).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slicksale/core/theme.dart';
import 'package:slicksale/core/widgets/app_button.dart';
import 'package:slicksale/core/widgets/segmented_tab_bar.dart';

Widget _harness(Widget child) => MaterialApp(
      theme: buildAppTheme(),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  setUpAll(() {
    // No font fetching in tests; fall back to the default test font.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('AppButton fires onPressed', (tester) async {
    var pressed = 0;
    await tester.pumpWidget(
      _harness(AppButton(label: 'Sign In', onPressed: () => pressed++)),
    );

    expect(find.text('Sign In'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(pressed, 1);
  });

  testWidgets('AppButton ignores taps while loading and shows a spinner',
      (tester) async {
    var pressed = 0;
    await tester.pumpWidget(
      _harness(
        AppButton(label: 'Sign In', loading: true, onPressed: () => pressed++),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(AppButton), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
    expect(pressed, 0);
  });

  testWidgets('SegmentedTabBar reports tab selection', (tester) async {
    var selected = -1;
    await tester.pumpWidget(
      _harness(
        SegmentedTabBar(
          labels: const ['Home', 'Stats', 'Settings'],
          index: 0,
          onChanged: (index) => selected = index,
        ),
      ),
    );

    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(selected, 1);
  });
}
