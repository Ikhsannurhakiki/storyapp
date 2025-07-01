import 'package:flutter/material.dart';
import 'package:storyapp/style/colors/app_colors.dart';
import 'package:storyapp/style/typography/story_app_text_styles.dart';
import 'package:storyapp/utils/date_utils_helper.dart';

import '../model/story.dart';

class StoryCard extends StatelessWidget {
  final Story stories;
  final Function() onTap;

  const StoryCard({super.key, required this.stories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.warmPeach.color,
                  child: Text(
                    stories.name.isNotEmpty ? stories.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: AppColors.darkTeal.color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  stories.name,
                  style: StoryAppTextStyles.bodyLargeBold,
                ),
                const Spacer(),
                const Icon(Icons.more_vert),
              ],
            ),
          ),

          Container(
            color: Colors.black,
            child: Image.network(
              stories.photoUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.scaleDown,
            ),
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text.rich(
              maxLines: 2,
              TextSpan(
                children: [
                  TextSpan(
                    text: stories.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " ${stories.description}"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(DateUtilsHelper.getTimeAgo(stories.createdAt)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
