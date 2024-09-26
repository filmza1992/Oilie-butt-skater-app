// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String userId;
    String username;
    String imageUrl;
    String email;
    String password;
    String birthDay;
    String createAt;

    User({
        required this.userId,
        required this.username,
        required this.imageUrl,
        required this.email,
        required this.password,
        required this.birthDay,
        required this.createAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        username: json["username"],
        imageUrl: json["image_url"],
        email: json["email"],
        password: json["password"],
        birthDay: json["birth_day"],
        createAt: json["create_at"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "image_url": imageUrl,
        "email": email,
        "password": password,
        "birth_day": birthDay,
        "create_at": createAt,
    };
}
