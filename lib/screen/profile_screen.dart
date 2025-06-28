import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/profile_provider.dart';

import '../provider/auth_provider.dart';
import '../style/typography/story_app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings and Profile",
          style: StoryAppTextStyles.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SwitchListTile(
              secondary: Icon(Icons.dark_mode_outlined),
              title: const Text("Dark Mode"),
              value: profileProvider.isDark,
              onChanged: (value) {
                profileProvider.saveTheme(value);
                profileProvider.isDark = value;
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.navigate_next_rounded),
              title: const Text("Log Out"),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Log Out"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await authProvider.logout();
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
