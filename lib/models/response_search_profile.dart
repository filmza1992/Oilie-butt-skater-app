// To parse this JSON data, do
//
//     final searchProfile = searchProfileFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/user.dart';

SearchProfileResponse searchProfileFromJson(String str) => SearchProfileResponse.fromJson(json.decode(str));

String searchProfileToJson(SearchProfileResponse data) => json.encode(data.toJson());

class SearchProfileResponse {
    String message;
    DataSearchUser data;

    SearchProfileResponse({
        required this.message,
        required this.data,
    });

    factory SearchProfileResponse.fromJson(Map<String, dynamic> json) => SearchProfileResponse(
        message: json["message"],
        data: DataSearchUser.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class DataSearchUser {
    List<User> users;

    DataSearchUser({
        required this.users,
    });

    factory DataSearchUser.fromJson(Map<String, dynamic> json) => DataSearchUser(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}
