import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_chat_room.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';
import 'package:oilie_butt_skater_app/pages/chat/chat_room_message.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';
import 'package:oilie_butt_skater_app/pages/map/map_room_page.dart';
import 'package:oilie_butt_skater_app/pages/room/playyer_page.dart';

class RoomDetailPage extends StatefulWidget {
  const RoomDetailPage({super.key, required this.room});

  final Room room;

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  UserController userController = Get.find<UserController>();
  dynamic user;

  @override
  void initState() {
    // TODO: implement initState
    user = userController.user.value;
    super.initState();
  }

  String formatDateInThai(DateTime dateTime) {
    // List ของชื่อเดือนภาษาไทย
    List<String> monthsInThai = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];

    // วันที่ และ เดือน เป็นภาษาไทย
    String day = dateTime.day.toString();
    String month = monthsInThai[dateTime.month - 1]; // ใช้ index เริ่มจาก 0
    String year = (dateTime.year + 543).toString(); // เพิ่มปีพุทธศักราช

    return month;
  }

  ChatRoom chatRoom = ChatRoom("", "", "", "", "", "", "");

  Future<void> fetchRoomMessage() async {
    final response = await ApiChatRoom.getChatRoomsWithUserRoom(user.userId);
    setState(() {
      chatRoom = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              dynamic u = chatRoom.users.length != 0
                  ? chatRoom.users
                  : [
                      {
                        "user_id": user.userId,
                        "image_url": user.imageUrl,
                        "username": user.username
                      },
                    ];
              Get.to(ChatRoomMessagePage(
                chatRoomId: chatRoom.chatRoomId,
                users: u,
                updateRoomId: (String value) {
                  chatRoom.chatRoomId = value;
                  print("updateRoomId: $value");
                },
                room: widget.room,
              ));
            },
            icon: SvgPicture.asset(
              'assets/icons/chatbubble-ellipses-outline.svg',
              fit: BoxFit.cover,
              width: 25,
              height: 25,
              color: Colors.white,
            ),
          ),
        ],
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // Icon ปุ่มกลับ
              onPressed: () {
                Get.to(const HomePage()); // กลับไปหน้าก่อนหน้า
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Image.network(
                      widget.room.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextCustom(
                          text: "ชื่อห้อง: ${widget.room.name}",
                          size: 16,
                          color: AppColors.textColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextCustom(
                          text: "ข้อความ: ${widget.room.detail}",
                          size: 13,
                          color: AppColors.textColor,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const TextCustom(
                              text: "เวลา",
                              size: 16,
                              color: AppColors.textColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primaryColor,
                              ),
                              child: TextCustom(
                                text: " ${widget.room.dateTime.hour} ",
                                size: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const TextCustom(
                              text: "นาฬิกา",
                              size: 16,
                              color: AppColors.textColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primaryColor,
                              ),
                              child: TextCustom(
                                text: " ${widget.room.dateTime.minute} ",
                                size: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const TextCustom(
                              text: "นาที",
                              size: 16,
                              color: AppColors.textColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const TextCustom(
                              text: "วันที่",
                              size: 16,
                              color: AppColors.textColor,
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primaryColor,
                              ),
                              child: TextCustom(
                                text: " ${widget.room.dateTime.day} ",
                                size: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primaryColor,
                              ),
                              child: TextCustom(
                                text: formatDateInThai(widget.room.dateTime),
                                size: 13,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primaryColor,
                              ),
                              child: TextCustom(
                                text: " ${widget.room.dateTime.year} ",
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonCustom(
                                  text: "รายชื่อผู้เข้าร่วม",
                                  onPressed: () {
                                    Get.to(
                                      PlayyerPage(
                                        roomId: widget.room.roomId.toString(),
                                      ),
                                    );
                                  },
                                  type: "Outlined"),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonCustom(
                                  text: "ตำแหน่ง",
                                  onPressed: () {
                                    Get.to(MapRoomPage(
                                        latitude: widget.room.latitude,
                                        longitude: widget.room.longitude));
                                  },
                                  type: "Outlined"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonCustom(
                                  text: "ลบห้อง",
                                  onPressed: () {
                                    ApiRoom.deleteRoom(widget.room.roomId);
                                    Get.to(const HomePage());
                                  },
                                  type: "Outlined"),
                            )
                          ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
