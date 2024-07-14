import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_chat.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_room.dart';
import 'package:oilie_butt_skater_app/pages/chat_message.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  UserController userController = Get.find<UserController>();
  List<ChatRoom> chatRooms = [];
  bool isLoading = true;

  void fetchChatRooms() async {
    try {
      final fetchedChatRooms =
          await ApiChat.getChatRooms(userController.user.value);
        print("get Message");
      setState(() {
        chatRooms = fetchedChatRooms;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching chat rooms: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: TextCustom(
              text: "แชท",
              size: 30,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : chatRooms.isEmpty
              ? const Center(
                  child: TextCustom(
                    text: "No chat rooms available.",
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                )
              : ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    final chatRoom = chatRooms[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: TextCustom(
                          text: 'Chat Room ${chatRoom.chatRoomId}',
                          size: 20,
                          color: AppColors.primaryColor,
                        ),
                        subtitle: TextCustom(
                          text: 'Last updated: ${chatRoom.updateAt}',
                          size: 16,
                          color: AppColors.secondaryColor,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatMessagePage(
                                roomId: chatRoom.chatRoomId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class ChatRoomDetailsPage extends StatelessWidget {
  final Map<String, dynamic> chatRoom;

  const ChatRoomDetailsPage({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room ${chatRoom['room_id']}'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(chatRoom['']),
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: chatRoom['room_name'],
                      size: 20,
                      color: Colors.green,
                      isBold: true,
                    ),
                    TextCustom(
                      text: chatRoom['last_message'],
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Add more details as needed
        ],
      ),
    );
  }
}
