// To parse this JSON data, do
//
//     final responseSearchPost = responseSearchPostFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/post_model.dart';

ResponseSearchPost responseSearchPostFromJson(String str) => ResponseSearchPost.fromJson(json.decode(str));

String responseSearchPostToJson(ResponseSearchPost data) => json.encode(data.toJson());

class ResponseSearchPost {
    String message;
    DataSearchPost data;

    ResponseSearchPost({
        required this.message,
        required this.data,
    });

    factory ResponseSearchPost.fromJson(Map<String, dynamic> json) => ResponseSearchPost(
        message: json["message"],
        data: DataSearchPost.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class DataSearchPost {
    List<Post> posts;

    DataSearchPost({
        required this.posts,
    });

    factory DataSearchPost.fromJson(Map<String, dynamic> json) => DataSearchPost(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
    };
}

