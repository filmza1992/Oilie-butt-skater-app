import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_create_model.dart';

class EditTextPostPage extends StatefulWidget {
  const EditTextPostPage(
      {super.key,
      required this.imageUrl,
      required this.update,
      required this.postId,
      required this.text});

  final String postId;
  final String imageUrl;
  final Function update;
  final String text;

  @override
  State<EditTextPostPage> createState() => _EditTextPostPageState();
}

class _EditTextPostPageState extends State<EditTextPostPage> {
  final TextEditingController _textController = TextEditingController();
  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController.text = widget.text;
  }

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
              if (widget.imageUrl != "")
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Image.network(
                    widget.imageUrl,
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ButtonCustom(
                        height: 30,
                        text: 'โพสต์',
                        onPressed: () async {
                          await ApiPost.updatePost(
                            PostCreate(
                                _textController.text,
                                userController.user.value.userId,
                                1,
                                "tag",
                                "create_at",
                                widget.imageUrl),
                            context,
                            widget.update,
                            widget.postId,
                          );
                        },
                        type: 'Elevated',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
