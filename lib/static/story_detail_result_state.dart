import '../model/story.dart';

sealed class StoryDetailResultState {}

class StoryDetailNoneState extends StoryDetailResultState {}

class StoryDetailLoadingState extends StoryDetailResultState {}

class StoryDetailErrorState extends StoryDetailResultState {
  final String errorMessage;

  StoryDetailErrorState(this.errorMessage);
}

class StoryDetailLoadedState extends StoryDetailResultState {
  final Story story;

  StoryDetailLoadedState(this.story);
}
