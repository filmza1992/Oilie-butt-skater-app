import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';
import 'package:video_player/video_player.dart';

class UserPostPage extends StatefulWidget {
  final List<Post> posts; // รายการของโพสต์ทั้งหมด
  final int initialIndex; // index ของโพสต์ที่ถูกกด
  final Function loadMorePosts;

  const UserPostPage(
      {required this.posts,
      required this.initialIndex,
      super.key,
      required this.loadMorePosts});

  @override
  _UserPostPageState createState() => _UserPostPageState();
}

class _UserPostPageState extends State<UserPostPage> {
  late ScrollController _scrollController;
  UserController userController = Get.find<UserController>();
  dynamic user;
  final List<VideoPlayerController> _activeControllers =
      []; // เก็บ controller ที่เล่นอยู่

  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    _scrollController = ScrollController();
    user = userController.user.value;
  }

  void disposeAllVideos() {
    // หยุดและ dispose controller ทั้งหมดที่เล่นอยู่
    for (var controller in _activeControllers) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
    _activeControllers.clear(); // ล้างรายการ controller
  }

  @override
  void dispose() {
    _scrollController.dispose();
    disposeAllVideos();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("will pop");
        disposeAllVideos();
        Get.to(const HomePage(
          selectedIndex: 4,
        ));

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              disposeAllVideos();
              Get.to(const HomePage(
                selectedIndex: 4,
              ));
            },
          ),
        ),
        body: Center(
          child: ListView.builder(
            controller: _scrollController, // เชื่อมต่อกับ ScrollController
            itemCount: widget.posts.length,
            itemBuilder: (context, index) {
              final post = widget.posts[index];
              return PostComponent(
                key: ValueKey(post),
                userId: post.userId,
                postId: post.postId,
                username: post.username,
                userImage: post.userImage,
                postText: post.title,
                likes: post.likes,
                dislikes: post.dislikes,
                comments: post.comments,
                content: post.content,
                status: post.status,
                type: post.type,
                updateStatus: (int status, int likes, int dislikes) {
                  setState(() {
                    post.status = status;
                    post.likes = likes;
                    post.dislikes = dislikes;
                    widget.loadMorePosts();
                  });
                },
                user: user,
                onVideoStart: (controller) {
                  _activeControllers.add(
                      controller); // เพิ่ม controller ที่กำลังเล่นเข้าไปใน list
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
