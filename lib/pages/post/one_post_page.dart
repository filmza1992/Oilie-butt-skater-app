import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:video_player/video_player.dart';

class OnePostPage extends StatefulWidget {
  const OnePostPage({super.key, required this.postId});
  final String postId;

  @override
  State<OnePostPage> createState() => _OnePostPageState();
}

class _OnePostPageState extends State<OnePostPage> {
  late ScrollController _scrollController;
  UserController userController = Get.find<UserController>();
  dynamic user;

  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);

 final List<VideoPlayerController> _activeControllers =
      []; 
  Future<void> fetchPost() async {
    // Fetch user ranking
    final result = await ApiPost.getPostWithPostId(widget.postId, user.userId);
    setState(() {
      posts.value = result;
    });
  }

  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    _scrollController = ScrollController();
    user = userController.user.value;
    fetchPost();
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
        Navigator.pop(context);

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
              Navigator.pop(context);
            },
          ),
        ),
        body: ValueListenableBuilder(
            valueListenable: posts,
            builder: (context, value, child) {
              return Center(
                child: ListView.builder(
                  controller:
                      _scrollController, // เชื่อมต่อกับ ScrollController
                  itemCount: posts.value.length,
                  itemBuilder: (context, index) {
                    final post = posts.value[index];
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
              );
            }),
      ),
    );
  }

 
}
