import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/profile_post.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';

class Post extends StatelessWidget {
  final String username;
  final String postText;
  final int likes;
  final int dislikes;
  final int comments;
  final String imageUrl;

  const Post({
    super.key,
    required this.username,
    required this.postText,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePost(user: userController.user.value),
                SizedBox(
                  height: 20,
                ),
                // Post Text
                Text(postText),
              ],
            ),
          ),
          // Username

          SizedBox(height: 10.0),
          Image.asset(
            'assets/images/istockphoto-465492606-612x612.jpg',
            fit: BoxFit.cover,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: IconButton(
                        icon: Icon(Icons.thumb_up_outlined),
                        onPressed: () {},
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
                        icon: Icon(Icons.mode_comment_outlined),
                        onPressed: () {
                          // Comment button pressed
                        },
                      ),
                    ),
                    Text('$comments'),
                  ],
                ),
               Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                         height: 35,
                        child: IconButton(
                          icon: Icon(Icons.thumb_down_outlined),
                          onPressed: () {
                            // Dislike button pressed
                          },
                        ),
                      ),
                      Text('$dislikes'),
                    ],
                  ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
