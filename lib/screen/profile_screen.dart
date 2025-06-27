import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isDarkMode = false;


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: provider.isDark,
              onChanged: (value) {
                provider.saveTheme(value);
                provider.isDark = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
