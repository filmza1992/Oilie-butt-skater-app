// To parse this JSON data, do
//
//     final responseCreateRoom = responseCreateRoomFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/room_model.dart';

ResponseCreateRoom responseCreateRoomFromJson(String str) => ResponseCreateRoom.fromJson(json.decode(str));

String responseCreateRoomToJson(ResponseCreateRoom data) => json.encode(data.toJson());

class ResponseCreateRoom {
    String message;
    List<Room> data;

    ResponseCreateRoom({
        required this.message,
        required this.data,
    });

    factory ResponseCreateRoom.fromJson(Map<String, dynamic> json) => ResponseCreateRoom(
        message: json["message"],
        data: List<Room>.from(json["data"].map((x) => Room.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

