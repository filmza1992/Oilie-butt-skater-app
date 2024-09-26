import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/profile_post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';

class PostComponent extends StatefulWidget {
  final String userId;
  final int postId;
  final String username;
  final String userImage;
  final String postText;
  final int likes;
  final int dislikes;
  final int comments;
  final String content;
  final int status;
  final Function updateStatus;

  const PostComponent({
    super.key,
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
  });

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isCommented = false;
  int likes = 0;
  int dislikes = 0;

  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    likes = widget.likes;
    dislikes = widget.dislikes;
    if (widget.status == 1) {
      isLiked = true;
    } else if (widget.status == -1) {
      isDisliked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePost(
                  username: widget.username,
                  userImage: widget.userImage,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Post Text
                Text(widget.postText),
              ],
            ),
          ),
          // Username

          const SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            child: Image.network(
              widget.content,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: IconButton(
                        icon: Icon(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color:
                              isLiked ? AppColors.primaryColor : Colors.white,
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
                              widget.updateStatus(1,likes,dislikes);
                            } else {
                              likes--;
                              widget.updateStatus(0,likes,dislikes);
                            }
                          });
                          if (isLiked) {
                            await ApiPost.updatePostInteraction(
                                userController.user.value.userId, widget.postId, 1);
                          } else {
                            await ApiPost.updatePostInteraction(
                                userController.user.value.userId, widget.postId, 0);
                          }
                        },
                      ),
                    ),
                    Text('$likes'),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 35,
                      child: IconButton(
                        icon: Icon(
                          isCommented
                              ? Icons.mode_comment
                              : Icons.mode_comment_outlined,
                          color: isCommented
                              ? AppColors.primaryColor
                              : Colors.white,
                        ),
                        onPressed: () {
                          // Comment button pressed
                        },
                      ),
                    ),
                    Text('${widget.comments}'),
                  ],
                ),
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
                              widget.updateStatus(-1,likes,dislikes);
                            } else {
                              dislikes--;
                              widget.updateStatus(0,likes,dislikes);
                            }
                          });
                          if (isDisliked) {
                            await ApiPost.updatePostInteraction(
                                userController.user.value.userId,
                                widget.postId,
                                -1);
                          } else {
                            await ApiPost.updatePostInteraction(
                                userController.user.value.userId, widget.postId, 0);
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
            color: Color.fromARGB(255, 44, 44, 44),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
