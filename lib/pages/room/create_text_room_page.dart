import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/firebase_upload_image_.dart';
import 'package:oilie_butt_skater_app/api/api_chat_room.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/textfield/text_field_custom.dart';
import 'package:oilie_butt_skater_app/components/textfield/text_field_date_room.dart';
import 'package:oilie_butt_skater_app/components/textfield/text_field_time.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';
import 'package:oilie_butt_skater_app/pages/room/room_detail_page.dart';

class CreateTextRoomPage extends StatefulWidget {
  const CreateTextRoomPage({super.key, this.imageFile, this.data});
  final File? imageFile;
  final dynamic data;
  @override
  State<CreateTextRoomPage> createState() => _CreateTextRoomPageState();
}

class _CreateTextRoomPageState extends State<CreateTextRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  TimeOfDay _timeController = TimeOfDay.now();

  UserController userController = Get.find<UserController>();
  dynamic user;

  String combineDateTime(String date, TimeOfDay time) {
    try {
      // Parse the date from the _dateController
      DateTime parsedDate = DateTime.parse(date);
      print(time);
      // Combine the parsed date and the TimeOfDay into a single DateTime
      final combinedDateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        time.hour,
        time.minute,
      );

      // Format the combined DateTime object into ISO8601 string format
      return combinedDateTime.toIso8601String();
    } catch (e) {
      print("Error parsing date and time: $e");
      return ''; // Return an empty string in case of an error
    }
  }

  void updateDateTime(picked) {
    setState(() {
      _timeController = picked;
    });
  }

  void _validateAndSubmit() async {
    print(_timeController);
    print(TimeOfDay.now());
    if (_nameController.text.isEmpty) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณากรอกชื่อห้อง');
      return;
    }
    if (_detailController.text.isEmpty) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณากรอกรายละเอียด');
      return;
    }
    if (_dateController.text.isEmpty) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณาเลือกวันที่');
      return;
    }
    if (_timeController == TimeOfDay.now()) {
      Get.snackbar('เกิดข้อผิดพลาด', 'กรุณาเลือกเวลา');
      return;
    }

    String imageUrl =
        await uploadImageToFirebaseRoom(widget.data['image_file']);
    var data = {
      'user_id': user.userId,
      'name': _nameController.text,
      'detail': _detailController.text,
      'image_url': imageUrl,
      'latitude': widget.data['latitude'],
      'longitude': widget.data['longitude'],
      'date_time': combineDateTime(_dateController.text, _timeController),
      'status': 1,
      'create_at': DateTime.now().toIso8601String(),
    };

    print(data);
    Room room = await ApiRoom.createRoom(data);
    var chatRoomId = await ApiChatRoom.createRoomChatRoom([
      {
        'user_id': user.userId,
        'username': user.username,
        'image_url': user.imageUrl,
      }
    ], 2, room.roomId.toString());

    log(chatRoomId);
    Get.to(RoomDetailPage(
      room: room,
      roomType: "join_room",
      owner: user,
      chatRoomId: chatRoomId,
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    user = userController.user.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          TextCustom(
            size: 17,
            text: 'ห้องใหม่',
            color: Colors.grey,
          ),
          SizedBox(
            width: 20,
          )
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.imageFile != null)
                  Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Image.file(
                        widget.imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const TextCustom(
                            text: "รายละเอียดห้อง",
                            size: 16,
                            color: AppColors.textColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldCustom(
                            hint: 'ชื่อห้อง',
                            controller: _nameController,
                            maxLength: 30,
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldCustom(
                            controller: _detailController,
                            maxLines: 1,
                            hint: 'เขียนรายละเอียดโพสต์...',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const TextCustom(
                            text: "วันเวลาที่เริ่มทำกิจกรรม",
                            size: 16,
                            color: AppColors.textColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldDateRoomCustom(
                            hint: "เลือกวันที่",
                            controller: _dateController,
                            prefixIcon: const Icon(Icons.date_range),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldTimeCustom(
                            controller: _timeController,
                            hint: " เลือกเวลา",
                            prefixIcon: const Icon(Icons.timer_sharp),
                            updateDateTime: updateDateTime,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ButtonCustom(
                          height: 30,
                          text: 'สร้างห้อง',
                          onPressed: _validateAndSubmit,
                          type: 'Elevated',
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
