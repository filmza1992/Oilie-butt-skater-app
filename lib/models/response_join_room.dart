import 'dart:convert';

import 'package:oilie_butt_skater_app/models/room_model.dart';

ResponseJoinRoom responseJoinRoomFromJson(String str) =>
    ResponseJoinRoom.fromJson(json.decode(str));

String responseJoinRoomToJson(ResponseJoinRoom data) =>
    json.encode(data.toJson());

class ResponseJoinRoom {
  String message;
  DataJoinRoom data;

  ResponseJoinRoom({
    required this.message,
    required this.data,
  });

  factory ResponseJoinRoom.fromJson(Map<String, dynamic> json) =>
      ResponseJoinRoom(
        message: json["message"],
        data: DataJoinRoom.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class DataJoinRoom {
  List<Room> joinedRooms;
  List<Room> createdRooms;

  DataJoinRoom({
    required this.joinedRooms,
    required this.createdRooms,
  });

  factory DataJoinRoom.fromJson(Map<String, dynamic> json) => DataJoinRoom(
        joinedRooms:
            List<Room>.from(json["joinedRooms"].map((x) => Room.fromJson(x))),
        createdRooms:
            List<Room>.from(json["createdRooms"].map((x) => Room.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "joinedRooms": List<dynamic>.from(joinedRooms.map((x) => x)),
        "createdRooms": List<dynamic>.from(createdRooms.map((x) => x.toJson())),
      };
}
