import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/comment_model.dart';
import 'package:oilie_butt_skater_app/pages/comment/comment_sheet.dart';

class CommentPage extends StatefulWidget {
  const CommentPage(
      {super.key, required this.postId, required this.comments, this.user, required this.updateCommentCount});

  final int postId;
  final int comments;
  final dynamic user;
  final Function updateCommentCount;
  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool isCommented = false;
  bool isLoading = true;

  dynamic user;
  UserController userController = Get.find<UserController>();

  List<Comment> comments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // พื้นหลังเป็นโปร่งใส
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // ปิด bottom sheet เมื่อกดที่พื้นหลัง
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent, // ทำให้คลิกได้ที่พื้นหลัง
            child: DraggableScrollableSheet(
              initialChildSize: 0.9, // ขนาดเริ่มต้น 80% ของหน้าจอ
              minChildSize: 0.4, // ขนาดต่ำสุด 40%
              maxChildSize: 0.9, // ขนาดสูงสุด 90%
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return GestureDetector(
                  onTap: () {}, // ป้องกันการปิดเมื่อกดในส่วนของ comment sheet
                  child: CommentSheet(
                    scrollController: scrollController,
                    postId: widget.postId,
                    user: user,
                    updateCommentCount: widget.updateCommentCount,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 35,
          child: IconButton(
            icon: Icon(
              isCommented ? Icons.mode_comment : Icons.mode_comment_outlined,
              color: isCommented ? AppColors.primaryColor : Colors.white,
            ),
            onPressed: _showCommentSheet, // เรียกใช้ฟังก์ชันแสดง CommentSheet
          ),
        ),
        Text('${widget.comments}'),
      ],
    );
  }
}
