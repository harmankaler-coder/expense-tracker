import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../presentation/add_expense_screen.dart';
import '../presentation/homescreen.dart';
import '../presentation/login_screen.dart';
import '../presentation/onboarding_screen.dart';
import '../presentation/signup_screen.dart';
import '../presentation/stats_screen.dart';
import 'main_wrapper.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value?.session != null;

      final isLoggingIn = state.uri.toString() == '/login';
      final isSigningUp = state.uri.toString() == '/signup';
      final isOnboarding = state.uri.toString() == '/onboarding';

      if (!isLoggedIn && !isLoggingIn && !isSigningUp && !isOnboarding) {
        return '/onboarding';
      }

      if (isLoggedIn && (isLoggingIn || isSigningUp || isOnboarding)) {
        return '/';
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainWrapper(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/stats', builder: (_, __) => const StatsScreen()),
        ],
      ),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(path: '/add', builder: (_, __) => const AddExpenseScreen()),
      GoRoute(path: '/stats', builder: (_, __) => const StatsScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    ],
  );
});
