import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/auth_provider.dart';
import 'package:storyapp/provider/story_list_provider.dart';
import 'package:storyapp/repository/auth_repository.dart';
import 'package:storyapp/routes/go_router_service.dart';
import 'package:storyapp/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepo = AuthRepository();
  final authProvider = AuthProvider(authRepo);
  await authProvider.getUser();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        Provider(
          create: (context) => ApiServices(),
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

