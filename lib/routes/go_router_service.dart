import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storyapp/screen/main_screen.dart';
import 'package:storyapp/screen/post_screen.dart';

import '../dialog/bottom_sheet_page.dart';
import '../dialog/log_out_confirmation_dialog.dart';
import '../dialog/post_options_sheet.dart';
import '../provider/auth_provider.dart';
import '../screen/camera_screen.dart';
import '../screen/detail_screen.dart';
import '../screen/image_preview_screen.dart';
import '../screen/login_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/stories_list_screen.dart';

class GoRouterService {
  GoRouter get router => _router;
  final AuthProvider authProvider;

  GoRouterService(this.authProvider);

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/';
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final auth = authProvider;

      if (!auth.isInitialized && isSplash) return null;

      if (!auth.isLoggedIn && !isLoggingIn && !isRegistering && !isSplash) {
        return '/login';
      }

      if (auth.isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home/preview',
        name: 'preview',
        builder: (context, state) => const ImagePreviewScreen(),
      ),
      GoRoute(
        path: '/home/post',
        name: 'post',
        builder: (context, state) => const PostScreen(),
      ),
      GoRoute(
        path: '/post-options',
        pageBuilder: (context, state) {
          return BottomSheetPage(child: PostOptionsSheet());
        },
      ),
      GoRoute(
        path: '/logout-confirmation',
        pageBuilder: (context, state) {
          return BottomSheetPage(child: LogoutConfirmDialog());
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: 'storylist',
            builder: (context, state) => const StoriesListScreen(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return DetailScreen(id: id!);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/camera',
        pageBuilder: (context, state) {
          final cameras = state.extra as List<CameraDescription>;
          return MaterialPage(child: CameraScreen(cameras: cameras));
        },
      ),
    ],
  );
}
