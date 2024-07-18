import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class Post {
  final int postId;
  final String username;
  final String userImage;
  final String title;
  final String userId;
  final int type;
  final String tag;
  final dynamic createAt;
  final dynamic content;
  int likes;
  int dislikes;
  final int comments;
  int status;

  Post(
    this.postId,
    this.username,
    this.userImage,
    this.title,
    this.userId,
    this.type,
    this.tag,
    this.createAt,
    this.content,
    this.likes,
    this.dislikes,
    this.comments,
    this.status
  );

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
