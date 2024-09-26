import 'package:oilie_butt_skater_app/models/user.dart';

class UserChat {
  final String userId;
  final String username;
  final String imageUrl;

  UserChat(
      {required this.userId,
      required this.username,
      required this.imageUrl,
      });

  factory UserChat.fromMap(Map<dynamic, dynamic> data) {
    return UserChat(
     userId: data['user_id'],
     username: data['username'],
     imageUrl: data['image_url']
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'create_at': createAt,
  //     'text': text,
  //     'type': type,
  //     'user_type': userType,
  //     'user': user,
  //   };
  // }
}
