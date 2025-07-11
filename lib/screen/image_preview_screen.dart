import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/main_provider.dart';

import '../style/colors/app_colors.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = context.read<MainProvider>().imagePath;
    if (imagePath == null) {
      context.pop();
    }
    return Scaffold(
      body: Center(
        child: Image.file(File(imagePath.toString()), fit: BoxFit.contain),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => context.pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.cancel_outlined, color: Colors.red),
                    const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightTeal.color,
                ),
                onPressed: () => context.push("/home/post"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.next_plan_outlined, color: Colors.black),
                    const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
