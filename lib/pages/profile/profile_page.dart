import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_profile.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/post_empty.dart';
import 'package:oilie_butt_skater_app/components/profile_image.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/edit/edit_profile.dart';
import 'package:oilie_butt_skater_app/pages/post/user_post_page.dart';
import 'package:oilie_butt_skater_app/pages/setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.loadMorePosts,
  });

  final Function loadMorePosts;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  dynamic user;
  String sumLikes = "0";
  String follower = "0";
  final UserController userController = Get.find<UserController>();
  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);
  bool isLoading = true;

  void fetchPosts() async {
    print('initState');
    try {
      final fetchedProfile =
          await ApiProfile.getAllPost(userController.user.value.userId);
      setState(() {
        posts.value = fetchedProfile.posts;
        sumLikes = fetchedProfile.sumLikes.toString();
        follower = fetchedProfile.follow.toString();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching profile post: $e');
    }
  }

  void updateProfile() {
    setState(() {
      user = userController.user.value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    user = userController.user.value;
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(const SettingPage());
            },
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: posts,
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. โปรไฟล์ของ User ด้านบน
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      ProfileImagePage(user: user),
                      const SizedBox(height: 20.0),
                      TextCustom(
                        size: 20,
                        text: user.username,
                        color: AppColors.textColor,
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonCustom(
                              text: "แก้ไขโปรไฟล์",
                              onPressed: () {
                                Get.to(EditProfilePage(
                                  updateProfile: updateProfile,
                                ));
                              },
                              type: 'Elevated',
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 158, 158, 158),
                      ),
                    ],
                  ),
                ),

                // 2. ส่วน GridView ด้านล่างโปรไฟล์
                isLoading
                    ? Center(
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 150),
                            child:
                                const CircularProgressIndicator()), // แสดง loading ขณะโหลดข้อมูล
                      )
                    : posts.value.isEmpty
                        ? const PostEmpty()
                        : GridView.builder(
                            shrinkWrap: true, // ทำให้ GridView ขยายตามเนื้อหา
                            physics:
                                const NeverScrollableScrollPhysics(), // ปิดการเลื่อนในตัว GridView
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
                              return InkWell(
                                onTap: () {
                                  // เมื่อกดที่รูป จะนำไปยังหน้าถัดไปพร้อมกับส่ง index และ list ของ posts
                                  Get.to(
                                    UserPostPage(
                                      posts: value,
                                      initialIndex: index,
                                      loadMorePosts: widget.loadMorePosts,
                                    ),
                                  );
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(post.content[0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
