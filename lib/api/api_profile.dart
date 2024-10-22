import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:oilie_butt_skater_app/models/response_profile.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class ApiProfile {
  static Future<DataProfile> getAllPost(String userId) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/profile/getAll/$userId');
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('GET request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        ProfileResponse profileResponse = ProfileResponse.fromJson(jsonData);
        if (profileResponse.data.posts.isNotEmpty) {
          // สร้าง PostResponse object ที่รวมข้อมูล posts, sumLikes, follow
          return DataProfile(
            posts: profileResponse.data.posts,
            sumLikes: profileResponse.data.sumLikes,
            follow: profileResponse.data.follow,
          );
        } else {
          // ส่งคืน PostResponse ที่ไม่มีข้อมูลในกรณีไม่มี post
          return DataProfile(posts: [], sumLikes: 0, follow: 0);
        }
      } else {
        print('Failed to make the GET request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return DataProfile(posts: [], sumLikes: 0, follow: 0);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
   static Future<DataProfile> getAllPostByUserId(String targetId, String userId) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/profile/getAllByUser/$targetId/$userId');
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('GET request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        ProfileResponse profileResponse = ProfileResponse.fromJson(jsonData);
        if (profileResponse.data.posts.isNotEmpty) {
          // สร้าง PostResponse object ที่รวมข้อมูล posts, sumLikes, follow
          return DataProfile(
            posts: profileResponse.data.posts,
            sumLikes: profileResponse.data.sumLikes,
            follow: profileResponse.data.follow,
          );
        } else {
          // ส่งคืน PostResponse ที่ไม่มีข้อมูลในกรณีไม่มี post
          return DataProfile(posts: [], sumLikes: 0, follow: 0);
        }
      } else {
        print('Failed to make the GET request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return DataProfile(posts: [], sumLikes: 0, follow: 0);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<User> editProfile(dynamic user) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/profile/edit/');

      // สร้าง body ของ request
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        User user = User.fromJson(jsonData['data']);

        return user;
      } else {
        print('Failed to update profile');
        print('Status code: ${response.statusCode}');
        return throw Exception();
      }
    } catch (e) {
      print('Error: $e');
      return throw Exception();
    }
  }

  static Future<User> editPassword(dynamic data, context) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/profile/edit/password');

      // สร้าง body ของ request
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        User user = User.fromJson(jsonData['data']);
        Navigator.pop(context);
        return user;
      } else {
        print('Failed to update profile');
        print('Status code: ${response.statusCode}');
        Alert().newWarning(
            context, 'รหัสผ่านเดิมไม่ถูกต้อง', 'กรุณากรอกรหัสผ่านใหม่อีกครั้ง');
        return throw Exception();
      }
    } catch (e) {
      print('Error: $e');
      return throw Exception();
    }
  }

  static Future<bool> checkPassword(userId) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/profile/check-empty-password');

      // สร้าง body ของ request
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        print('Profile check successfully');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        bool isNull = jsonData['data'];

        return isNull;
      } else {
        print('Failed to check profile');
        print('Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return throw Exception();
    }
  }
}
