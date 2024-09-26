import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/chat_message.dart';
import 'package:oilie_butt_skater_app/pages/profile/profile_page.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail(
      {super.key,
      required this.user,
     });

  final User user;
 
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  String isPrivateChat(dynamic users) {
    bool isPrivate = false;
    if (users.length == 2) {
      isPrivate = true;
    }

    String roomName = "";
    if (isPrivate) {
      dynamic u =
          users.where((item) => item['user_id'] != widget.user.userId).first;
      roomName = u['username'];
    }
    return roomName;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.user.imageUrl != null
                  ? NetworkImage(widget.user.imageUrl)
                  : const NetworkImage(
                      'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  text: widget.user.username,
                  size: 20,
                  color: AppColors.textColor,
                  isBold: false,
                ),
              
              ],
            ),
          ],
        ),
 
    );
    // Add more details as needed
  }
}
