import '../model/story.dart';

sealed class StoryListResultState {}

class StoryListNoneState extends StoryListResultState {}

class StoryListLoadingState extends StoryListResultState {}

class StoryListErrorState extends StoryListResultState {
  final String errorMessage;

  StoryListErrorState(this.errorMessage);
}

class StoryListLoadedState extends StoryListResultState {
  final List<Story> stories;

  StoryListLoadedState(this.stories);
}
