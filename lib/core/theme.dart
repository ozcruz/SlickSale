import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SlickSale design system — the single source of truth for every color,
/// text style, spacing value, radius, and motion constant in the app.
/// Values mirror docs/ui-reference/slicksale-mockups.html and
/// .claude/rules/design-system.md. Nothing visual may be defined elsewhere.

abstract final class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF09090B);
  static const Color surface = Color(0xFF111114);
  static const Color surfaceElevated = Color(0xFF18181B);
  static const Color surfaceHover = Color(0xFF1F1F23);
  static const Color inputBackground = Color(0xFF0F0F12);
  static const Color simulationBackground = Color(0xFF050507);

  // Borders
  static const Color border = Color(0xFF27272A);
  static const Color borderSubtle = Color(0xFF1E1E22);
  static const Color borderFocus = Color(0xFF6366F1);

  // Brand
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryHover = Color(0xFF818CF8);
  static const Color primaryMuted = Color(0x1F6366F1); // 12% alpha
  static const Color primaryMutedBorder = Color(0x336366F1); // 20% alpha

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color successMuted = Color(0x1F10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningMuted = Color(0x1FF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorMuted = Color(0x1FEF4444);
  static const Color errorMutedBorder = Color(0x33EF4444);

  // Text
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF71717A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Ink splash overlay used on filled controls (defined here so no widget
  // ever needs an inline color).
  static const Color inkSplash = Color(0x14FFFFFF);

  /// Score thresholds: >=75 green, 50-74 yellow, <50 red.
  static Color scoreColor(num score) {
    if (score >= 75) return success;
    if (score >= 50) return warning;
    return error;
  }
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class AppRadii {
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 9999;

  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullRadius = BorderRadius.all(Radius.circular(full));
}

/// Motion constants from the design elevation directive: 200-300ms page
/// transitions, 50ms stagger steps, 0.97 press scale, dimmed disabled states.
abstract final class AppMotion {
  static const Duration press = Duration(milliseconds: 120);
  static const Duration hover = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration entrance = Duration(milliseconds: 400);
  static const Duration staggerStep = Duration(milliseconds: 50);

  /// Dashboard tab cross-fade (design elevation directive: 150ms).
  static const Duration tabFade = Duration(milliseconds: 150);

  /// Score number count-up (directive: 0 -> value over 600ms).
  static const Duration countUp = Duration(milliseconds: 600);

  /// Ambient loops: streak-flame pulse, credits-pill border glow (2s).
  static const Duration pulse = Duration(seconds: 2);

  static const Curve curve = Curves.easeOutCubic;
  static const double pressScale = 0.97;

  /// Scenario-card hover lift (directive: translateY(-2px)).
  static const double hoverLift = -2;

  /// Streak-flame pulse peak scale (directive: 1.0 -> 1.1 -> 1.0).
  static const double pulseScale = 1.1;

  static const double disabledOpacity = 0.4;
}

/// Fixed component metrics from the mockup CSS (values that are not part of
/// the spacing scale live here so screens never hardcode them).
abstract final class AppComponentMetrics {
  /// Mockup `.btn-*`: padding 10px 20px.
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);

  /// Mockup `.start-cta`: padding 16px 32px.
  static const EdgeInsets buttonPaddingLarge =
      EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg);

  /// Mockup `.input-field`: padding 10px 14px.
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 10);

  /// Mockup `.sim-end-btn` / `.credits-pill`: padding 6px 14px.
  static const EdgeInsets pillPadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 6);

  /// Mockup `.badge`: padding 2px 8px.
  static const EdgeInsets badgePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2);

  /// 2px keyboard-focus outline (accessibility directive).
  static const double focusRingWidth = 2;

  static const double dashboardMaxWidth = 800;
  static const double authCardMaxWidth = 400;
  static const double onboardingCardMaxWidth = 520;

  /// Mockup `.progress-bar`: 6px tall.
  static const double progressBarHeight = 6;

  /// Mockup `.cat-bar`: 120px wide; narrower on compact layouts.
  static const double categoryBarWidth = 120;
  static const double categoryBarWidthCompact = 72;

  /// Mockup `.scenario-card::before`: 3px accent strip.
  static const double scenarioAccentHeight = 3;

  /// Mockup `.scenario-avatar`: 40px circle.
  static const double scenarioAvatarSize = 40;
}

/// Typography — Inter via Google Fonts. letterSpacing/height values come from
/// the design elevation directive (-0.5 display, -0.3 headings, 1.5 body).
abstract final class AppTextStyles {
  static final TextStyle display = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static final TextStyle subheading = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static final TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Render with uppercase text (Dart has no CSS text-transform).
  static final TextStyle overline = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  /// Mockup `.input-label`: 12px / 500.
  static final TextStyle inputLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Mockup `.auth-logo h1`: 24px / 800. Solid indigo — the mockup gradient
  /// is dropped because the design system bans gradients.
  static final TextStyle logo = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.primary,
  );

  /// Mockup `.overall-score .big-num`: 56px / 800.
  static final TextStyle statHero = GoogleFonts.inter(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  /// Mockup `.score-hero .hero-num`: 72px / 800.
  static final TextStyle scoreHero = GoogleFonts.inter(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    letterSpacing: -3,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  /// Mockup `.scenario-avatar`: 18px / 700 initial inside the circle.
  static final TextStyle avatarInitial = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
  final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
    displaySmall: AppTextStyles.display,
    titleLarge: AppTextStyles.heading,
    titleMedium: AppTextStyles.subheading,
    bodyMedium: AppTextStyles.body,
    bodySmall: AppTextStyles.caption,
    labelSmall: AppTextStyles.overline,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.primaryHover,
      onSecondary: AppColors.textOnPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerHighest: AppColors.surfaceElevated,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      outline: AppColors.border,
      outlineVariant: AppColors.borderSubtle,
    ),
    textTheme: textTheme,
    // Custom ink treatment per the design directive.
    splashFactory: InkSparkle.splashFactory,
    splashColor: AppColors.inkSplash,
    highlightColor: Colors.transparent,
    hoverColor: AppColors.surfaceHover,
    focusColor: AppColors.primaryMuted,
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: AppColors.inputBackground,
      isDense: true,
      contentPadding: AppComponentMetrics.inputPadding,
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      hoverColor: Colors.transparent,
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppRadii.mdRadius,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppRadii.mdRadius,
        borderSide: BorderSide(
          color: AppColors.borderFocus,
          width: AppComponentMetrics.focusRingWidth,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: AppRadii.mdRadius,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: AppRadii.mdRadius,
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppComponentMetrics.focusRingWidth,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: AppRadii.mdRadius,
        borderSide: BorderSide(color: AppColors.borderSubtle),
      ),
      suffixIconColor: AppColors.textTertiary,
      prefixIconColor: AppColors.textTertiary,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.xlRadius,
        side: BorderSide(color: AppColors.border),
      ),
      titleTextStyle: AppTextStyles.heading,
      contentTextStyle: AppTextStyles.body.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceElevated,
      contentTextStyle: AppTextStyles.body,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.mdRadius,
        side: BorderSide(color: AppColors.border),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primaryMuted,
      selectionHandleColor: AppColors.primary,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.border),
      radius: Radius.circular(AppRadii.full),
    ),
  );
}
