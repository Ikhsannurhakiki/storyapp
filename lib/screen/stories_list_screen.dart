import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/static/story_list_result_state.dart';
import 'package:storyapp/widget/story_card.dart';

import '../flavor_config.dart';
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
      context.read<StoryListProvider>().fetchStoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Story App ${FlavorConfig.instance.values.titleApp}",
          style: StoryAppTextStyles.titleLarge,
        ),
        backgroundColor: FlavorConfig.instance.color,
      ),
      body: Consumer<StoryListProvider>(
        builder: (context, provider, _) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!provider.isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                provider.fetchMore();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () => provider.refresh(),
              child: switch (provider.resultState) {
                StoryListNoneState() || StoryListLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
                StoryListErrorState() => const Center(
                  child: Text("Error loading stories"),
                ),
                StoryListLoadedState(stories: var stories) => ListView.builder(
                  itemCount: stories.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < stories.length) {
                      return StoryCard(
                        stories: stories[index],
                        onTap: () => context.push(
                          '/home/storylist/detail/${stories[index].id}',
                          extra: LatLng(stories[index].lat ?? 0.0, stories[index].lon ?? 0.0),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          );
        },
      ),
    );
  }
}
