import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_create_model.dart';
import 'package:video_player/video_player.dart';

class CreateTextPostPage extends StatefulWidget {
  const CreateTextPostPage(
      {super.key,
      required this.mediaFiles,
      required this.update,
      required this.type});

  final List<File?> mediaFiles;
  final Function update;
  final String type;

  @override
  State<CreateTextPostPage> createState() => _CreateTextPostPageState();
}

class _CreateTextPostPageState extends State<CreateTextPostPage> {
  final TextEditingController _textController = TextEditingController();
  UserController userController = Get.find<UserController>();
  VideoPlayerController? _videoController;
  bool _videoDownloadFailed = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'video' && widget.mediaFiles.isNotEmpty) {
      _initializeVideoPlayer(widget.mediaFiles[0]!); // วิดีโอเดียว
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer(File videoFile) {
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        setState(() {
          _videoDownloadFailed = true; // ถ้าวิดีโอโหลดไม่สำเร็จ
        });
      });
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
        surfaceTintColor: AppColors.backgroundColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ถ้าเป็นวิดีโอ ให้วางไว้ข้างนอก CarouselSlider
                    if (widget.type == 'video')
                      _videoDownloadFailed
                          ? const Text("ไม่สามารถดาวน์โหลดวิดีโอได้")
                          : _videoController != null &&
                                  _videoController!.value.isInitialized
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 400,
                                      child: AspectRatio(
                                        aspectRatio:
                                            _videoController!.value.aspectRatio,
                                        child: VideoPlayer(_videoController!),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _videoController!.value.isPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_filled,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _videoController!.value.isPlaying
                                              ? _videoController!.pause()
                                              : _videoController!.play();
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 150,
                                    ),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                    // Carousel สำหรับแสดงภาพ
                    if (widget.type != 'video')
                      CarouselSlider.builder(
                        itemCount: widget.mediaFiles.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            child: Image.file(
                              height: 400,
                              widget.mediaFiles[index]!,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 400,
                          autoPlay: false,
                          enlargeCenterPage: true,
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
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ButtonCustom(
                              height: 30,
                              text: 'โพสต์',
                              onPressed: () async {
                                if (widget.type == 'video') {
                                  await ApiPost.addPost(
                                      PostCreate(
                                          _textController.text,
                                          userController.user.value.userId,
                                          2,
                                          "tag",
                                          "create_at",
                                          widget.mediaFiles),
                                      context,
                                      widget.update);
                                } else {
                                  await ApiPost.addPost(
                                      PostCreate(
                                          _textController.text,
                                          userController.user.value.userId,
                                          1,
                                          "tag",
                                          "create_at",
                                          widget.mediaFiles),
                                      context,
                                      widget.update);
                                }
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
        },
      ),
    );
  }
}
