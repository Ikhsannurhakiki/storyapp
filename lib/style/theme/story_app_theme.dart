import 'package:flutter/material.dart';
import 'package:storyapp/style/typography/story_app_text_styles.dart';

import '../colors/app_colors.dart';

class StoryAppTheme {
  static ThemeData get lightTheme =>
      ThemeData(
        colorSchemeSeed: AppColors.lightTeal.color,
        brightness: Brightness.light,
        textTheme: _textTheme,
        useMaterial3: true,
        appBarTheme: _appBarTheme,
      );

  static ThemeData get darkTheme =>
      ThemeData(
        colorSchemeSeed: AppColors.navyBlue.color,
        brightness: Brightness.dark,
        textTheme: _textTheme,
        useMaterial3: true,
        appBarTheme: _appBarTheme,
      );

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge:   StoryAppTextStyles.displayLarge,
      displayMedium:  StoryAppTextStyles.displayMedium,
      displaySmall:   StoryAppTextStyles.displaySmall,
      headlineLarge:  StoryAppTextStyles.headlineLarge,
      headlineMedium:   StoryAppTextStyles.headlineMedium,
      headlineSmall:  StoryAppTextStyles.headlineSmall,
      titleLarge:   StoryAppTextStyles.titleLarge,
      titleMedium:  StoryAppTextStyles.titleMedium,
      titleSmall:   StoryAppTextStyles.titleSmall,
      bodyLarge:  StoryAppTextStyles.bodyLargeBold,
      bodyMedium:   StoryAppTextStyles.bodyLargeMedium,
      bodySmall:  StoryAppTextStyles.bodyLargeRegular,
      labelLarge:   StoryAppTextStyles.labelLarge,
      labelMedium:  StoryAppTextStyles.labelMedium,
      labelSmall:   StoryAppTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }
}