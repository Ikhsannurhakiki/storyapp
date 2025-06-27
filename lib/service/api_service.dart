import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storyapp/model/auth_response.dart';
import 'package:storyapp/model/story_list_response.dart';

class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJ1c2VyLUQwbWp4VU14Tk1McncwYW8iLCJpYXQiOjE3NTA4MjI0MjZ9.PbCp94qJ7CtY70v16hB9R_I8T9jhkhjSeYV-B03QA5E';


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
    int size = 15,
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
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return StoryListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load story list: ${response.body}');
    }
  }
}
