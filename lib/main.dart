import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyapp/provider/auth_provider.dart';
import 'package:storyapp/provider/story_list_provider.dart';
import 'package:storyapp/repository/auth_repository.dart';
import 'package:storyapp/routes/go_router_service.dart';
import 'package:storyapp/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final authRepo = AuthRepository(pref);
  final authProvider = AuthProvider(authRepo);
  await authProvider.getUser();
  final user = authProvider.user;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        Provider(
          create: (context) => ApiServices(user?.token),
        ),
        ChangeNotifierProvider(create: (context) => StoryListProvider(context.read<ApiServices>())),
        Provider(create: (_) => GoRouterService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      routerConfig: context.read<GoRouterService>().router,
    );
  }
}

