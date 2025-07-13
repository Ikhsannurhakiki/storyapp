import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? userId;
  String? name;
  String? token;

  User({required this.userId, required this.name, required this.token});

  @override
  String toString() => 'User(userId: $userId, name: $name, token: $token)';

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'name': name, 'token': token};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(userId: map['userId'], name: map['name'], token: map['token']);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          token == other.token;

  @override
  int get hashCode => Object.hash(userId, name, token);
}
