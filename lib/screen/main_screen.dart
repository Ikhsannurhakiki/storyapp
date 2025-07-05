import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/main_provider.dart';
import 'package:storyapp/screen/profile_screen.dart';
import 'package:storyapp/screen/stories_list_screen.dart';

import '../style/colors/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const StoriesListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<MainProvider>();
    return Scaffold(
      body: IndexedStack(index: provider.tabIndex, children: _screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () => context.push('/post-options'),
          backgroundColor: isDarkMode
              ? AppColors.darkTeal.color
              : AppColors.lightTeal.color,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: isDarkMode ? Colors.black : Colors.white,
              width: 3,
            ),
          ),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          height: 70,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                icon: Icon(
                  Icons.home,
                  color: provider.tabIndex == 0
                      ? AppColors.navyBlue.color
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () => provider.setTabIndex(0),
              ),
              const SizedBox(width: 3),
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                icon: Icon(
                  Icons.person,
                  color: provider.tabIndex == 1
                      ? AppColors.navyBlue.color
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () => provider.setTabIndex(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
