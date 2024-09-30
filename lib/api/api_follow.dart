import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/models/response_profile.dart';

class ApiFollow {
  
  static Future<DataProfile> followUser(String userId, String targetId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/follow/following');
      print(url);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type':
                'application/json', // Adjust the content type as needed.
          },
          body: jsonEncode({
            "user_id": userId,
            "target_id": targetId,
            "create_at": DateTime.now().toIso8601String(),
            "notify": 1,
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
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
        print('Failed to make the Post request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return DataProfile(posts: [], sumLikes: 0, follow: 0);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<DataProfile> unfollowUser(String userId, String targetId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/follow/unfollowing');
      print(url);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type':
                'application/json', // Adjust the content type as needed.
          },
          body: jsonEncode({
            "user_id": userId,
            "target_id": targetId,
            "create_at": DateTime.now().toIso8601String(),
            "notify": 1,
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
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
        print('Failed to make the Post request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return DataProfile(posts: [], sumLikes: 0, follow: 0);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> checkFollower(
      String userId, String targetId,room) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/follow/check/following');
      print(url);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type':
                'application/json', // Adjust the content type as needed.
          },
          body: jsonEncode({
            "user_id": userId,
            "target_id": targetId,
            "room": room
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        bool isFollower = jsonData['isFollower'];
        return isFollower;
      } else {
        print('Failed to make the Post request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
