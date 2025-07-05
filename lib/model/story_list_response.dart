import 'package:storyapp/model/story.dart';

class StoryListResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryListResponse.fromJson(Map<String, dynamic> json) {
    return StoryListResponse(
      error: json['error'],
      message: json['message'],
      listStory: (json['listStory'] as List<dynamic>)
          .map((e) => Story.fromJson(e))
          .toList(),
    );
  }
}

