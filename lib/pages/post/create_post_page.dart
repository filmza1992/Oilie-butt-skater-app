import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/photo_gallery.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
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
  List<File?> selectedImageFiles = []; // เก็บไฟล์ภาพที่เลือก
  bool isSelected = false;

  void onImagesSelected(List<AssetEntity> selectedImages) async {
    selectedImageFiles.clear(); // ล้างไฟล์ภาพที่เลือกก่อนหน้า
    for (var image in selectedImages) {
      File? imageFile = await image.file;
      if (imageFile != null) {
        selectedImageFiles.add(imageFile); // เพิ่มไฟล์ภาพลงในรายการ
      }
    }
    updateSelected(); // อัปเดตสถานะการเลือก
  }

  Future<void> _fetchImages() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      // Handle granted permission
    } else {
      print('Permission denied');
    }
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    PhotoManager.setIgnorePermissionCheck(true);

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    List<AssetEntity> photos =
        await albums[0].getAssetListPaged(page: 0, size: 100);

    setState(() {
      images = photos;
    });
  }

  void updateSelected() {
    setState(() {
      isSelected = selectedImageFiles.isNotEmpty;
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
          TextCustom(
            size: 17,
            text: 'ถัดไป',
            color: AppColors.secondaryColor,
            onTap: () {
              print(isSelected);
              if (isSelected) {
                // ส่งไฟล์ภาพที่เลือกไปยัง CreateTextPostPage
                print("true");
                Get.to(CreateTextPostPage(
                  imageFiles: selectedImageFiles,
                  update: widget.update,
                ));
              }
              print("false");
            },
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
      body: PhotoGallery(
        images: images,
        onImagesSelected: onImagesSelected, // อัปเดตฟังก์ชันนี้
        isShowButton: false,
        updateSelected: updateSelected,
      ),
    );
  }
}
