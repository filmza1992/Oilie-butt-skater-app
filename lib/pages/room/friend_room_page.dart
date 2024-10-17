import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/location.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/subString.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/button_dialog.dart';
import 'package:oilie_butt_skater_app/components/room_empty.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';

class FriendRoomPage extends StatefulWidget {
  const FriendRoomPage({super.key});

  @override
  State<FriendRoomPage> createState() => _FriendRoomPageState();
}

class _FriendRoomPageState extends State<FriendRoomPage> {
  late final ScrollController _scrollController = ScrollController();
  UserController userController = Get.find<UserController>();
  dynamic user;
  bool isLoading = false;
  ValueNotifier<List<Room>> rooms = ValueNotifier<List<Room>>([]);

  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    user = userController.user.value;
    fetchRooms();
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

    return "$day/$month/$year";
  }

  Color getRoomCardColor(DateTime roomDateTime) {
    final now = DateTime.now();
    final difference = roomDateTime.difference(now).inDays;

    if (difference < 2) {
      return const Color.fromARGB(
          255, 93, 16, 217); // สีเขียวสว่างสุด (ปลอดภัย)
    } else if (difference <= 4) {
      return const Color.fromARGB(255, 156, 95, 255); // สีเขียวกลาง (ปานกลาง)
    } else {
      return const Color.fromARGB(
          255, 147, 128, 154); // สีเขียวเข้ม (ค่อนข้างอันตราย)
    }
  }

  void fetchRooms() async {
    try {
      final position = await Location.determinePosition();

      // ถ้าผู้ใช้ให้ permission และได้ตำแหน่ง
      double latitude = position?.latitude ?? 0.0;
      double longitude = position?.longitude ?? 0.0;

      final fetchedRoom =
          await ApiRoom.getFriendRoom(user.userId, latitude, longitude);
      setState(() {
        rooms.value = fetchedRoom;
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle your back button behavior here
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(
              selectedIndex: 1,
            ),
          ),
          (Route<dynamic> route) => false, // Clear stack ทั้งหมด
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
          actions: const [
            TextCustom(
              text: "ห้องเพื่อน",
              size: 18,
              color: AppColors.primaryColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 10,
            )
          ],
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white), // Icon ปุ่มกลับ
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(
                        selectedIndex: 1,
                      ),
                    ),
                    (Route<dynamic> route) => false, // Clear stack ทั้งหมด
                  );
                },
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.backgroundColor,
                          border: Border.all(
                            color: const Color.fromARGB(255, 98, 98, 98),
                            width: 2,
                          ),
                        ),
                        child: const TextCustom(
                          text: "รายชื่อห้อง",
                          size: 18,
                          color: AppColors.textColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Center(
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 150),
                          child:
                              const CircularProgressIndicator()), // แสดง loading ขณะโหลดข้อมูล
                    )
                  : rooms.value.isEmpty
                      ? const RoomEmpty()
                      : ValueListenableBuilder(
                          valueListenable: rooms,
                          builder: (context, value, child) {
                            return Expanded(
                              // ใช้ Expanded เพื่อบังคับ ListView ให้มีขนาดที่แน่นอน
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListView.builder(
                                  controller:
                                      _scrollController, // เชื่อมต่อกับ ScrollController
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    final room = value[index];
                                    return Card(
                                      color: AppColors.backgroundColor,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              getRoomCardColor(room.dateTime),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 98, 98, 98),
                                            width: 2,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: room.imageUrl != ""
                                                ? NetworkImage(room.imageUrl)
                                                : const NetworkImage(
                                                    'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                                            radius: 15,
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextCustom(
                                                text: SubString
                                                        .truncateString(
                                                            room.name, 12),
                                                size: 11.5,
                                                color: AppColors.textColor,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextCustom(
                                                  text: formatDateInThai(
                                                      room.dateTime),
                                                  size: 11.5,
                                                  color: AppColors.textColor),
                                            ],
                                          ),
                                          trailing: ButtonDialog(
                                            room: room,
                                            type: 'join',
                                            roomType: 'friend_room',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}