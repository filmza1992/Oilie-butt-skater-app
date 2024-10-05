// To parse this JSON data, do
//
//     final responseRoomPlayer = responseRoomPlayerFromJson(jsonString);

import 'dart:convert';

ResponseRoomPlayer responseRoomPlayerFromJson(String str) => ResponseRoomPlayer.fromJson(json.decode(str));

String responseRoomPlayerToJson(ResponseRoomPlayer data) => json.encode(data.toJson());

class ResponseRoomPlayer {
    String message;
    List<DataPlayer> data;

    ResponseRoomPlayer({
        required this.message,
        required this.data,
    });

    factory ResponseRoomPlayer.fromJson(Map<String, dynamic> json) => ResponseRoomPlayer(
        message: json["message"],
        data: List<DataPlayer>.from(json["data"].map((x) => DataPlayer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataPlayer {
    String userId;
    String username;
    String imageUrl;

   DataPlayer({
        required this.userId,
        required this.username,
        required this.imageUrl,
    });

    factory DataPlayer.fromJson(Map<String, dynamic> json) => DataPlayer(
        userId: json["user_id"],
        username: json["username"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "image_url": imageUrl,
    };
}
