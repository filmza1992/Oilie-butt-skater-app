import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/firebase_upload_image_.dart';
import 'package:oilie_butt_skater_app/api/api_chat.dart'; // Import your API file
import 'package:oilie_butt_skater_app/components/message.dart';
import 'package:oilie_butt_skater_app/components/photo_gallery.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ChatMessagePage extends StatefulWidget {
  const ChatMessagePage({
    super.key,
    required this.roomId,
    required this.users,
  });

  final String roomId;
  final dynamic users;

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  UserController userController = Get.find<UserController>();
  List<Chat> messages = [];

  final TextEditingController _messageController = TextEditingController();

  String isPrivateChat() {
    bool isPrivate = false;
    if (widget.users.length == 2) {
      isPrivate = true;
    }

    String roomName = "";
    if (isPrivate) {
      dynamic user = widget.users
          .where((item) => item['user_id'] != userController.user.value.id)
          .first;
      roomName = user['username'];
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
      });
    }
  }

  void fetchMessages(String roomId, String userId) async {
    try {
      await ApiChat.getMessages(roomId, userId, updateMessage);
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
          widget.roomId, userController.user.value.id, downloadUrl);

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
            }, isShowButton: true,
            
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
          widget.roomId, userController.user.value.id, messageText);

      // Clear the text field after sending
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      // Handle error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages(widget.roomId, userController.user.value.id);
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPrivateChat()),
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
