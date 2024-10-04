import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/models/comment_model.dart';
import 'package:oilie_butt_skater_app/models/response_ranking.dart';


class ApiRanking {
  static Future<DataRanking> getRankingPostPopular(String userId) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/ranking/month');
      print(url);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json', // Adjust the content type as needed.
          },
          body: jsonEncode({"user_id": userId}));

      if (response.statusCode == 200) { // ตรวจสอบสถานะที่ถูกต้อง
        print('GET request successful');
        print('Response data: ${response.body}');

        // แปลง JSON ที่ได้รับเป็น ResponseRanking
         final Map<String, dynamic> jsonData = json.decode(response.body);
        final data = ResponseRanking.fromJson(jsonData).data;
        return data; // ส่งคืน ResponseRanking
      } else {
        print('Failed to make the GET request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        throw Exception('Failed to load rankings'); // ขว้าง exception หากมีข้อผิดพลาด
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch data');
    }
  }
}