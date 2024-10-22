import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/photo_gallery.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/video_gallery.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/pages/post/create_text_post_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, required this.update});

  final Function update;
  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  List<AssetEntity> images = [];
  List<AssetEntity> videos = [];
  List<File?> selectedMediaFiles =
      []; // เก็บไฟล์สื่อที่เลือก (ทั้งรูปภาพและวิดีโอ)
  bool isSelected = false;
  bool isVideoMode = false; // สลับระหว่างรูปภาพและวิดีโอ

  void onMediaSelected(List<AssetEntity> selectedMedia) async {
    selectedMediaFiles.clear(); // ล้างไฟล์สื่อที่เลือกก่อนหน้า
    for (var media in selectedMedia) {
      File? mediaFile = await media.file;
      if (mediaFile != null) {
        selectedMediaFiles.add(mediaFile); // เพิ่มไฟล์สื่อลงในรายการ
      }
    }
    updateSelected(); // อัปเดตสถานะการเลือก
  }

  Future<void> _fetchImages() async {
    var status = await Permission.storage.status;
    if (await Permission.manageExternalStorage.request().isGranted) {
      print('Manage External Storage permission granted');
    } else {
      print('Manage External Storage permission denied');
    }
    var s = await Permission.photos.request();
    if (s.isGranted) {
    } else {
      // Handle permission denied
      print('Permission denied');
    }
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    PhotoManager.setIgnorePermissionCheck(true);

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    List<AssetEntity> photos =
        await albums[0].getAssetListPaged(page: 0, size: 100);

    setState(() {
      images = photos;
    });
  }

  Future<void> _fetchVideos() async {
    // ดึงข้อมูลวิดีโอ
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
    );
    List<AssetEntity> videoFiles =
        await albums[0].getAssetListPaged(page: 0, size: 100);
    setState(() {
      videos = videoFiles;
    });
  }

  void updateSelected() {
    setState(() {
      isSelected = selectedMediaFiles.isNotEmpty;
      print(isSelected);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(
          size: 17,
          text: 'โพสต์ใหม่',
          color: Colors.grey,
        ),
        actions: [
          IconButton(
            icon: Icon(isVideoMode ? Icons.image : Icons.videocam),
            onPressed: () {
              // สลับระหว่างการเลือก "รูปภาพ" และ "วิดีโอ"
              setState(() {
                isVideoMode = !isVideoMode;
                if (isVideoMode) {
                  _fetchVideos();
                } else {
                  _fetchImages();
                }
              });
            },
          ),
          TextCustom(
            size: 17,
            text: 'ถัดไป',
            color: AppColors.secondaryColor,
            onTap: () {
              if (isSelected) {
                if (isVideoMode) {
                  Get.to(CreateTextPostPage(
                    mediaFiles: selectedMediaFiles,
                    update: widget.update,
                    type: "video",
                  ));
                } else {
                  Get.to(CreateTextPostPage(
                      mediaFiles: selectedMediaFiles,
                      update: widget.update,
                      type: "image"));
                }
              }
            },
          ),
          const SizedBox(
            width: 15,
          )
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
      body: isVideoMode
          ? VideoGallery(
              mediaItems: videos,
              onMediaSelected: onMediaSelected,
              isShowButton: false,
              updateSelected: updateSelected,
            )
          : PhotoGallery(
              mediaItems: images,
              onMediaSelected: onMediaSelected,
              isShowButton: false,
              updateSelected: updateSelected,
            ),
    );
  }
}
