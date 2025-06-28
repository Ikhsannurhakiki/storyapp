import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/screen/main_screen.dart';
import 'package:storyapp/screen/post_screen.dart';

import '../provider/auth_provider.dart';
import '../screen/image_preview_screen.dart';
import '../screen/login_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/stories_list_screen.dart';

class GoRouterService  {
  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final auth = context.read<AuthProvider>();

      final isSplash = state.matchedLocation == '/';
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (!auth.isInitialized) return null;
      if (auth.isLoggedIn && (isSplash)) {
        return '/login';
      }

      if (auth.isLoggedIn && (isLoggingIn || isRegistering || isSplash)) {
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
        path: '/home/storyList',
        name: 'storyList',
        builder: (context, state) => const StoriesListScreen(),
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
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainScreen(),
      ),
    ],
  );
}


