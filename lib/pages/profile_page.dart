import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_profile.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/profile_image.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = Get.find<UserController>();
  dynamic user;
  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);

  void fetchPosts() async {
    print('initState');
    try {
      final fetchedPosts =
          await ApiProfile.getAllPost(userController.user.value.id);
      setState(() {
        posts.value = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
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
                        ProfileImagePage(user: user),
                        const SizedBox(height: 20.0),
                        TextCustom(
                          size: 20,
                          text: user.username,
                          color: AppColors.textColor,
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                TextCustom(
                                  size: 17,
                                  text: "0",
                                  color: AppColors.primaryColor,
                                ),
                                TextCustom(
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
                                  text: "0",
                                  color: AppColors.primaryColor,
                                ),
                                TextCustom(
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
                          children: [
                            Expanded(
                                child: ButtonCustom(
                                    text: "แก้ไขโปรไฟล์", onPressed: () {})),
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
