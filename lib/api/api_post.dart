import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/%E0%B8%B5util/firebase_upload_image_.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:oilie_butt_skater_app/models/post_create_model.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';

class ApiPost {
  static Future<List<Post>> getAllPost(String userId) async {
    try {
      final url =
          Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/post/getAll/$userId');
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

  static Future<List<Post>> getPostWithPostId(
      String postId, String userId) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/post/getByPostId/$postId/$userId');
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

  static Future<List<Post>> getFeed(String userId) async {
    try {
      final url =
          Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/post/feed/$userId');
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
      List<String> mediaUrls = [];

      showDialog(
        context: context,
        barrierDismissible: false, // ป้องกันการปิด dialog ด้วยการกดข้างนอก
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      // อัปโหลดภาพทั้งหมดที่ได้รับจาก post.images
      if (post.type == 2) {
        for (var videoFile in post.content) {
          String imageUrl = await uploadVideoToFirebasePost(videoFile);
          mediaUrls.add(imageUrl); // เก็บ URL ของแต่ละภาพ
        }
      } else {
        for (var imageFile in post.content) {
          String imageUrl = await uploadImageToFirebasePost(imageFile);
          mediaUrls.add(imageUrl); // เก็บ URL ของแต่ละภาพ
        }
      }

      final url = Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/post/addPost');
      print(url);
      var data = {};
      if (post.type == 2) {
        data = {
          "title": post.title,
          "user_id": post.user_id,
          "create_at": DateTime.now().toIso8601String(),
          "urls": mediaUrls, // ส่งลิสต์ URL ของภาพ
          "type": 2
        };
      } else {
        data = {
          "title": post.title,
          "user_id": post.user_id,
          "create_at": DateTime.now().toIso8601String(),
          "urls": mediaUrls, // ส่งลิสต์ URL ของภาพ
          "type": 1
        };
      }

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      Navigator.pop(context);
      if (response.statusCode == 200) {
        print('Post request successful');
        Get.to(const HomePage());
        return;
      } else {
        print('Failed to make the Post request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        Alert.error(context);
        Navigator.pop(context);
        Get.to(const HomePage());
        return;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> updatePost(
      PostCreate post, context, update, String postId) async {
    try {
      final url =
          Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/post/update/$postId');
      print(url);

      final data = {
        "title": post.title,
        "user_id": post.user_id,
        "post_id": postId
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
        Get.to(const HomePage());

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
      final url =
          Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/post/interaction');
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

  static Future<void> deletePost(String postId, String userId) async {
    try {
      // สร้าง URL สำหรับการลบโพสต์
      final url = Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/post/delete/');

      print(url);

      final data = {
        "post_id": postId,
        "user_id": userId,
      };
      // ส่งคำขอ DELETE
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('DELETE request successful');
        print('Response data: ${response.body}');
      } else {
        print('Failed to make the DELETE request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred while deleting post: $e');
      throw Exception(e);
    }
  }
}
