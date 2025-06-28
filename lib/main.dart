import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyapp/provider/auth_provider.dart';
import 'package:storyapp/provider/main_provider.dart';
import 'package:storyapp/provider/profile_provider.dart';
import 'package:storyapp/provider/story_list_provider.dart';
import 'package:storyapp/repository/auth_repository.dart';
import 'package:storyapp/routes/go_router_service.dart';
import 'package:storyapp/service/api_service.dart';
import 'package:storyapp/service/shared_preferences_service.dart';
import 'package:storyapp/style/theme/story_app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final authRepo = AuthRepository(pref);
  final authProvider = AuthProvider(authRepo);
  await authProvider.getUser();
  final user = authProvider.user;
  final service = SharedPreferencesService(pref);
  final profileProvider = ProfileProvider(service);
  await profileProvider.getTheme();
  await authProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        Provider(create: (context) => SharedPreferencesService(pref)),
        ChangeNotifierProvider(
          create: (context) =>
              ProfileProvider(context.read<SharedPreferencesService>()),
        ),
        Provider(create: (context) => ApiServices(user?.token)),
        ChangeNotifierProvider(
          create: (context) => StoryListProvider(context.read<ApiServices>()),
        ),
        Provider(create: (_) => GoRouterService()),
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        ),
      ],
      child: ChangeNotifierProvider.value(
        value: profileProvider,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return MaterialApp.router(
          title: 'Story App',
          theme: StoryAppTheme.lightTheme,
          darkTheme: StoryAppTheme.darkTheme,
          themeMode: provider.isDark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: context.read<GoRouterService>().router,
        );
      },
    );
  }
}
