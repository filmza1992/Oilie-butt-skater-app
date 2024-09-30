import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/chat_room_detail.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/pages/chat_message.dart';

class RequestRoomPage extends StatefulWidget {
  const RequestRoomPage({super.key, required this.fetchChatRoom});

  final Function fetchChatRoom;
  @override
  State<RequestRoomPage> createState() => _RequestRoomPageState();
}

class _RequestRoomPageState extends State<RequestRoomPage> {
  bool isLoading = true;
  ValueNotifier<List<ChatRoom>> requestRooms =
      ValueNotifier<List<ChatRoom>>([]);
  TextEditingController searchController = TextEditingController();
  UserController userController = Get.find<UserController>();
  StreamSubscription? chatRoomsSubscription;

  void updateMessage(List<ChatRoom> data, List<ChatRoom> requestData) {
    if (mounted) {
      // Check if the new messages are different from the current messages
      setState(() {
        requestRooms.value = requestData;
      });
    }
  }

  void setLoading() {
    isLoading = false;
  }

  void setSubscription(value) {
    chatRoomsSubscription = value;
  }

  void fetchChatRooms() async {
    try {
      final fetchedChatRooms = await ApiRoom.getChatRooms(
          userController.user.value,
          updateMessage,
          setLoading,
          setSubscription,
          "request room");
      setState(() {
        requestRooms.value = fetchedChatRooms['requestRooms']!;
        print("requestRooms : " + requestRooms.value.toString());
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
    // TODO: implement initState
    super.initState();

    fetchChatRooms();
  }

  @override
  void dispose() {
    chatRoomsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            chatRoomsSubscription?.cancel();
            widget.fetchChatRoom();
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : requestRooms.value.isEmpty
              ? const Center(
                  child: TextCustom(
                    text: "ไม่มีคำขอส่งข้อความ",
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                )
              : ValueListenableBuilder(
                  valueListenable: requestRooms,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: TextCustom(
                            text: "คำขอ",
                            size: 30,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              TextCustom(
                                text: 'ข้อความ',
                                size: 16,
                                color: AppColors.textColor,
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: ListView.builder(
                              itemCount: requestRooms.value.length,
                              itemBuilder: (context, index) {
                                final chatRoom = requestRooms.value[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(ChatMessagePage(
                                        roomId: chatRoom.chatRoomId,
                                        users: chatRoom.users,
                                        fetchChatRoom: fetchChatRooms));
                                    chatRoomsSubscription?.cancel();
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 0),
                                    child: ChatRoomDetail(
                                        chatRoom: chatRoom,
                                        user: userController.user.value,
                                        searchController: searchController),
                                  ),
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
