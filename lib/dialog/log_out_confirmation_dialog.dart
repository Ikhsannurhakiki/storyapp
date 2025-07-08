import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
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

    final provider = context.watch<AuthProvider>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Log Out",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(height: 30, thickness: 2),
            const SizedBox(height: 12),
            const Text("Are you sure you want to log out?"),
            const SizedBox(height: 24),
            TextButton(
              onPressed: provider.isLoadingLogout
                  ? null
                  : () => context.pop(false),
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: provider.isLoadingLogout
                  ? null
                  : () async {
                      logOut();
                      context.pop(true);
                    },
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
                        const SizedBox(width: 16),
                        Text(
                          "Logging Out...",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )
                  : const Text("Log Out", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
