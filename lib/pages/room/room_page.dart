import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/button_image.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/pages/map/map_page.dart';
import 'package:oilie_butt_skater_app/pages/room/public_room_page.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void navigateToFriendRoom() {
    Get.to(const MapPage());
  }

  void navigateToJoinRoom() {}

  void navigateToPublicRoom() {
    Get.to(const PublicRoomPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const TextCustom(
          text: "Skateboard Room",
          size: 27,
          color: AppColors.primaryColor,
        ),
        backgroundColor: AppColors.backgroundColor,
        bottom: TabBar(
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.textColor,
          unselectedLabelColor: AppColors.textColor,
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.meeting_room_outlined)),
            Tab(icon: Icon(Icons.history_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // หน้าแรกที่แสดงข้อมูลห้อง
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonImage(
                      width: 150,
                      image: 'assets/images/friend_room.png',
                      text: "ห้องเพื่อน",
                      textColor: AppColors.primaryColor,
                      onPressd: navigateToFriendRoom,
                    ),
                    ButtonImage(
                      width: 150,
                      image: 'assets/images/join_room.png',
                      text: "ห้องที่กำลังเข้าร่วม",
                      textColor: const Color.fromARGB(255, 119, 118, 118),
                      onPressd: navigateToJoinRoom,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonImage(
                  onPressd: navigateToPublicRoom,
                  image: 'assets/images/public_room.png',
                  text: "ห้องทั่วไป",
                  textColor: AppColors.textColor,
                ),
              ],
            ),
          ),

          // หน้าที่สอง ประวัติการเข้าใช้
          const Center(
            child: Text(
              "History Page", // ข้อความสำหรับแท็บที่สอง
              style: TextStyle(
                fontSize: 24,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
