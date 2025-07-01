import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/detail_provider.dart';
import 'package:storyapp/static/story_detail_result_state.dart';

import '../style/colors/app_colors.dart';
import '../style/typography/story_app_text_styles.dart';
import '../utils/date_utils_helper.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DetailProvider>().getDetailStory(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Story App", style: StoryAppTextStyles.headlineMedium),
          ),
          body: SafeArea(
            child: Consumer<DetailProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  StoryDetailLoadingState() =>  Center(
                    child: CircularProgressIndicator(color: AppColors.lightTeal.color,),
                  ),
                  StoryDetailLoadedState(story: var story) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.warmPeach.color,
                              child: Text(
                                story.name.isNotEmpty
                                    ? story.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: AppColors.darkTeal.color,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              story.name,
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
                          story.photoUrl,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
            
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: story.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: " ${story.description}"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(DateUtilsHelper.getTimeAgo(story.createdAt)),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  StoryDetailErrorState(errorMessage: var message) => Center(
                    child: Text(message),
                  ),
                  _ => const SizedBox(),
                };
              },
            ),
          ),
        );
      },
    );
  }
}
