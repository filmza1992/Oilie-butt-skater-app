// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/post_model.dart';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
    String message;
    DataProfile data;

    ProfileResponse({
        required this.message,
        required this.data,
    });

    factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        message: json["message"],
        data: DataProfile.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class DataProfile {
    List<Post> posts;
    int sumLikes;
    int follow;

    DataProfile({
        required this.posts,
        required this.sumLikes,
        required this.follow,
    });

    factory DataProfile.fromJson(Map<String, dynamic> json) => DataProfile(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        sumLikes: json["sumLikes"],
        follow: json["follow"],
    );

    Map<String, dynamic> toJson() => {
        "posts": List<Post>.from(posts.map((x) => x.toJson())),
        "sumLikes": sumLikes,
        "follow": follow,
    };
}
