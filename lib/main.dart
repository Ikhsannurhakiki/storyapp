import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:storyapp/provider/auth_provider.dart';
import 'package:storyapp/provider/detail_provider.dart';
import 'package:storyapp/provider/main_provider.dart';
import 'package:storyapp/provider/map_provider.dart';
import 'package:storyapp/provider/profile_provider.dart';
import 'package:storyapp/provider/story_list_provider.dart';
import 'package:storyapp/provider/upload_provider.dart';

import 'package:storyapp/repository/auth_repository.dart';
import 'package:storyapp/routes/go_router_service.dart';
import 'package:storyapp/service/api_service.dart';
import 'package:storyapp/service/shared_preferences_service.dart';

import 'package:storyapp/style/theme/story_app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final sharedPrefService = SharedPreferencesService(prefs);
  final authRepo = AuthRepository(prefs);

  final authProvider = AuthProvider(authRepo);
  await authProvider.getUser();
  await authProvider.init();

  final profileProvider = ProfileProvider(sharedPrefService);
  await profileProvider.getTheme();

  final routerService = GoRouterService(authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: profileProvider),
        Provider.value(value: sharedPrefService),
        Provider.value(value: routerService),
        Provider(create: (_) => ApiServices(authProvider.user?.token)),
        ChangeNotifierProvider(
          create: (context) => StoryListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(create: (_) => MapProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
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


