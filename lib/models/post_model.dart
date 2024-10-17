class Post {
  int postId;
  String username;
  String userImage;
  String title;
  String userId;
  int type;
  String tag;
  DateTime createdAt;
  List<String> content;
  int likes;
  int dislikes;
  int comments;
  int status;

  Post({
    required this.postId,
    required this.username,
    required this.userImage,
    required this.title,
    required this.userId,
    required this.type,
    required this.tag,
    required this.createdAt,
    required this.content,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.status,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"],
        username: json["username"],
        userImage: json["user_image"],
        title: json["title"],
        userId: json["user_id"],
        type: json["type"],
        tag: json["tag"],
        createdAt: DateTime.parse(json["created_at"]),
        content: List<String>.from(json["content"].map((x) => x)),
        likes: json["likes"],
        dislikes: json["dislikes"],
        comments: json["comments"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "username": username,
        "user_image": userImage,
        "title": title,
        "user_id": userId,
        "type": type,
        "tag": tag,
        "created_at": createdAt.toIso8601String(),
        "content": List<dynamic>.from(content.map((x) => x)),
        "likes": likes,
        "dislikes": dislikes,
        "comments": comments,
        "status": status,
      };
}
