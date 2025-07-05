import 'package:flutter/foundation.dart';
import 'package:storyapp/static/story_list_result_state.dart';

import '../model/story.dart';
import '../service/api_service.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiServices _apiServices;
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  List<Story> stories = [];

  StoryListProvider(this._apiServices);

  StoryListResultState _resultState = StoryListNoneState();

  StoryListResultState get resultState => _resultState;

  Future<void> fetchStoryList() async {
    try {
      _resultState = StoryListLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryList(page: page);
      if (result.error) {
        _resultState = StoryListErrorState(result.message);
        notifyListeners();
      } else {
        stories.addAll(result.listStory);
        _resultState = StoryListLoadedState(stories);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = StoryListErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchMore() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();

    try {
      final result = await _apiServices.getStoryList(page: page);
      if (result.listStory.isEmpty) {
        hasMore = false;
      } else {
        stories.addAll(result.listStory);
        _resultState = StoryListLoadedState(stories);
        page++;
      }
    } on Exception catch (e) {
      _resultState = StoryListErrorState(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    page = 1;
    hasMore = true;
    stories.clear();
    await fetchMore();
  }
}
