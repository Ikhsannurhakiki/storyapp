import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/repository/auth_repository.dart';

import '../provider/auth_provider.dart';
import '../screen/login_screen.dart';
import '../screen/main_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/stories_list_screen.dart';

class GoRouterService {
  GoRouter get router => _router;

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final auth = context.read<AuthProvider>();

      if (!auth.isInitialized) return null;

      final isSplash = state.matchedLocation == '/';
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (!auth.isLoggedIn && !(isLoggingIn || isRegistering || isSplash)) {
        return '/login';
      }

      if (auth.isLoggedIn && (isLoggingIn || isRegistering || isSplash)) {
        return '/home/storyList';
      }

      return null;
    },
    routes: [
      /// Splash screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      /// Login screen
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      /// Register screen
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      /// Shell route for bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child); // includes BottomNavigationBar
        },
        routes: [
          GoRoute(
            path: '/home/storyList',
            name: 'storyList',
            builder: (context, state) => const StoriesListScreen(),
          ),
          GoRoute(
            path: '/home/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

