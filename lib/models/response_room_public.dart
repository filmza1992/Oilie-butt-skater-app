// To parse this JSON data, do
//
//     final responseRoomPublic = responseRoomPublicFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/room_model.dart';

ResponseRoomPublic responseRoomPublicFromJson(String str) => ResponseRoomPublic.fromJson(json.decode(str));

String responseRoomPublicToJson(ResponseRoomPublic data) => json.encode(data.toJson());

class ResponseRoomPublic {
    String message;
    List<Room> data;

    ResponseRoomPublic({
        required this.message,
        required this.data,
    });

    factory ResponseRoomPublic.fromJson(Map<String, dynamic> json) => ResponseRoomPublic(
        message: json["message"],
        data: List<Room>.from(json["data"].map((x) => Room.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}
