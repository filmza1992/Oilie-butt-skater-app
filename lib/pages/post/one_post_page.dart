import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
      ),
      body: ValueListenableBuilder(
          valueListenable: posts,
          builder: (context, value, child) {
            return Center(
              child: ListView.builder(
                controller: _scrollController, // เชื่อมต่อกับ ScrollController
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
                    updateStatus: (int status, int likes, int dislikes) {
                      setState(() {
                        post.status = status;
                        post.likes = likes;
                        post.dislikes = dislikes;
                      });
                    },
                    user: user,
                  );
                },
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
