import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/models/response_profile.dart';
import 'package:oilie_butt_skater_app/models/response_search_profile.dart';

class ApiSearch {
  static Future<DataSearchUser> getUsers(String username) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/search/getUsers/');
      print(url);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type':
                'application/json', // Adjust the content type as needed.
          },
          body: jsonEncode({"username": username}));

      if (response.statusCode == 200) {
        print('GET request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        SearchProfileResponse searchResponse =
            SearchProfileResponse.fromJson(jsonData);
        if (searchResponse.data.users.isNotEmpty) {
          // สร้าง PostResponse object ที่รวมข้อมูล posts, sumLikes, follow
          return DataSearchUser(users: searchResponse.data.users);
        } else {
          // ส่งคืน PostResponse ที่ไม่มีข้อมูลในกรณีไม่มี post
          return DataSearchUser(users: []);
        }
      } else {
        print('Failed to make the GET request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return DataSearchUser(users: []);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
