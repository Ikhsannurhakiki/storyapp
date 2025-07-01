import 'package:flutter/material.dart';
import 'package:storyapp/static/story_detail_result_state.dart';

import '../service/api_service.dart';

class DetailProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  DetailProvider(this._apiServices);

  StoryDetailResultState _resultState = StoryDetailNoneState();

  StoryDetailResultState get resultState => _resultState;

  Future<void> getDetailStory(String id) async {
    _resultState = StoryDetailLoadingState();
    notifyListeners();

    try {
      final result = await _apiServices.getDetailStory(id);
      if (result.error) {
        _resultState = StoryDetailErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = StoryDetailLoadedState(result.story);
        notifyListeners();
      }
    } catch (e) {
      _resultState = StoryDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}
