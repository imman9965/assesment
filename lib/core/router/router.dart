import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../view/game_screen/game_screen.dart';
import '../../view/result_screen/result_screen.dart';
import '../helpers/notifier.dart';
import '../../view/auth/otp_screen.dart';
import '../../view/auth/sign_in_screen.dart';
import '../../view/auth/sign_up_screen.dart';
import '../../view/home/home_screen.dart';
import '../../view/onboarding/onboard_screen.dart';
import '../../view/splash_screen/splash_screen.dart';





class AppRouter {

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',

    // refreshListenable:
    // GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;

      final goingToSignIn = state.uri.toString() == '/signin';
      final goingToSignUp = state.uri.toString() == '/signup';
      final goingToSplash = state.uri.toString() == '/splash';

      if (!isLoggedIn &&
          !goingToSignIn &&
          !goingToSignUp &&
          !goingToSplash) {
        return '/onboarding';
      }

      if (isLoggedIn && (goingToSignIn || goingToSignUp)) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnBoardingScreen()),
      GoRoute(path: '/signin', builder: (_, __) => const SignInScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
      GoRoute(path: '/otp', builder: (_, __) => const OtpScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeDashboardScreen()),
      GoRoute(path: '/game', builder: (_, __) => const GameScreen()),
      GoRoute(path: '/result', builder: (_, __) => const ResultScreen()),
    ],
  );
}