
import 'package:oilie_butt_skater_app/models/user_chat.dart';

class Chat {
  final String createAt;
  final String text;
  final int type;
  final String userType;
  final UserChat user;

  Chat({required this.createAt, required this.text, required this.type, required this.userType, required this.user});

  factory Chat.fromMap(Map<dynamic, dynamic> data, String userType, UserChat user) {
    return Chat(
      createAt: data['create_at'],
      text: data['text'],
      type: data['type'],
      userType: userType,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'create_at': createAt,
      'text': text,
      'type': type,
      'user_type': userType,
      'user': user,
    };
  }
}