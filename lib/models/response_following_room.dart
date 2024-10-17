// To parse this JSON data, do
//
//     final responseFriendRoom = responseFriendRoomFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/room_model.dart';

ResponseFriendRoom responseFriendRoomFromJson(String str) => ResponseFriendRoom.fromJson(json.decode(str));

String responseFriendRoomToJson(ResponseFriendRoom data) => json.encode(data.toJson());

class ResponseFriendRoom {
    String message;
    List<Room> data;

    ResponseFriendRoom({
        required this.message,
        required this.data,
    });

    factory ResponseFriendRoom.fromJson(Map<String, dynamic> json) => ResponseFriendRoom(
        message: json["message"],
        data: List<Room>.from(json["data"].map((x) => Room.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

