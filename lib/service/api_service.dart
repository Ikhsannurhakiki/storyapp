import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storyapp/model/auth_response.dart';
import 'package:storyapp/model/story_list_response.dart';
import 'package:storyapp/model/story_response.dart';

import '../model/upload_response.dart';

class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  final String? token;

  ApiServices(this.token);

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
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

  Future<StoryResponse> getDetailStory(String id) async {
    final uri = Uri.parse("$_baseUrl/stories/$id");
    final response = await http.get(
      uri,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load story detail: ${response.body}');
    }
  }

  Future<UploadResponse> uploadDocument(
    List<int> bytes,
    String fileName,
    String description,
    double? lat,
    double? lon,
  ) async {
    const String url = "$_baseUrl/stories";

    final uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {"description": description};
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
    };

    request.files.add(multiPartFile);
    if (lat != null) request.fields['lat'] = lat.toString();
    if (lon != null) request.fields['lon'] = lon.toString();
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final UploadResponse uploadResponse = UploadResponse.fromJson(
        responseData,
      );
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
