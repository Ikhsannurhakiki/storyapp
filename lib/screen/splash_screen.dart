import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../animations/loader_animation.dart';
import '../flavor_config.dart';
import '../flutter_mode_config.dart';
import '../provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      final auth = context.read<AuthProvider>();
      if (auth.isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
          if (!snapshot.hasData) return Container();
          PackageInfo? _packageInfo = snapshot.data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: MediaQuery.of(context).size / 2,
                      painter: LoaderAnimation(
                        angle: animation.value * 10 * math.pi,
                        progress: animation.value,
                      ),
                    );
                  },
                ),
                Text(
                  "Flavor: ${FlavorConfig.instance.flavor.name}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  "Mode: ${FlutterModeConfig.flutterMode}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
                const Divider(height: 32, thickness: 2),
                Text(
                  "App Name : ${_packageInfo?.appName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  "Package Name : ${_packageInfo?.packageName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  "Version Name : ${_packageInfo?.version}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
