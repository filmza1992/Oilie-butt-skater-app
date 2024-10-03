// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
    int commentId;
    int postId;
    String userId;
    String commentText;
    DateTime createAt;
    String username;
    String userImage;

    Comment({
        required this.commentId,
        required this.postId,
        required this.userId,
        required this.commentText,
        required this.createAt,
        required this.username,
        required this.userImage,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["comment_id"],
        postId: json["post_id"],
        userId: json["user_id"],
        commentText: json["comment_text"],
        createAt: DateTime.parse(json["create_at"]),
        username: json["username"],
        userImage: json["user_image"],
    );

    Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "post_id": postId,
        "user_id": userId,
        "comment_text": commentText,
        "create_at": createAt.toIso8601String(),
        "username": username,
        "user_image": userImage,
    };
}
