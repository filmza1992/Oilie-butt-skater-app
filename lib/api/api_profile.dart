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

class ApiProfile {
  static Future<List<Post>> getAllPost(String userId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/profile/getAll/$userId');
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
}
