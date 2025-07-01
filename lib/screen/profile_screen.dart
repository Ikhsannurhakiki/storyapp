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
    final navigator = GoRouter.of(context);
    final isLoggedIn = await authProvider.logout();
    final message = authProvider.message;

    scaffoldMessengerState.showSnackBar(SnackBar(content: Text(message)));

    if (!isLoggedIn) {
      navigator.go('/login');
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
                  onTap: () async {
                    await showDialog<bool>(
                      context: context,
                      builder: (_) => Consumer<AuthProvider>(
                        builder: (context, provider, _) => AlertDialog(
                          title: const Text("Log Out"),
                          content: const Text(
                            "Are you sure you want to log out?",
                          ),
                          actions: [
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => provider.isLoadingLogout? null :   Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: provider.isLoadingLogout? null : logOut,
                                  child: provider.isLoadingLogout
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Logging Out...",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                      : const Text(
                                    "Log Out",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
