import 'package:flutter/foundation.dart';
import 'package:storyapp/static/story_list_result_state.dart';

import '../service/api_service.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  StoryListProvider(this._apiServices);

  StoryListResultState _resultState = StoryListNoneState();

  StoryListResultState get resultState => _resultState;

  Future<void> fetchRestaurantList() async {
    try {
      _resultState = StoryListLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryList();
      if (result.error) {
        _resultState = StoryListErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = StoryListLoadedState(result.listStory);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = StoryListErrorState(e.toString());
      notifyListeners();
    }
  }
}
