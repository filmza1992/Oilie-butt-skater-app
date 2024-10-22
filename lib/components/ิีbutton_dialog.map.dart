import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/api/api_user.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/room/room_detail_page.dart';

class ButtonDialogMap extends StatefulWidget {
  const ButtonDialogMap(
      {super.key,
      required this.room,
      required this.type,
      required this.roomType});

  final Room room;
  final String type;
  final String roomType;
  @override
  State<ButtonDialogMap> createState() => _ButtonDialogMapState();
}

class _ButtonDialogMapState extends State<ButtonDialogMap> {
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
  Future<void> _enterRoom(Room room, User user, User owner) async {
    if (widget.type == 'join') {
      await ApiRoom.joinRoom(room, user);
    }
    Get.to(RoomDetailPage(
      room: room,
      roomType: widget.roomType,
      owner: owner,
    ));
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

  void _showRoomDetailsDialog(Room room, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black, // สีพื้นหลังของ dialog
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(
                text: "ห้อง",
                size: 18,
                color: AppColors.textColor,
              ),
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
                            " ${widget.room.dateTime.toLocal().hour} : ${widget.room.dateTime.toLocal().minute}",
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
                text: "เข้าร่วมห้อง",
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
    fetchUser();
  }

  void fetchUser() async {
    try {
      final fetchedUser = await ApiUser.getUserById(widget.room.userId);
      setState(() {
        user.value = fetchedUser;
      });
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showRoomDetailsDialog(
          widget.room, user.value), // แสดงตำแหน่งเมื่อคลิกที่ marker
      icon: SvgPicture.asset(
        'assets/icons/marker.svg',
        fit: BoxFit.cover,
        color: AppColors.primaryColor,
      ), // ใช้ icon ของ Google Maps
      iconSize: 60.0, // ปรับขนาด icon ที่นี่
    );
  }
}
