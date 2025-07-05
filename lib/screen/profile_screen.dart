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

  Future<void> logOut() async {
    final authProvider = context.read<AuthProvider>();
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    final isLoggedIn = await authProvider.logout();
    final message = authProvider.message;

    scaffoldMessengerState.showSnackBar(SnackBar(content: Text(message)));

    if (!isLoggedIn) {
      goRouter.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings and Profile",
          style: StoryAppTextStyles.titleLarge,
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (_, provider, _) {
          return SingleChildScrollView(
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
                  onTap: () => context.push('/logout-confirmation')

                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
