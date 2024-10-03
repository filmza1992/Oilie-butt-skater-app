// To parse this JSON data, do
//
//     final responseCommentByPostId = responseCommentByPostIdFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/comment_model.dart';

ResponseCommentByPostId responseCommentByPostIdFromJson(String str) => ResponseCommentByPostId.fromJson(json.decode(str));

String responseCommentByPostIdToJson(ResponseCommentByPostId data) => json.encode(data.toJson());

class ResponseCommentByPostId {
    String message;
    List<Comment> data;

    ResponseCommentByPostId({
        required this.message,
        required this.data,
    });

    factory ResponseCommentByPostId.fromJson(Map<String, dynamic> json) => ResponseCommentByPostId(
        message: json["message"],
        data: List<Comment>.from(json["data"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}
