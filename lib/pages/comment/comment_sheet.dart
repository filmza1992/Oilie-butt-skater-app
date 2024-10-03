import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/api/api_comment.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/models/comment_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({
    super.key,
    required this.scrollController,
    required this.postId,
    required this.user,
    this.updateCommentCount,
  });

  final ScrollController scrollController;
  final int postId;
  final User user;
  final updateCommentCount;
  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];

  Future<void> fetchComment() async {
    var data = await ApiComment.getCommentByPostId(widget.postId);
    setState(() {
      comments = data;
      widget.updateCommentCount(comments.length);
      print(comments);
    });
  }

  void updateComments(value) {
    setState(() {
      comments = value;
      print(comments);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchComment();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 27, 27, 27), // สีพื้นหลังของส่วนที่เลื่อน
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          TextCustom(
            text: "ความคิดเห็น",
            size: 16,
            color: Colors.grey[500],
          ),
          const SizedBox(
            height: 6,
          ),
          const Divider(
            color: Color.fromARGB(255, 59, 59, 59),
          ),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                Comment comment = comments[index];

                return ListTile(
                  title: TextCustom(
                    size: 15,
                    text: comment.username,
                    color: AppColors.textColor,
                  ),
                  subtitle: TextCustom(
                    size: 13,
                    text: comment.commentText,
                    color: AppColors.textColor,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: comment.userImage != ""
                        ? NetworkImage(comment.userImage)
                        : const NetworkImage(
                            'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                    radius: 17,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            height: 60,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.user.imageUrl != ""
                      ? NetworkImage(widget.user.imageUrl)
                      : const NetworkImage(
                          'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                  radius: 17,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 20), // Adjust the padding here

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // Implement sending message logic
                    // onChanged: (value) { ... },
                    // onSubmitted: (value) { ... },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String commentText = _commentController.text;
                    if (commentText.isNotEmpty) {
                      ApiComment.addCommentByPostId(widget.postId,
                          widget.user.userId, commentText, updateComments);
                      _commentController.clear();
                      widget.updateCommentCount(-1);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
