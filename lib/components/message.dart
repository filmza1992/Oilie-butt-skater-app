import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/models/chat_model.dart';
import 'package:oilie_butt_skater_app/models/user_chat_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    required this.messages,
    super.key,
  });

  final List<Chat> messages;
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final ScrollController _scrollController = ScrollController();

  bool isSameUser(int index) {
    if (index == 0) return false;
    return widget.messages[index].user.userId ==
        widget.messages[index - 1].user.userId;
  }

  bool isOneText(int index) {
    bool isOneText = false;
    if (index == widget.messages.length - 1) {
      return false;
    }
    if (widget.messages[index].user.userId !=
        widget.messages[index + 1].user.userId) {
      isOneText = true;
    }
    return isOneText;
  }

  void _launchURL(double latitude, double longitude) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.messages.length,
      reverse: true, // Start list from bottom
      itemBuilder: (BuildContext context, int index) {
        final message = widget.messages[index];
        final String? messageText = message.type == 1
            ? message.text
            : (message.type == 2
                ? message.url
                : '${message.latitude},${message.longitude}');
        final String messageType =
            message.type == 1 ? 'Text' : (message.type == 2 ? 'Image' : 'Map');

        final UserChat userData = message.user;
        final String userDisplayName = userData.username ?? 'Unknown';
        final String userAvatarUrl = userData.imageUrl ?? '';

        final String messageTime = message.createAt ?? '';

        final messageAlignment = message.userType == 'sender'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start;

        Color? bgColor;
        if (messageType == 'Image') {
          bgColor = AppColors.backgroundColor;
        } else {
          bgColor = message.userType == 'sender'
              ? AppColors.primaryColor
              : Colors.grey[300];
        }

        final textColor =
            message.userType == 'sender' ? Colors.black : Colors.black;

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            child: Row(
              mainAxisAlignment: message.userType == 'sender'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.userType == 'receiver' && !isSameUser(index))
                  CircleAvatar(
                    backgroundImage: userAvatarUrl.isNotEmpty
                        ? NetworkImage(userAvatarUrl)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                    maxRadius: 17,
                  ),
                if (message.userType == 'receiver' && isSameUser(index))
                  const SizedBox(width: 43),
                if (message.userType == 'receiver' && !isSameUser(index))
                  const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: messageAlignment,
                    children: [
                      if (message.userType == 'receiver' && isOneText(index))
                        Text(
                          userDisplayName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      if (message.userType == 'receiver' && isOneText(index))
                        const SizedBox(
                          height: 5,
                        ),
                      Container(
                        padding: messageType == 'Text'
                            ? const EdgeInsets.all(12)
                            : const EdgeInsets.all(0),
                        constraints: const BoxConstraints(
                          maxWidth: 200.0, // กำหนดความกว้างขั้นต่ำ
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (messageType == 'Text')
                              Text(
                                messageText!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              )
                            else if (messageType == 'Image')
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 170, // กำหนดความกว้างสูงสุด
                                  maxHeight: 170, // กำหนดความสูงสูงสุด
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(8), // กำหนดขอบมน
                                  child: Image.network(
                                    messageText!, // Assuming messageText is URL for image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else if (messageType == 'Map')
                              GestureDetector(
                                onTap: () {
                                  // แปลงข้อความที่เป็นละติจูดและลองจิจูดจากข้อความ
                                  final coords = messageText!.split(',');
                                  final double latitude =
                                      double.parse(coords[0]);
                                  final double longitude =
                                      double.parse(coords[1]);
                                  _launchURL(latitude, longitude);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(9), // มุมโค้งมน
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.withOpacity(0.2), // เงา
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(
                                            0, 4), // แกน x และ y ของเงา
                                      ),
                                    ],
                                    color: Colors.white, // สีพื้นหลัง
                                  ),
                                  child: Column(
                                    // ใช้ Stack เพื่อให้รูปภาพเต็มกรอบ
                                    children: [
                                      // รูปภาพที่แสดงเต็มกรอบ
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            9), // มุมโค้งมน
                                        child: Image.asset(
                                          'assets/images/google_map.png', // เส้นทางรูปภาพพิน
                                          fit:
                                              BoxFit.cover, // ให้รูปภาพเต็มกรอบ
                                        ),
                                      ),
                                      // ข้อความลิงค์
                                      Container(
                                        color: Colors
                                            .black87, // พื้นหลังของข้อความเพื่อให้มองเห็นได้ชัด
                                        padding: const EdgeInsets.all(8.0),

                                        child: Text(
                                          'https://www.google.co.th/maps/', // ข้อความลิงค์
                                          style: GoogleFonts.kanit(
                                            fontSize: 13, // ขนาดตัวอักษร
                                            color: Colors.white, // สีข้อความ
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          textAlign: TextAlign
                                              .start, // จัดแนวข้อความกลาง
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
