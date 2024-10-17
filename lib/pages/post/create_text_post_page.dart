import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart'; // นำเข้า carousel_slider
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_create_model.dart';

class CreateTextPostPage extends StatefulWidget {
  const CreateTextPostPage(
      {super.key, required this.imageFiles, required this.update});

  final List<File?> imageFiles;
  final Function update;

  @override
  State<CreateTextPostPage> createState() => _CreateTextPostPageState();
}

class _CreateTextPostPageState extends State<CreateTextPostPage> {
  final TextEditingController _textController = TextEditingController();
  UserController userController = Get.find<UserController>();
  int _currentIndex = 0; // สถานะเก็บตำแหน่งที่เลื่อนอยู่

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
              // Carousel สำหรับแสดงภาพ
              CarouselSlider.builder(
                itemCount: widget.imageFiles.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Image.file(
                      widget.imageFiles[index]!,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200, // ปรับความสูงของ Carousel ตามต้องการ
                  autoPlay: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index; // อัปเดตตำแหน่งที่เลื่อนอยู่
                    });
                  },
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
              const SizedBox(height: 10),
              // จุดบอกตำแหน่ง
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageFiles.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? AppColors.secondaryColor
                          : Colors.grey,
                    ),
                  );
                }),
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
                          await ApiPost.addPost(
                              PostCreate(
                                  _textController.text,
                                  userController.user.value.userId,
                                  1,
                                  "tag",
                                  "create_at",
                                  widget.imageFiles), // ใช้ imageFiles
                              context,
                              widget.update);
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
