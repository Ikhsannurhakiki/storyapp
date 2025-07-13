import 'package:json_annotation/json_annotation.dart';
import 'package:storyapp/model/story.dart';

part 'story_response.g.dart';

@JsonSerializable()
class StoryResponse {
  final bool error;
  final String message;
  final Story story;

  StoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) => _$StoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResponseToJson(this);
}
