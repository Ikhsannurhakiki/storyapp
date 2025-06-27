import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/repository/auth_repository.dart';

import '../provider/auth_provider.dart';
import '../screen/login_screen.dart';
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

      if (!auth.isLoggedIn && !(isLoggingIn || isRegistering)) {
        return '/login';
      }

      // 👇 Handle splash redirect
      if (auth.isLoggedIn && (isLoggingIn || isRegistering || isSplash)) {
        return '/storyList';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/storyList',
        name: 'storyList',
        builder: (context, state) => StoriesListScreen(),
      ),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => StoriesListScreen(),
      // ),
    ],
  );
}
