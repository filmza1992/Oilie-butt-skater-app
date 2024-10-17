import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/room_has_user.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/map/map_room_page.dart';
import 'package:oilie_butt_skater_app/pages/room/playyer_page.dart';

class RoomDetailHistoryPage extends StatefulWidget {
  const RoomDetailHistoryPage({
    super.key,
    required this.room,
    required this.owner,
  });

  final RoomUser room;
  final User owner;
  @override
  State<RoomDetailHistoryPage> createState() => _RoomDetailHistoryPageState();
}

class _RoomDetailHistoryPageState extends State<RoomDetailHistoryPage> {
  UserController userController = Get.find<UserController>();
  dynamic user;

  bool isSupervisor = false;
  @override
  void initState() {
    // TODO: implement initState
    user = userController.user.value;
    checkUser();
    super.initState();
  }

  void checkUser() {
    if (user.userId == widget.room.userId) {
      setState(() {
        isSupervisor = true;
      });
      print("this is หัวหน้าห้อง");
    } else {
      setState(() {
        isSupervisor = false;
      });
      print("ไม่ใช่หัวหน้าห้อง");
    }
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle your back button behavior here

        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white), // Icon ปุ่มกลับ
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: widget.owner.imageUrl != ""
                                ? NetworkImage(widget.owner.imageUrl)
                                : const NetworkImage(
                                    'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                            radius: 15,
                          ),
                          title: TextCustom(
                            text: user.username,
                            size: 15,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                    text: "วันที่",
                                    size: 13,
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
                                      text:
                                          " ${widget.room.dateTime.day} ${formatDateInThai(widget.room.dateTime)} ${widget.room.dateTime.year} ",
                                      size: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  const TextCustom(
                                    text: "เวลา",
                                    size: 13,
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
                                      text:
                                          " ${widget.room.dateTime.hour} : ${widget.room.dateTime.minute} ",
                                      size: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const TextCustom(
                                    text: "นาที",
                                    size: 13,
                                    color: AppColors.textColor,
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
                                              roomId:
                                                  widget.room.roomId.toString(),
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
                                        text: "ตำแหน่งสถานที่",
                                        onPressed: () {
                                          Get.to(MapRoomPage(
                                              latitude: widget.room.latitude,
                                              longitude:
                                                  widget.room.longitude));
                                        },
                                        type: "Outlined"),
                                  ),
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
      ),
    );
  }
}
