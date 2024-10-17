import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/room_has_user.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/map/map_room_page.dart';
import 'package:oilie_butt_skater_app/pages/room/room_detail_history_page.dart';

class ButtonDialogHistory extends StatefulWidget {
  const ButtonDialogHistory({
    super.key,
    required this.room,
    required this.type,
  });
  final RoomUser room;
  final String type;

  @override
  State<ButtonDialogHistory> createState() => _ButtonDialogState();
}

class _ButtonDialogState extends State<ButtonDialogHistory> {
  UserController userController = Get.find<UserController>();

  ValueNotifier<User> user = ValueNotifier<User>(User(
      userId: "userId",
      username: "username",
      imageUrl: "imageUrl",
      email: "email",
      password: "password",
      birthDay: "birthDay",
      createAt: "createAt"));

  // ฟังก์ชันสำหรับเข้าห้อง
  Future<void> _enterRoom(RoomUser room, User user, User owner) async {
    Get.to(RoomDetailHistoryPage(room: room, owner: owner));
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

  void _showRoomDetailsDialog(RoomUser room, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black, // สีพื้นหลังของ dialog
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextCustom(
                text: "ห้อง",
                size: 18,
                color: AppColors.textColor,
              ),
              IconButton(
                  onPressed: () {
                    Get.to(MapRoomPage(
                        latitude: room.latitude, longitude: room.longitude));
                  },
                  icon: const Icon(Icons.location_on_outlined))
            ],
          ), //
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.imageUrl != ""
                        ? NetworkImage(user.imageUrl)
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
                room.imageUrl.isNotEmpty
                    ? Image.network(room.imageUrl)
                    : const Placeholder(fallbackHeight: 150),
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
                  text: widget.room.detail,
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const TextCustom(
                text: "ปิด",
                color: Colors.white,
                size: 13,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
              },
            ),
            TextButton(
              child: const TextCustom(
                text: "รายละเอียดย้อนหลัง",
                color: AppColors.primaryColor,
                size: 13,
              ),
              onPressed: () {
                // เพิ่มฟังก์ชันที่ต้องการทำเมื่อเข้าห้อง
                Navigator.of(context).pop(); // ปิด dialog
                _enterRoom(room, userController.user.value,
                    user); // เรียกใช้ฟังก์ชันเข้าห้อง
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("button dialog history");
    user.value.imageUrl = widget.room.userImageUrl;
    user.value.username = widget.room.username;
    print(user.value.imageUrl);
    print(user.value.username);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: user,
        builder: (context, value, child) {
          return SizedBox(
            width: 50,
            height: 25, // ปรับความสูงของปุ่ม
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // สีพื้นหลัง
                borderRadius: BorderRadius.circular(10), // มุมกลม
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // สีข้อความ
                  padding: EdgeInsets.zero, // ปรับให้ไม่มี padding
                ),
                onPressed: () {
                  _showRoomDetailsDialog(widget.room, user.value);
                },
                child: const TextCustom(
                  text: "ดู",
                  size: 11,
                ),
              ),
            ),
          );
        });
  }
}
