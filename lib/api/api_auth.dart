import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/api/api_user.dart';

import '../models/user.dart';

class ApiAuth {
  static Future<User> verifyUser(String email, String password) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/auth/login');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        final User user = User.fromJson(jsonData['data']);
        return user;
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

  static Future<User> signUpUser(dynamic user) async {
    try {
      final url = Uri.parse(
          'http://${dotenv.env['SERVER_LOCAL_IP']}:${dotenv.env['SERVER_PORT_LOCAL']}/auth/signup');
      print(url);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json', // Adjust the content type as needed.
        },
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        dynamic userId = jsonData['userId'];
        print(userId);

        final User user = await ApiUser.getUserById(userId);
        return user;
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
}
