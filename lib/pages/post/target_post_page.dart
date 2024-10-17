import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';

class TargetPostPage extends StatefulWidget {
  final List<Post> posts; // รายการของโพสต์ทั้งหมด
  final int initialIndex; // index ของโพสต์ที่ถูกกด
  final Function loadMorePosts;

  const TargetPostPage(
      {required this.posts,
      required this.initialIndex,
      super.key,
      required this.loadMorePosts});

  @override
  _TargetPostPageState createState() => _TargetPostPageState();
}

class _TargetPostPageState extends State<TargetPostPage> {
  late ScrollController _scrollController;
  UserController userController = Get.find<UserController>();
  dynamic user;
  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    _scrollController = ScrollController();
    user = userController.user.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
         
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
                updateStatus: (int status, int likes, int dislikes) {
                  setState(() {
                    post.status = status;
                    post.likes = likes;
                    post.dislikes = dislikes;
                    widget.loadMorePosts();
                  });
                },
                user: user,
               
              );
            },
          ),
        ),
  
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}