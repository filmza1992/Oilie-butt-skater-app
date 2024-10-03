import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/chat/chat_message.dart';

class ChatRoomDetail extends StatefulWidget {
  const ChatRoomDetail(
      {super.key,
      required this.chatRoom,
      required this.user,
      required this.searchController});

  final ChatRoom chatRoom;
  final User user;
  final TextEditingController searchController;

  @override
  State<ChatRoomDetail> createState() => _ChatRoomDetailState();
}

class _ChatRoomDetailState extends State<ChatRoomDetail> {
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
    return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.chatRoom.target['image_url'] != null
                  ? NetworkImage(widget.chatRoom.target['image_url'])
                  : const NetworkImage(
                      'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  text: isPrivateChat(widget.chatRoom.users),
                  size: 20,
                  color: AppColors.primaryColor,
                  isBold: true,
                ),
                TextCustom(
                  text: widget.chatRoom.lastMessage,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
    );
    // Add more details as needed
  }
}
