import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_chat.dart';
import 'package:oilie_butt_skater_app/api/api_follow.dart';
import 'package:oilie_butt_skater_app/api/api_profile.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/profile_image.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/chat_message.dart';

class TargetProfilePage extends StatefulWidget {
  const TargetProfilePage({super.key, required this.user});

  final User user;
  @override
  State<TargetProfilePage> createState() => _TargetProfilePageState();
}

class _TargetProfilePageState extends State<TargetProfilePage> {
  final UserController userController = Get.find<UserController>();

  dynamic user;
  ChatRoom chatRoom = ChatRoom("", "", "", "", "", "", "");

  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);
  String sumLikes = "0";
  String follower = "0";

  bool isFollower = false;

  void fetchPosts() async {
    try {
      final fetchedProfile = await ApiProfile.getAllPost(widget.user.userId);
      setState(() {
        posts.value = fetchedProfile.posts;
        sumLikes = fetchedProfile.sumLikes.toString();
        follower = fetchedProfile.follow.toString();
      });
    } catch (e) {
      print('Error fetching profile post: $e');
    }
  }

  Future<void> fetchCheckFollower() async {
    final response =
        await ApiFollow.checkFollower(user.userId, widget.user.userId);
    setState(() {
      isFollower = response;
    });
  }

  Future<void> fetchRoomMessage() async {
    final response =
        await ApiRoom.getChatRoomsWithUser(user.userId, widget.user.userId);
    setState(() {
      chatRoom = response;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    user = userController.user.value;
    super.initState();
    fetchPosts();
    fetchCheckFollower();
    fetchRoomMessage();
  }

  Future<void> followUser() async {
    try {
      if (isFollower) {
        setState(() {
          isFollower = !isFollower;
        });
        await ApiFollow.unfollowUser(user.userId, widget.user.userId);
      } else {
        setState(() {
          isFollower = !isFollower;
        });
        await ApiFollow.followUser(user.userId, widget.user.userId);
      }
    } catch (e) {
      print('Error follow profile : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
        ),
        body: ValueListenableBuilder(
            valueListenable: posts,
            builder: (context, value, child) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        ProfileImagePage(user: widget.user),
                        const SizedBox(height: 20.0),
                        TextCustom(
                          size: 22,
                          text: widget.user.username,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                TextCustom(
                                  size: 17,
                                  text: follower,
                                  color: AppColors.primaryColor,
                                ),
                                const TextCustom(
                                  size: 17,
                                  text: "ผู้ติดตาม",
                                  color: AppColors.textColor,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TextCustom(
                                  size: 17,
                                  text: sumLikes,
                                  color: AppColors.primaryColor,
                                ),
                                const TextCustom(
                                  size: 17,
                                  text: "ถูกใจ",
                                  color: AppColors.textColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isFollower) ...[
                              Expanded(
                                child: ButtonCustom(
                                  text: "เลิกติดตาม",
                                  onPressed: followUser,
                                  minWidth: 100,
                                  height: 30,
                                  type: 'Text',
                                  backgroundColor:
                                      Color.fromARGB(255, 29, 28, 28),
                                ),
                              ),
                            ] else ...[
                              Expanded(
                                child: ButtonCustom(
                                    text: "ติดตาม",
                                    onPressed: followUser,
                                    minWidth: 100,
                                    height: 30,
                                    type: 'Elevated'),
                              ),
                            ],
                            const SizedBox(width: 10),
                            Expanded(
                              child: ButtonCustom(
                                  text: "ส่งข้อความ",
                                  onPressed: () {
                                    Get.to(ChatMessagePage(
                                        roomId: chatRoom.chatRoomId,
                                        users: chatRoom.users));
                                  },
                                  minWidth: 100,
                                  height: 30,
                                  type: 'Elevated'),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 57, 57, 57),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final post = value[index];
                        return Image.network(
                          post.content,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ],
              );
            }));
  }
}
