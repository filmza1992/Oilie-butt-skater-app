import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/models/chat.dart';
import 'package:oilie_butt_skater_app/models/user_chat.dart';

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
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.messages.length,
      reverse: true, // Start list from bottom
      itemBuilder: (BuildContext context, int index) {
        final message = widget.messages[index];
        final String messageText = message.text ?? '';
        final String messageType =
            message.type == 1 ? 'Text' : 'Image'; // Example type handling

        final UserChat? userData = message.user;
        final String userDisplayName = userData?.username ?? 'Unknown';
        final String userAvatarUrl = userData?.imageUrl ?? '';

        final String messageTime = message.createAt ?? '';

        final messageAlignment = message.userType == 'sender'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start;

        final bgColor = message.userType == 'sender'
            ? AppColors.primaryColor
            : Colors.grey[300];

        final textColor =
            message.userType == 'sender' ? Colors.black : Colors.black;

        return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: messageAlignment,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      messageType == 'Text'
                          ? Text(
                              messageText,
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            )
                          : Image.network(
                              messageText, // Assuming messageText is URL for image
                              width: 200,
                              height: 200,
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
