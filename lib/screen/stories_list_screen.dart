import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/static/story_list_result_state.dart';
import 'package:storyapp/widget/storyCard.dart';

import '../model/story.dart';
import '../provider/auth_provider.dart';
import '../provider/story_list_provider.dart';
import '../style/typography/story_app_text_styles.dart';

class StoriesListScreen extends StatefulWidget {
  const StoriesListScreen({super.key});

  @override
  State<StoriesListScreen> createState() => _StoriesListScreenState();
}

class _StoriesListScreenState extends State<StoriesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<StoryListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("Quotes App", style: StoryAppTextStyles.headlineMedium,)),
      body: Consumer<StoryListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            StoryListNoneState() => const Center(
              child: CircularProgressIndicator(),
            ),
            StoryListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            StoryListErrorState() => const Center(
              child: CircularProgressIndicator(),
            ),
            StoryListLoadedState(stories: var stories) => ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return StoryCard(stories: stories[index]);
              },
            ),
          };
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final authRead = context.read<AuthProvider>();
          // final result = await authRead.logout();
          // if (result) widget.onLogout();
        },
        tooltip: "Logout",

        child: authWatch.isLoadingLogout
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.logout),
      ),
    );
  }
}
