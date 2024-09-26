import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/models/response_profile.dart';

class ApiProfile {
  static Future<DataProfile> getAllPost(String userId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/profile/getAll/$userId');
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
}
