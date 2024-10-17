import 'dart:convert';

import 'package:oilie_butt_skater_app/models/room_has_user.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';

ResponseHistoryRoom responseJoinRoomFromJson(String str) =>
    ResponseHistoryRoom.fromJson(json.decode(str));

String responseJoinRoomToJson(ResponseHistoryRoom data) =>
    json.encode(data.toJson());

class ResponseHistoryRoom {
  String message;
  DataHistoryRoom data;

  ResponseHistoryRoom({
    required this.message,
    required this.data,
  });

  factory ResponseHistoryRoom.fromJson(Map<String, dynamic> json) =>
      ResponseHistoryRoom(
        message: json["message"],
        data: DataHistoryRoom.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class DataHistoryRoom {
  List<RoomUser> joinedRooms;
  List<RoomUser> exitedRooms;
  List<RoomUser> createdRooms;

  DataHistoryRoom({
    required this.joinedRooms,
    required this.exitedRooms,
    required this.createdRooms,
  });

  factory DataHistoryRoom.fromJson(Map<String, dynamic> json) => DataHistoryRoom(
        joinedRooms:
            List<RoomUser>.from(json["joinedRooms"].map((x) => RoomUser.fromJson(x))),
        exitedRooms:
            List<RoomUser>.from(json["exitedRooms"].map((x) => RoomUser.fromJson(x))),
        createdRooms:
            List<RoomUser>.from(json["createdRooms"].map((x) => RoomUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "joinedRooms": List<dynamic>.from(joinedRooms.map((x) => x)),
        "createdRooms": List<dynamic>.from(createdRooms.map((x) => x.toJson())),
      };
}
