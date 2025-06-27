import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../style/colors/app_colors.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<String> _routes = [
    '/home/storyList',
    '/home/post', // fake route, triggered by center FAB
    '/home/profile',
  ];

  void _onTap(int index) {
    if (index == 1) {
      context.go('/home/post'); // Handle post separately
    } else {
      context.go(_routes[index]);
      setState(() => _currentIndex = index > 1 ? index - 1 : index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onTap(1),
        backgroundColor: AppColors.orangeRed.color,
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
          color: Colors.white,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? AppColors.orangeRed.color
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () => _onTap(0),
              ),
              const SizedBox(width: 0), // space for FAB
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 1
                      ? AppColors.orangeRed.color
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () => _onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
