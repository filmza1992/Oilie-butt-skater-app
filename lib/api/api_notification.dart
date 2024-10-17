import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/models/response.notification.dart';

class ApiNotification {
  static Future<List<DataNotification>> getNotification(String userId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/notification/$userId');
      print(url);
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        final ResponseNotification responseNotification =
            ResponseNotification.fromJson(jsonData);
        return responseNotification.data;
      } else {
        print('Failed to make the POST request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> updatePostInteraction(
      String postId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/notification/$postId/');

      print(url);

      // กำหนดข้อมูลที่ต้องการส่งไปยัง API
      final Map<String, dynamic> data = {
        'postId': postId,
        'action': 'update', // หรือข้อมูลอื่นๆ ที่ต้องการระบุ
        // คุณสามารถเพิ่มข้อมูลอื่น ๆ ที่ต้องการอัปเดตได้ที่นี่
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json', // กำหนดชนิดของข้อมูลที่ส่ง
        },
        body: json.encode(data), // แปลงข้อมูลเป็น JSON
      );

      if (response.statusCode == 200) {
        print('PUT request successful');
      } else {
        print('Failed to make the PUT request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        throw Exception('Failed to update post interaction');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception(e);
    }
  }

  static Future<void> updateFollow(
      String followId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/notification/follow/$followId/');

      print(url);

      // กำหนดข้อมูลที่ต้องการส่งไปยัง API
      final Map<String, dynamic> data = {
        'followId': followId,
        'action': 'update', // หรือข้อมูลอื่นๆ ที่ต้องการระบุ
        // คุณสามารถเพิ่มข้อมูลอื่น ๆ ที่ต้องการอัปเดตได้ที่นี่
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json', // กำหนดชนิดของข้อมูลที่ส่ง
        },
        body: json.encode(data), // แปลงข้อมูลเป็น JSON
      );

      if (response.statusCode == 200) {
        print('PUT request successful');
      } else {
        print('Failed to make the PUT request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        throw Exception('Failed to update post interaction');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception(e);
    }
  }
}
