import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/firebase_upload_image_.dart';
import 'package:oilie_butt_skater_app/api/api_chat.dart'; // Import your API file
import 'package:oilie_butt_skater_app/api/api_chat_room.dart';
import 'package:oilie_butt_skater_app/components/message.dart';
import 'package:oilie_butt_skater_app/components/photo_gallery.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_model.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';
import 'package:photo_manager/photo_manager.dart';

class ChatRoomMessagePage extends StatefulWidget {
  const ChatRoomMessagePage(
      {super.key,
      required this.chatRoomId,
      required this.users,
      this.updateRoomId,
      this.fetchChatRoom,
      required this.room});

  final String chatRoomId;
  final Room room;
  final dynamic users;
  final Function? fetchChatRoom;
  final Function(String value)? updateRoomId;

  @override
  State<ChatRoomMessagePage> createState() => _ChatRoomMessagePageState();
}

class _ChatRoomMessagePageState extends State<ChatRoomMessagePage> {
  UserController userController = Get.find<UserController>();
  List<Chat> messages = [];

  final TextEditingController _messageController = TextEditingController();

  String targetImage = "";
  String defaultRoomId = "";
  StreamSubscription? messagesSubscription;
  String isPrivateChat() {
    bool isPrivate = false;
    if (widget.users.length == 2) {
      isPrivate = true;
    }

    String roomName = "";
    if (isPrivate) {
      dynamic user = widget.users
          .where((item) => item['user_id'] != userController.user.value.userId)
          .first;
      roomName = user['username'];
      setState(() {
        targetImage = user['image_url'];
      });
    } else {
      roomName = widget.room.name;
    }
    return roomName;
  }

  late ValueNotifier<List<Chat>> messagesNotifier =
      ValueNotifier<List<Chat>>([]);

  void updateMessage(List<Chat> messages) {
    if (mounted) {
      // Check if the new messages are different from the current messages
      setState(() {
        messagesNotifier.value = List.from(
            messages); // Ensure to create a new list to avoid reference issues
        print(messagesNotifier.value);
      });
    }
  }

  void setSubscription(value) {
    messagesSubscription = value;
  }

  void fetchMessages(String roomId, String userId) async {
    try {
      if (roomId != "") {
        await ApiChat.getMessages(
            roomId, userId, updateMessage, setSubscription);
        print(messagesNotifier.value);
      } else {
        String newId = await ApiChatRoom.createRoomChatRoom(
            widget.users, 2, widget.room.roomId.toString());
        setState(() {
          defaultRoomId = newId;
          if (widget.updateRoomId != null) {
            widget.updateRoomId!(defaultRoomId);
          }
        });
        print("roomId: $newId");
        await ApiChat.getMessages(
            newId, userId, updateMessage, setSubscription);
        print(messagesNotifier.value);
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  List<AssetEntity> images = [];

  Future<void> _fetchImages() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    PhotoManager.setIgnorePermissionCheck(true);

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

    List<AssetEntity> photos =
        await albums[0].getAssetListPaged(page: 0, size: 100);

    setState(() {
      images = photos;
    });
  }

  void onImageSelected(AssetEntity image) async {
    File? imageFile = await image.file;
    if (imageFile != null) {
      String downloadUrl = await uploadImageToFirebaseMessage(imageFile);
      if (downloadUrl.isNotEmpty) {
        sendImageMessage(downloadUrl);
        await ApiChat.sendMessageImage(
            defaultRoomId, userController.user.value.userId, downloadUrl);
      }
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // กำหนดสัดส่วนความสูงของหน้าจอ
          child: PhotoGallery(
            images: images,
            onImageSelected: (selectedImage) {
              // จัดการรูปภาพที่เลือกแล้ว
              onImageSelected(selectedImage);
              Navigator.pop(context);
            },
            isShowButton: true,
          ),
        );
      },
    ).then((selectedImage) {
      if (selectedImage != null) {
        // จัดการรูปภาพที่เลือกแล้ว
        // sendImageMessage(selectedImage);
      }
    });
  }

  // Function to send a messagehi
  void sendMessage(String messageText) async {
    try {
      // Assuming you have a method in ApiChat to send messages
      await ApiChat.sendMessageText(
          defaultRoomId, userController.user.value.userId, messageText);

      // Clear the text field after sending
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      // Handle error as needed
    }
  }

  @override
  void initState() {
    defaultRoomId = widget.chatRoomId;
    super.initState();
    fetchMessages(defaultRoomId, userController.user.value.userId);
    _fetchImages();
  }

  @override
  void dispose() {
    messagesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print(messagesNotifier.value);
            if (messagesNotifier.value.isEmpty) {
              setState(() {
                if (widget.updateRoomId != null) {
                  ApiChatRoom.deleteRoom(defaultRoomId, widget.users);
                  widget.updateRoomId!("");
                }
              });
            }
            if (widget.fetchChatRoom != null) {
              widget.fetchChatRoom!();
            }
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  text: isPrivateChat(),
                  size: 15,
                  color: AppColors.textColor,
                  isBold: false,
                ),
              ],
            ),
          ],
        ),
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
                padding: const EdgeInsets.all(8),
                height: 60,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        _showImagePicker(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 20), // Adjust the padding here

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        // Implement sending message logic
                        // onChanged: (value) { ... },
                        // onSubmitted: (value) { ... },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
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
