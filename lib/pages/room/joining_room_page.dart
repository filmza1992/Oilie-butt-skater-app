import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:oilie_butt_skater_app/pages/map/map_page.dart';

class JoiningRoomPage extends StatefulWidget {
  const JoiningRoomPage({super.key});

  @override
  State<JoiningRoomPage> createState() => _JoiningRoomPageState();
}

class _JoiningRoomPageState extends State<JoiningRoomPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController();
  UserController userController = Get.find<UserController>();
  dynamic user;
  bool isLoading = true;
  ValueNotifier<List<Room>> joinRooms = ValueNotifier<List<Room>>([]);
  ValueNotifier<List<Room>> createRooms = ValueNotifier<List<Room>>([]);

  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    user = userController.user.value;
    _tabController = TabController(length: 2, vsync: this);
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
      // ตรวจสอบตำแหน่งก่อนที่จะดึงข้อมูลห้อง
      final position = await Location.determinePosition();

      // ถ้าผู้ใช้ให้ permission และได้ตำแหน่ง
      double latitude = position?.latitude ?? 0.0;
      double longitude = position?.longitude ?? 0.0;

      // ยิง API พร้อมกับตำแหน่งที่ได้ (หรือส่งค่า 0.0 ถ้าไม่ได้อนุญาต)
      final fetchedRoom =
          await ApiRoom.getJoinRoom(user.userId, latitude, longitude);

      setState(() {
        joinRooms.value = fetchedRoom.joinedRooms;
        createRooms.value = fetchedRoom.createdRooms;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching rooms: $e');
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
              text: "ห้องที่กำลังเข้าร่วม",
              size: 18,
              color: AppColors.primaryColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 10,
            )
          ],
          bottom: TabBar(
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.textColor,
            unselectedLabelColor: AppColors.textColor,
            controller: _tabController,
            tabs: const [
              Tab(
                  child: TextCustom(
                text: "ห้องที่สร้าง",
                size: 16,
                color: AppColors.textColor,
              )),
              Tab(
                  child: TextCustom(
                text: "ห้องคนอื่น",
                size: 16,
                color: AppColors.textColor,
              )),
            ],
          ),
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
        body: TabBarView(
          controller: _tabController,
          children: [
            Center(
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
                              text: "ห้องที่สร้าง",
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
                      : createRooms.value.isEmpty
                          ? const RoomEmpty()
                          : ValueListenableBuilder(
                              valueListenable: createRooms,
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
                                              color: getRoomCardColor(
                                                  room.dateTime),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 98, 98, 98),
                                                width: 2,
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: room
                                                            .imageUrl !=
                                                        ""
                                                    ? NetworkImage(
                                                        room.imageUrl)
                                                    : const NetworkImage(
                                                        'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                                                radius: 15,
                                              ),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextCustom(
                                                    text: SubString
                                                        .truncateString(
                                                            room.name, 16),
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
                                                      color:
                                                          AppColors.textColor),
                                                ],
                                              ),
                                              trailing: ButtonDialog(
                                                room: room,
                                                type: 'detail',
                                                roomType: "join_room",
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
            isLoading
                ? Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 150),
                        child:
                            const CircularProgressIndicator()), // แสดง loading ขณะโหลดข้อมูล
                  )
                : Center(
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
                                      color:
                                          const Color.fromARGB(255, 98, 98, 98),
                                      width: 2,
                                    ),
                                  ),
                                  child: const TextCustom(
                                    text: "ห้องคนอื่น",
                                    size: 18,
                                    color: AppColors.textColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        joinRooms.value.isEmpty
                            ? const RoomEmpty()
                            : ValueListenableBuilder(
                                valueListenable: joinRooms,
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
                                                color: getRoomCardColor(
                                                    room.dateTime),
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 98, 98, 98),
                                                  width: 2,
                                                ),
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: room
                                                              .imageUrl !=
                                                          ""
                                                      ? NetworkImage(
                                                          room.imageUrl)
                                                      : const NetworkImage(
                                                          'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                                                  radius: 15,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TextCustom(
                                                      text: SubString
                                                          .truncateString(
                                                              room.name, 12),
                                                      size: 11.5,
                                                      color:
                                                          AppColors.textColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    TextCustom(
                                                        text: formatDateInThai(
                                                            room.dateTime),
                                                        size: 11.5,
                                                        color: AppColors
                                                            .textColor),
                                                  ],
                                                ),
                                                trailing: ButtonDialog(
                                                  room: room,
                                                  type: 'detail',
                                                  roomType: "join_room",
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the post creation screen
            Get.to(const MapPage());
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/skateboarding.svg',
                width: 40, // ปรับขนาดไอคอน
                height: 40, // ปรับขนาดไอคอน
              ),
            ),
          ),
        ),
      ),
    );
  }
}
