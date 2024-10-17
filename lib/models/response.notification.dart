// To parse this JSON data, do
//
//     final responseNotification = responseNotificationFromJson(jsonString);

import 'dart:convert';

ResponseNotification responseNotificationFromJson(String str) =>
    ResponseNotification.fromJson(json.decode(str));

String responseNotificationToJson(ResponseNotification data) =>
    json.encode(data.toJson());

class ResponseNotification {
  String message;
  List<DataNotification> data;

  ResponseNotification({
    required this.message,
    required this.data,
  });

  factory ResponseNotification.fromJson(Map<String, dynamic> json) =>
      ResponseNotification(
        message: json["message"],
        data: List<DataNotification>.from(
            json["data"].map((x) => DataNotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataNotification {
  int? postId;
  String? title;
  int? interactionCount;
  DateTime? lastInteractionTime;
  int? followId;
  String? userId;
  String? username;
  int? notify;
  DateTime? createAt;

  DataNotification({
    this.postId,
    this.title,
    this.interactionCount,
    this.lastInteractionTime,
    this.followId,
    this.userId,
    this.username,
    this.notify,
    this.createAt,
  });

  factory DataNotification.fromJson(Map<String, dynamic> json) =>
      DataNotification(
        postId: json["post_id"],
        title: json["title"],
        interactionCount: json["interaction_count"],
        lastInteractionTime: json["last_interaction_time"] == null
            ? null
            : DateTime.parse(json["last_interaction_time"]),
        followId: json["follow_id"],
        userId: json["user_id"],
        username: json["username"],
        notify: json["notify"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "title": title,
        "interaction_count": interactionCount,
        "last_interaction_time": lastInteractionTime?.toIso8601String(),
        "follow_id": followId,
        "user_id": userId,
        "username": username,
        "notify": notify,
        "create_at": createAt?.toIso8601String(),
      };
}
