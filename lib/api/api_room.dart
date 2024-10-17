import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/api/api_chat_room.dart';
import 'package:oilie_butt_skater_app/models/response_create_room.dart';
import 'package:oilie_butt_skater_app/models/response_following_room.dart';
import 'package:oilie_butt_skater_app/models/response_history_room.dart';
import 'package:oilie_butt_skater_app/models/response_join_room.dart';
import 'package:oilie_butt_skater_app/models/response_room_player.dart';
import 'package:oilie_butt_skater_app/models/response_room_public.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class ApiRoom {
  static Future<Room> createRoom(dynamic data) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/');
    print(url);

    try {
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data), // แปลงข้อมูลเป็น JSON เพื่อส่งไปยัง API
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room created successfully");
        print('Response data: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        ResponseCreateRoom responseCreateRoom =
            ResponseCreateRoom.fromJson(jsonData);
        return responseCreateRoom.data[0];
      } else {
        print("Failed to create room: ${response.body}");
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to load rankings');
    }
  }

  static Future<void> joinRoom(Room room, User user) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/join');
    print(url);

    try {
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'room_id': room.roomId,
          'user_id': user.userId
        }), // แปลงข้อมูลเป็น JSON เพื่อส่งไปยัง API
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room join successfully");
        print('Response data: ${response.body}');
        final chatRoom =
            await ApiChatRoom.getChatRoomsWithRoomId(room.roomId.toString());

        List<dynamic> users = List<dynamic>.from(chatRoom.users);

        // ตรวจสอบว่าผู้ใช้ไม่ได้อยู่ในห้องแล้ว
        if (!users.contains(user.userId)) {
          // เพิ่มผู้ใช้ในรายการ users
          users.add({
            "image_url": user.imageUrl,
            "user_id": user.userId,
            "username": user.username
          });

          // อัปเดตข้อมูล users ใน Firebase
          await FirebaseDatabase.instance
              .ref('chat_rooms/${chatRoom.chatRoomId}')
              .update({
            'users': users, // อัปเดตรายการ users ใหม่
          });

          print("User added to chat room successfully");
        } else {
          print("User already in the chat room");
        }
      } else {
        print("Failed to join room: ${response.body}");
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to load rankings');
    }
  }

  static Future<void> quitRoom(Room room, User user) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/quit');
    print(url);

    try {
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'room_id': room.roomId,
          'user_id': user.userId
        }), // แปลงข้อมูลเป็น JSON เพื่อส่งไปยัง API
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room join successfully");
        print('Response data: ${response.body}');
      } else {
        print("Failed to join room: ${response.body}");
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to load rankings');
    }
  }

  static Future<void> deleteRoom(dynamic data) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/$data');
    print(url);

    try {
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.delete(
        url,
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room DELETE successfully");
        print('Response data: ${response.body}');
      } else {
        print("Failed to delete room: ${response.body}");
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to load rooms');
    }
  }

  static Future<List<DataPlayer>> getPlayers(String roomId) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/$roomId/users');
    print(url);

    try {
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.get(
        url,
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room created successfully");
        print('Response data: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        ResponseRoomPlayer responseCreateRoom =
            ResponseRoomPlayer.fromJson(jsonData);
        return responseCreateRoom.data;
      } else {
        print("Failed to create room: ${response.body}");
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to load rankings');
    }
  }

  static Future<List<Room>> getPublicRoom(
      userId, double latitude, double longitude) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/public/$userId');
    print(url);

    try {
      final body = json.encode({
        'latitude': latitude,
        'longitude': longitude,
      });
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // กำหนดประเภทข้อมูล
        body: body, // ส่งข้อมูล latitude และ longitude ใน body
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room created successfully");
        print('Response data: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        ResponseRoomPublic responseRoomPublic =
            ResponseRoomPublic.fromJson(jsonData);
        return responseRoomPublic.data;
      } else {
        print("Failed to get public room: ${response.body}");
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to load rankings');
    }
  }

  static Future<DataJoinRoom> getJoinRoom(
      userId, double latitude, double longitude) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/join/$userId');
    print(url);

    try {
      // สร้างข้อมูลที่จะส่งไปยัง API ผ่าน body
      final body = json.encode({
        'latitude': latitude,
        'longitude': longitude,
      });

      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // กำหนดประเภทข้อมูล
        body: body, // ส่งข้อมูล latitude และ longitude ใน body
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room created successfully");
        print('Response data: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        ResponseJoinRoom responseRoomPublic =
            ResponseJoinRoom.fromJson(jsonData);
        return responseRoomPublic.data;
      } else {
        print("Failed to get public room: ${response.body}");
        throw Exception('Failed to get public room');
      }
    } catch (e) {
      print("Error occurred while getting room: $e");
      throw Exception('Failed to get public room');
    }
  }

  static Future<List<Room>> getFriendRoom(
      userId, double latitude, double longitude) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/follow/$userId');
    print(url);

    try {
      final body = json.encode({
        'latitude': latitude,
        'longitude': longitude,
      });
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // กำหนดประเภทข้อมูล
        body: body, // ส่งข้อมูล latitude และ longitude ใน body
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room created successfully");
        print('Response data: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        ResponseFriendRoom responseRoomPublic =
            ResponseFriendRoom.fromJson(jsonData);
        return responseRoomPublic.data;
      } else {
        print("Failed to get public room: ${response.body}");
        throw Exception('Failed to get public room');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to get public room');
    }
  }

  static Future<DataHistoryRoom> getHistoryRoom(userId) async {
    final url = Uri.parse(
        'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/room/history/$userId');
    print(url);

    try {
      // ส่งคำขอ POST พร้อมข้อมูลไปยัง API
      final response = await http.get(
        url,
      );

      // ตรวจสอบผลลัพธ์ของคำขอ
      if (response.statusCode == 200) {
        print("Room created successfully");
        print('Response data: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        ResponseHistoryRoom responseRoomPublic =
            ResponseHistoryRoom.fromJson(jsonData);
        return responseRoomPublic.data;
      } else {
        print("Failed to get public room: ${response.body}");
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      print("Error occurred while creating room: $e");
      throw Exception('Failed to load rankings');
    }
  }
}
