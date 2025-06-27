import 'package:flutter/material.dart';

import '../model/story.dart';

class StoryCard extends StatelessWidget {
  final Story stories;

  const StoryCard({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(stories.photoUrl),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Text(stories.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.more_vert),
            ],
          ),
        ),

        // Image
        Image.network(
          stories.photoUrl,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: const [
              Icon(Icons.favorite_border),
              SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline),
              SizedBox(width: 16),
              Icon(Icons.send),
              Spacer(),
              Icon(Icons.bookmark_border),
            ],
          ),
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: stories.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: stories.description),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
