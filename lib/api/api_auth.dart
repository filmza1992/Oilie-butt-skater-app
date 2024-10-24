import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/api/api_user.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';

import '../models/user.dart';

class ApiAuth {
  static Future<User> verifyUser(String email, String password, context) async {
    try {
      final url = Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/auth/login');
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
        Alert().newWarning(
            context, 'กรุณาลองใหม่อีกครั้ง', 'อีเมล หรือ รหัสผ่านไม่ถูกต้อง');

        return throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<User> signUpUser(dynamic user) async {
    try {
      final url = Uri.parse('${dotenv.env['SERVER_LOCAL_IP']}/auth/signup');
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

  static Future<User> registerGoogleUser(
      Map<String, String?> googleProfile) async {
    try {
      // ตรวจสอบว่ามีผู้ใช้อยู่แล้วหรือไม่
      final email = googleProfile['email'];
      final existingUser = await ApiUser.getUserByEmail(email!);

      if (existingUser != null) {
        // ถ้ามีผู้ใช้อยู่แล้ว, return user object
        return existingUser;
      } else {
        // ถ้าไม่มีผู้ใช้, ลงทะเบียนผู้ใช้ใหม่
        final newUser = {
          'email': googleProfile['email'],
          'username': googleProfile['username'],
          'password':
              '', // หรือสามารถตั้งค่าเป็นค่าว่างหรือ hash password ของ Google ได้
          'birth_day': googleProfile['birth_day'],
          'image_url': googleProfile['image_url'],
        };

        final User user = await signUpUser(newUser);
        return user;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
