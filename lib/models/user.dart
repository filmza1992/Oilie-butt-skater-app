import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String imageUrl;
  final String birthDay;
  final String createAt;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.imageUrl,
    required this.birthDay,
    required this.createAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, password: $password, imageUrl: $imageUrl, birthDay: $birthDay, createAt: $createAt}';
  }
}
