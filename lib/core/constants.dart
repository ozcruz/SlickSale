/// Route paths, environment-driven config, and asset paths.
library;

abstract final class RoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardSettings = '/dashboard/settings';
  static const String scenarios = '/scenarios';
  static const String simulation = '/simulation/:scenarioId';
  static const String scorecard = '/scorecard/:sessionId';

  static String simulationPath(String scenarioId) => '/simulation/$scenarioId';

  static String scorecardPath(String sessionId) => '/scorecard/$sessionId';
}

abstract final class AppConfig {
  static const String appName = 'SlickSale';
  static const String appTagline = 'Practice sales. Get better. Close deals.';
  static const String appVersion = '1.0.0';

  /// Free practice sessions before the paywall (paywall ships later; the
  /// dashboard credits pill counts down against this).
  static const int freeSessionAllowance = 3;

  /// Destination for the Settings "Send Feedback" mailto link.
  static const String feedbackEmail = 'osmansiddiqi1@gmail.com';

  /// FastAPI backend base URL. Override at build/run time:
  /// `flutter run --dart-define=BACKEND_URL=https://api.example.com`
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8000',
  );
}

abstract final class AppAssets {
  static const String avatarRive = 'assets/avatar.riv';
}
