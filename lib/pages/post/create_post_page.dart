import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/firebase_upload_image_.dart';
import 'package:oilie_butt_skater_app/components/photo_gallery.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/pages/post/create_text_post_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  List<AssetEntity> images = [];
  File? _imageFile;
  bool isSelected = false;

  void onImageSelected(AssetEntity image) async {
    File? imageFile = await image.file;
    _imageFile = imageFile;

    // if (imageFile != null) {
    //   String downloadUrl = await uploadImageToFirebaseMessage(imageFile);
    //   if (downloadUrl.isNotEmpty) {
    //     sendImageMessage(downloadUrl);

    //   }
    // }
  }

  Future<void> cropImage(String imagePath) async {
    try {
      var croppedImage = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: AppColors.backgroundColor,
            toolbarWidgetColor: AppColors.textColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
        ],
      );

      if (croppedImage != null) {
       setState(() {
          _imageFile = File(croppedImage.path);
          Get.to(CreateTextPostPage(
            imageFile: _imageFile,
          ));
        });
      }
      
    } catch (e) {
      print("Image cropper error: $e");
    }
  }

  Future<void> _fetchImages() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
    } else {
      // Handle permission denied
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
      isSelected = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
              if (isSelected) {
                if (_imageFile != null) {
                  cropImage(_imageFile!.path);
                }
              }
            },
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
      body: PhotoGallery(
        images: images,
        onImageSelected: onImageSelected,
        isShowButton: false,
        updateSelected: updateSelected,
      ),
    );
  }
}
