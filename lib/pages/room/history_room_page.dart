import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/subString.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/button_dialog_history.dart';
import 'package:oilie_butt_skater_app/components/room_empty.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/room_has_user.dart';

class HistoryRoomPage extends StatefulWidget {
  const HistoryRoomPage({super.key});

  @override
  State<HistoryRoomPage> createState() => _HistoryRoomPageState();
}

class _HistoryRoomPageState extends State<HistoryRoomPage> {
  late final ScrollController _scrollController = ScrollController();
  UserController userController = Get.find<UserController>();
  dynamic user;
  bool isLoading = true;
  ValueNotifier<List<RoomUser>> joinRooms = ValueNotifier<List<RoomUser>>([]);
  ValueNotifier<List<RoomUser>> createRooms = ValueNotifier<List<RoomUser>>([]);
  ValueNotifier<List<RoomUser>> exitedRooms = ValueNotifier<List<RoomUser>>([]);

  ValueNotifier<List<RoomUser>> rooms = ValueNotifier<List<RoomUser>>([]);

  String selectedRoomType = 'joined';

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
    String month = dateTime.month.toString(); // ใช้ index เริ่มจาก 0
    String year = (dateTime.year + 543).toString(); // เพิ่มปีพุทธศักราช

    return "$day/$month/$year";
  }

  void fetchRooms() async {
    try {
      final fetchedRoom = await ApiRoom.getHistoryRoom(user.userId);
      setState(() {
        rooms.value = fetchedRoom.joinedRooms;
        joinRooms.value = fetchedRoom.joinedRooms;
        createRooms.value = fetchedRoom.createdRooms;
        exitedRooms.value = fetchedRoom.exitedRooms;
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
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
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
                    text: "ประวัติการเข้าร่วม",
                    size: 18,
                    color: AppColors.textColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: DropdownButton<String>(
                  value: selectedRoomType,
                  underline: const SizedBox(),
                  dropdownColor: AppColors.primaryColor,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  items: const [
                    DropdownMenuItem(
                      value: 'joined',
                      child: TextCustom(
                        text: 'ห้องที่เข้าร่วม',
                        size: 15,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'exit',
                      child: TextCustom(
                        text: 'ห้องที่ออก',
                        size: 15,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'created',
                      child: TextCustom(
                        text: 'ห้องที่เคยสร้าง',
                        size: 15,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRoomType = value!;
                      if (selectedRoomType == 'joined') {
                        rooms.value = joinRooms.value;
                      } else if (selectedRoomType == 'exit') {
                        rooms.value = exitedRooms.value;
                      } else {
                        rooms.value = createRooms.value;
                      }
                    });
                  },
                ),
              ),
            ],
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
                                      borderRadius: BorderRadius.circular(10),
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
                                      trailing: ButtonDialogHistory(
                                        key: ValueKey(room.roomId),
                                        room: room,
                                        type: 'join',
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
    );
  }
}
