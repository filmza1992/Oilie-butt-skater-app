import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_chat.dart';
import 'package:oilie_butt_skater_app/components/chat_room_detail.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  UserController userController = Get.find<UserController>();

  List<ChatRoom> filteredChatRooms = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  ValueNotifier<List<ChatRoom>> chatRooms = ValueNotifier<List<ChatRoom>>([]);
  void updateMessage(List<ChatRoom> data) {
    if (mounted) {
      // Check if the new messages are different from the current messages
      setState(() {
        chatRooms.value = 
            data; // Ensure to create a new list to avoid reference issues
        filteredChatRooms = data;
      });
    }
  }

  void fetchChatRooms() async {
    try {
      final fetchedChatRooms =
          await ApiChat.getChatRooms(userController.user.value, updateMessage);
      setState(() {
        chatRooms.value = fetchedChatRooms;
        filteredChatRooms = fetchedChatRooms;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching chat rooms: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterChatRooms(String query) {
    final List<ChatRoom> results = chatRooms.value
        .where((chatRoom) => chatRoom.target['username']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredChatRooms = results;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchChatRooms();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterChatRooms(searchQuery.value);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          : chatRooms.value.isEmpty
              ? const Center(
                  child: TextCustom(
                    text: "No chat rooms available.",
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                )
              : ValueListenableBuilder(
                  valueListenable: chatRooms,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              labelText: 'ค้นหา',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: ListView.builder(
                              itemCount: filteredChatRooms.length,
                              itemBuilder: (context, index) {
                                final chatRoom = filteredChatRooms[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 0),
                                  child: ChatRoomDetail(
                                      chatRoom: chatRoom,
                                      user: userController.user.value,
                                      searchController: searchController),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
