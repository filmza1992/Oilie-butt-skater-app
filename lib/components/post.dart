import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/profile_post.dart';

class PostComponent extends StatelessWidget {
  final String username;
  final String userImage;
  final String postText;
  final int likes;
  final int dislikes;
  final int comments;
  final String content;

  const PostComponent({
    super.key,
    required this.username,
    required this.userImage,
    required this.postText,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.content,
  });

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
                  username: username,
                  userImage: userImage,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Post Text
                Text(postText),
              ],
            ),
          ),
          // Username

          const SizedBox(height: 10.0),
          Image.network(
            content,
            fit: BoxFit.cover,
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
                        icon: const Icon(Icons.thumb_up_outlined),
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
                        icon: const Icon(Icons.mode_comment_outlined),
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
                        icon: const Icon(Icons.thumb_down_outlined),
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
          
          
          Divider(
            color: Color.fromARGB(255, 44, 44, 44),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
