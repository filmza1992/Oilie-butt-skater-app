import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_chat.dart'; // Import your API file
import 'package:oilie_butt_skater_app/components/message.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat.dart';
import 'package:oilie_butt_skater_app/models/user_chat.dart';

class ChatMessagePage extends StatefulWidget {
  const ChatMessagePage({Key? key, required this.roomId});

  final String roomId;

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  UserController userController = Get.find<UserController>();
  List<Chat> messages = [];

  TextEditingController _messageController = TextEditingController();

  late ValueNotifier<List<Chat>> messagesNotifier =
      ValueNotifier<List<Chat>>([]);
  void updateMessage(List<Chat> messages) {
    if (mounted) {
      // Check if the new messages are different from the current messages
      setState(() {
        messagesNotifier.value = List.from(
            messages); // Ensure to create a new list to avoid reference issues
      });
      print("Messages updated");
    }
  }

  void fetchMessages(String roomId, String userId) async {
    try {
      await ApiChat.getMessages(roomId, userId, updateMessage);
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages(widget.roomId, userController.user.value.id);
  }

  // Function to send a messagehi
  void sendMessage(String messageText) async {
    try {
      // Assuming you have a method in ApiChat to send messages
      await ApiChat.sendMessage(
          widget.roomId, userController.user.value.id, messageText);

      // Clear the text field after sending
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room ${widget.roomId}'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: messagesNotifier,
        builder: (context, messages, _) {
          return Column(
            children: [
              Expanded(child: ChatWidget(messages: messages)),
              // Example of chat input field
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        // Implement sending message logic
                        // onChanged: (value) { ... },
                        // onSubmitted: (value) { ... },
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        String messageText = _messageController.text.trim();
                        if (messageText.isNotEmpty) {
                          sendMessage(messageText);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
