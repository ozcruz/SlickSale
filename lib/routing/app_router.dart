import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/user_repository.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/dashboard/presentation/dashboard_shell.dart';
import '../features/dashboard/presentation/home_tab.dart';
import '../features/dashboard/presentation/settings_tab.dart';
import '../features/dashboard/presentation/stats_tab.dart';
import '../features/scorecard/presentation/scorecard_screen.dart';
import '../features/simulation/presentation/simulation_screen.dart';
import 'not_found_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // GoRouter re-runs redirect whenever this notifier ticks — i.e. on every
  // auth or profile change.
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authStateChangesProvider, (_, _) => refresh.value++);
  ref.listen(currentUserProfileProvider, (_, _) => refresh.value++);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) => _redirect(ref, state),
    errorPageBuilder: (context, state) =>
        _fadePage(state: state, child: const NotFoundScreen()),
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        pageBuilder: (context, state) =>
            _fadePage(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) =>
            _fadePage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: RoutePaths.signup,
        pageBuilder: (context, state) =>
            _fadePage(state: state, child: const SignupScreen()),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        pageBuilder: (context, state) =>
            _fadePage(state: state, child: const OnboardingScreen()),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => _fadeSlideUpPage(
          state: state,
          child: DashboardShell(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboard,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeTab()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboardStats,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: StatsTab()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboardSettings,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsTab()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.simulation,
        pageBuilder: (context, state) => _fadeSlideUpPage(
          state: state,
          child: SimulationScreen(
            scenarioId: state.pathParameters['scenarioId']!,
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.scorecard,
        pageBuilder: (context, state) => _fadeSlideUpPage(
          state: state,
          child: ScorecardScreen(
            sessionId: state.pathParameters['sessionId']!,
          ),
        ),
      ),
    ],
  );
}

/// Auth gate:
/// signed out -> /login (and /signup), signed in without a completed
/// profile -> /onboarding, otherwise -> the app. While auth/profile are
/// still resolving we hold on /splash so no screen flashes.
String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authStateChangesProvider);
  final location = state.matchedLocation;
  final onAuthScreen =
      location == RoutePaths.login || location == RoutePaths.signup;

  if (auth.isLoading) {
    return location == RoutePaths.splash ? null : RoutePaths.splash;
  }

  final user = auth.value;
  if (user == null) {
    return onAuthScreen ? null : RoutePaths.login;
  }

  final profile = ref.read(currentUserProfileProvider);
  if (profile.isLoading) {
    return location == RoutePaths.splash ? null : RoutePaths.splash;
  }

  // On a profile stream error we fall through with onboarded == false; the
  // onboarding save then surfaces a friendly error (e.g. rules missing).
  final onboarded = profile.value?.onboardingCompleted ?? false;
  if (!onboarded) {
    return location == RoutePaths.onboarding ? null : RoutePaths.onboarding;
  }

  if (onAuthScreen ||
      location == RoutePaths.onboarding ||
      location == RoutePaths.splash) {
    return RoutePaths.dashboard;
  }
  return null;
}

/// 200ms fade — auth screens per the design directive.
CustomTransitionPage<void> _fadePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.fast,
    reverseTransitionDuration: AppMotion.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: CurveTween(curve: Curves.easeOut).animate(animation),
      child: child,
    ),
  );
}

/// 300ms fade + slide-up — dashboard and modal-like full screens.
CustomTransitionPage<void> _fadeSlideUpPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.slow,
    reverseTransitionDuration: AppMotion.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
