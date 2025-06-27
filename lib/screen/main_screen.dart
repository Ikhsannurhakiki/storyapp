import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onTap(2),
        backgroundColor: AppColors.navyBlue.color,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Colors.white, width: 3),
        ),
        child: const Icon(Icons.add, size: 25),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? AppColors.navyBlue.color : Colors.grey,
                  size: 30,
                ),
                onPressed: () => _onTap(0),
              ),
              const SizedBox(width: 3), // space for FAB
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 1 ? AppColors.navyBlue.color : Colors.grey,
                  size: 30,
                ),
                onPressed: () => _onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

