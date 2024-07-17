import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_create_model.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';

class CreateTextPostPage extends StatefulWidget {
  const CreateTextPostPage({super.key, required this.imageFile});

  final File? imageFile;
  @override
  State<CreateTextPostPage> createState() => _CreateTextPostPageState();
}

class _CreateTextPostPageState extends State<CreateTextPostPage> {
  final TextEditingController _textController = TextEditingController();
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          TextCustom(
            size: 17,
            text: 'โพสต์ใหม่',
            color: AppColors.secondaryColor,
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.imageFile != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Image.file(
                    widget.imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _textController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'เขียนรายละเอียดโพสต์...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ButtonCustom(
                  text: 'โพสต์',
                  onPressed: () async {
                    await ApiPost.addPost(PostCreate(
                        _textController.text,
                        userController.user.value.id,
                        1,
                        "tag",
                        "create_at",
                        widget.imageFile),context);
                       
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
