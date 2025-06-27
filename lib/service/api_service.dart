import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storyapp/model/auth_response.dart';
import 'package:storyapp/model/story_list_response.dart';

class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  final String? token;
  ApiServices(this.token);

  Future<RegisterResponse> register(String name, String email, String password) async {
    final response = await http.post(Uri.parse("$_baseUrl/register"));
    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<LoginResult> login(String email, String password) async {
    final response = await http.post(Uri.parse("$_baseUrl/login"));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body)).loginResult;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<StoryListResponse> getStoryList({
    int page = 1,
    int size = 10,
    int location = 0,
  }) async {
    final uri = Uri.parse("$_baseUrl/stories").replace(
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'location': location.toString(),
      },
    );
    final response = await http.get(
      uri,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return StoryListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load story list: ${response.body}');
    }
  }
}
