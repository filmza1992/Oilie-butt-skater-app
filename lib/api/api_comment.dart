import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:oilie_butt_skater_app/models/comment_model.dart';
import 'package:oilie_butt_skater_app/models/response_comment_by_post.dart';

class ApiComment {
  static Future<List<Comment>> addCommentByPostId(int postId, String userId,
      String commentText, updateComment) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/comment/$postId');
      print(url);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type':
                'application/json', // Adjust the content type as needed.
          },
          body: jsonEncode({"comment_text": commentText, "user_id": userId}));

      if (response.statusCode == 201) {
        print('GET request successful');
        print('Response data: ${response.body}');

        var data = await ApiComment.getCommentByPostId(postId);
        List<Comment> comments = data;
        updateComment(comments);
        if (comments.isNotEmpty) {
          // สร้าง PostResponse object ที่รวมข้อมูล posts, sumLikes, follow
          return comments;
        } else {
          // ส่งคืน PostResponse ที่ไม่มีข้อมูลในกรณีไม่มี post
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

  static Future<List<Comment>> getCommentByPostId(int postId) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['SERVER_LOCAL_IP']}/comment/$postId');
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('GET request successful');
        print('Response data: ${response.body}');

        final Map<String, dynamic> jsonData = json.decode(response.body);
        List<Comment> comments =
            ResponseCommentByPostId.fromJson(jsonData).data;
        if (comments.isNotEmpty) {
          // สร้าง PostResponse object ที่รวมข้อมูล posts, sumLikes, follow
          return comments;
        } else {
          // ส่งคืน PostResponse ที่ไม่มีข้อมูลในกรณีไม่มี post
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
