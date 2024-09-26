import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/%E0%B8%B5util/firebase_upload_image_.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/controller/post_controller.dart';
import 'package:oilie_butt_skater_app/models/post_create_model.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';

class ApiPost {
  static Future<List<Post>> getAllPost(String userId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/post/getAll/$userId');
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('GET request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['data'] != null) {
          final List<Post> posts = (jsonData['data'] as List)
              .map((postJson) => Post.fromJson(postJson))
              .toList();
          return posts;
        } else {
          return [];
        }
      } else {
        print('Failed to make the GET request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> addPost(PostCreate post, context, update) async {
    try {
      Alert.loading(context);
      String imageUrl = await uploadImageToFirebasePost(post.content);
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/post/addPost');
      print(url);

      final data = {
        "title": post.title,
        "user_id": post.user_id,
        "create_at": DateTime.now().toIso8601String(),
        "url": imageUrl,
        "type": 1
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        print('Post request successful');
        Alert.success(
          context,
          () {
            Get.back();
            Get.back();
            update();
          },
        );

        return;
      } else {
        print('Failed to make the Post request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        Alert.error(
          context,
        );
        Navigator.pop(context);
        Get.to(const HomePage());
        return;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> updatePostInteraction(
      String userId, int postId, int status) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/post/interaction');
      print(url);

      final data = {
        "post_id": postId,
        "user_id": userId,
        "status": status,
        "create_at": DateTime.now().toIso8601String(),
        "notify": 1,
      };

      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Post request successful');

        return;
      } else {
        print('Failed to make the Post request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');

        return;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
