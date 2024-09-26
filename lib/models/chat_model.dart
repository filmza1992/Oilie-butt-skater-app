import 'package:oilie_butt_skater_app/models/user_chat_model.dart';

class Chat {
  final String createAt;
  final String? text;
  final String? url;
  final int type;
  final String userType;
  final UserChat user;

  Chat(
      {this.url,
      this.text,
      required this.createAt,
      required this.type,
      required this.userType,
      required this.user});

  factory Chat.fromMap(
      Map<dynamic, dynamic> data, String userType, UserChat user) {
    if (data['type'] == 1) {
      return Chat(
        createAt: data['create_at'],
        text: data['text'],
        type: data['type'],
        userType: userType,
        user: user,
      );
    } else if (data['type'] == 2) {
      return Chat(
        createAt: data['create_at'],
        url: data['url'],
        type: data['type'],
        userType: userType,
        user: user,
      );
    }
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
