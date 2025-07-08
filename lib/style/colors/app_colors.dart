import 'package:flutter/material.dart';

enum AppColors {
  warmPeach,
  lightTeal,
  orange,
  orangeRed,
  navyBlue,
  darkText,
  skinTone,
  darkTeal,
  softCream,
}

extension AppColorExtension on AppColors {
  Color get color {
    switch (this) {
      case AppColors.warmPeach:
        return const Color(0xFFF4B392);
      case AppColors.lightTeal:
        return const Color(0xFFB8DAD6);
      case AppColors.orange:
        return const Color(0xFFF5A84D);
      case AppColors.orangeRed:
        return const Color(0xFFEA7742);
      case AppColors.navyBlue:
        return const Color(0xFF1D3C58);
      case AppColors.darkText:
        return const Color(0xFF243F59);
      case AppColors.skinTone:
        return const Color(0xFFF5CBA7);
      case AppColors.darkTeal:
        return const Color(0xFF2E5E57);
      case AppColors.softCream:
        return const Color(0xFFF9EFE9);
    }
  }
}
