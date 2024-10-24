import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class ApiUser {
  static Future<User?> getUserByEmail(String email) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/user/getByEmail/$email');
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('GET request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['data'] != null) {
          final User user = User.fromJson(jsonData['data']);
          return user;
        } else {
          return null;
        }
      } else {
        print('Failed to make the GET request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  static Future<User> getUserById(String id) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/user/getById/$id');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
      );

      if (response.statusCode == 200) {
        print('GET request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);

        final User user = User.fromJson(jsonData['data']);
        return user;
      } else {
        print('Failed to make the GET request');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        return throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  
}
