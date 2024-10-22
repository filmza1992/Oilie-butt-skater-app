import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/post_image_slider.dart';
import 'package:oilie_butt_skater_app/components/profile_post.dart';
import 'package:oilie_butt_skater_app/components/tag_text.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/video_player_widget.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/pages/comment/comment.dart';
import 'package:oilie_butt_skater_app/pages/post/edit_text_post_page.dart';
import 'package:video_player/video_player.dart';

class PostComponent extends StatefulWidget {
  final String userId;
  final int postId;
  final String username;
  final String userImage;
  final String postText;
  final int likes;
  final int dislikes;
  final int comments;
  final List<String> content;
  final int status;
  final Function updateStatus;
  final dynamic user;
  final int type;
  final Function(VideoPlayerController controller) onVideoStart;

  const PostComponent(
      {super.key,
      required this.userId,
      required this.postId,
      required this.username,
      required this.userImage,
      required this.postText,
      required this.likes,
      required this.dislikes,
      required this.comments,
      required this.content,
      required this.status,
      required this.updateStatus,
      required this.user,
      required this.type,
      required this.onVideoStart});

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isCommented = false;
  int likes = 0;
  int dislikes = 0;
  int comments = 0;

  UserController userController = Get.find<UserController>();
  dynamic user;

  VideoPlayerController? _videoController;
  bool _videoDownloadFailed = false;

  void updateCommentCount(int number) {
    if (number != -1) {
      setState(() {
        comments = number;
        print(comments);
      });
    } else {
      setState(() {
        comments++;
        print(comments);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    likes = widget.likes;
    dislikes = widget.dislikes;
    comments = widget.comments;
    if (widget.status == 1) {
      isLiked = true;
    } else if (widget.status == -1) {
      isDisliked = true;
    }
    user = userController.user.value;
    if (widget.type == 2) {
      log(widget.content[0]);
      _initializeVideoPlayer(widget.content[0]); // ใช้ URL สำหรับวิดีโอ
    }
  }

  void _initializeVideoPlayer(String videoUrl) {
    _videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        // ไม่เรียก play() ที่นี่ เพื่อไม่ให้เล่นอัตโนมัติ
        setState(() {
          widget.onVideoStart(
              _videoController!); // ส่ง controller ไปยัง home เพื่อจัดการ
        });
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _videoDownloadFailed = true; // ถ้าวิดีโอโหลดไม่สำเร็จ
          });
        }
      });
  }

  void _onPlayPause() {
    setState(() {
      _videoController!.value.isPlaying
          ? _videoController!.pause()
          : _videoController!.play();
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  bool visible = true;
  double opacity = 1.0; // สถานะความโปร่งใสของ Card

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity, // กำหนดความโปร่งใส
      duration:
          const Duration(milliseconds: 250), // ระยะเวลาที่ใช้ในการแอนิเมชัน
      child: visible
          ? SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfilePost(
                              username: widget.username,
                              userImage: widget.userImage,
                            ),
                            if (user.userId == widget.userId) ...[
                              PopupMenuButton<String>(
                                icon:
                                    const Icon(Icons.more_vert), // ไอคอน 3 จุด
                                onSelected: (value) {
                                  // จัดการตามตัวเลือกที่ผู้ใช้เลือก
                                  if (value == 'edit') {
                                    // ดำเนินการแก้ไขโพสต์
                                    print("แก้ไขโพสต์");
                                    Get.to(EditTextPostPage(
                                      postId: widget.postId.toString(),
                                      imageUrl: widget.content[0],
                                      update: (value) {},
                                      text: widget.postText,
                                    ));
                                    // ใส่โค้ดสำหรับแก้ไขโพสต์ที่นี่
                                  } else if (value == 'delete') {
                                    // ดำเนินการลบโพสต์
                                    ApiPost.deletePost(
                                        widget.postId.toString(), user.userId);
                                    print("ลบโพสต์");
                                    setState(() {
                                      opacity = 0.0; // เปลี่ยนความโปร่งใสเป็น 0
                                      visible = false;
                                    });
                                    // ใส่โค้ดสำหรับลบโพสต์ที่นี่
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: TextCustom(
                                      text: 'แก้ไข',
                                      size: 15,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: TextCustom(
                                      text: 'ลบ',
                                      size: 15,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Post Text
                        widget.postText != ""
                            ? TagText(postText: widget.postText)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  if (widget.type == 1) ...[
                    PostImageSlider(content: widget.content),
                  ],
                  if (widget.type == 2) ...[
                    _videoDownloadFailed
                        ? const Text("ไม่สามารถดาวน์โหลดวิดีโอได้")
                        : _videoController != null &&
                                _videoController!.value.isInitialized
                            ? VideoPlayerWidget(
                                controller: _videoController!,
                                onPlayPause: _onPlayPause)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 150,
                                  ),
                                  CircularProgressIndicator(),
                                ],
                              ),
                  ],
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 35,
                              child: IconButton(
                                icon: Icon(
                                  isLiked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                  color: isLiked
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    if (isDisliked) {
                                      isDisliked = !isDisliked;
                                      dislikes--;
                                    }
                                    isLiked = !isLiked;
                                    if (isLiked) {
                                      likes++;
                                      widget.updateStatus(1, likes, dislikes);
                                    } else {
                                      likes--;
                                      widget.updateStatus(0, likes, dislikes);
                                    }
                                  });
                                  if (isLiked) {
                                    await ApiPost.updatePostInteraction(
                                        userController.user.value.userId,
                                        widget.postId,
                                        1);
                                  } else {
                                    await ApiPost.updatePostInteraction(
                                        userController.user.value.userId,
                                        widget.postId,
                                        0);
                                  }
                                },
                              ),
                            ),
                            Text('$likes'),
                          ],
                        ),
                        CommentPage(
                            postId: widget.postId,
                            comments: comments,
                            user: widget.user,
                            updateCommentCount: updateCommentCount),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 35,
                              child: IconButton(
                                icon: Icon(
                                  isDisliked
                                      ? Icons.thumb_down
                                      : Icons.thumb_down_outlined,
                                  color: isDisliked
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    if (isLiked) {
                                      isLiked = !isLiked;
                                      likes--;
                                    }
                                    isDisliked = !isDisliked;
                                    if (isDisliked) {
                                      dislikes++;
                                      widget.updateStatus(-1, likes, dislikes);
                                    } else {
                                      dislikes--;
                                      widget.updateStatus(0, likes, dislikes);
                                    }
                                  });
                                  if (isDisliked) {
                                    await ApiPost.updatePostInteraction(
                                        userController.user.value.userId,
                                        widget.postId,
                                        -1);
                                  } else {
                                    await ApiPost.updatePostInteraction(
                                        userController.user.value.userId,
                                        widget.postId,
                                        0);
                                  }
                                },
                              ),
                            ),
                            Text('$dislikes'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
