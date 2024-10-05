import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response_room_player.dart';

class PlayyerPage extends StatefulWidget {
  const PlayyerPage({super.key, required this.roomId});

  final String roomId;
  @override
  State<PlayyerPage> createState() => _PlayyerPageState();
}

class _PlayyerPageState extends State<PlayyerPage> {
  late final ScrollController _scrollController = ScrollController();
  UserController userController = Get.find<UserController>();
  dynamic user;
  bool isLoading = false;
  ValueNotifier<List<DataPlayer>> players = ValueNotifier<List<DataPlayer>>([]);

  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    user = userController.user.value;
    fetchPlayers();
  }

  void fetchPlayers() async {
    try {
      final fetchedPlayer = await ApiRoom.getPlayers(widget.roomId);
      setState(() {
        players.value = fetchedPlayer;
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
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // แสดง loading ขณะโหลดข้อมูล
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
                                color: const Color.fromARGB(255, 98, 98, 98),
                                width: 2,
                              ),
                            ),
                            child: const TextCustom(
                              text: "รายชื่อผ้เล่น",
                              size: 18,
                              color: AppColors.textColor,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: players,
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
                              final player = value[index];
                              return Card(
                                color: AppColors.backgroundColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.backgroundColor,
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 98, 98, 98),
                                      width: 2,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: player.imageUrl != ""
                                          ? NetworkImage(player.imageUrl)
                                          : const NetworkImage(
                                              'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                                      radius: 19,
                                    ),
                                    title: TextCustom(
                                      text: player.username,
                                      size: 15,
                                      color: AppColors.primaryColor,
                                    ),
                                    trailing: TextCustom(
                                      text: "No.${index + 1}",
                                      size: 15,
                                      color: AppColors.primaryColor,
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
    );
  }
}
