import 'package:storyapp/model/story.dart';

class StoryResponse {
  final bool error;
  final String message;
  final Story story;

  StoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      error: json['error'],
      message: json['message'],
      story: Story.fromJson(json['story']),
    );
  }
}
