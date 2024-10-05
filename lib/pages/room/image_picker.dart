import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:oilie_butt_skater_app/components/photo_gallery.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/pages/room/create_text_room_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerRoom extends StatefulWidget {
  const ImagePickerRoom({super.key, required this.data});

  final dynamic data;

  @override
  State<ImagePickerRoom> createState() => _ImagePickerRoomState();
}

class _ImagePickerRoomState extends State<ImagePickerRoom> {
  List<AssetEntity> images = [];
  File? _imageFile;
  bool isSelected = false;
  ValueNotifier<File?> image = ValueNotifier<File>(File(""));

  void onImageSelected(AssetEntity image) async {
    File? imageFile = await image.file;

    _imageFile = imageFile;
    this.image.value = _imageFile;
    print(_imageFile);

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
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
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
        var data = {
          'latitude': widget.data['latitude'],
          'longitude': widget.data['longitude'],
          'image_file': _imageFile
        };
        setState(() {
          _imageFile = File(croppedImage.path);
          Get.to(CreateTextRoomPage(
            imageFile: _imageFile,
            data: data
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
      if (images.isNotEmpty) {
        updateImageFile();
      }
    });
  }

  Future<void> updateImageFile() async {
    _imageFile = await images.first.file;
    image.value = _imageFile;

    isSelected = true;
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
          text: 'ห้องใหม่',
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
      body: Column(
        children: [
          // Show selected image at the top
          ValueListenableBuilder(
            valueListenable: image,
            builder: (context, value, child) {
              return !isSelected
                  ? const SizedBox(
                      height: 300,
                      child: Center(
                          child:
                              CircularProgressIndicator()), // แสดง loading ขณะโหลดข้อมูล
                    )
                  : Expanded(
                      child: Image.file(
                        _imageFile!,
                        height: 300, // Set the height for the selected image
                        fit: BoxFit.cover,
                      ),
                    );
            },
          ),

          Expanded(
            child: PhotoGallery(
              images: images,
              onImageSelected: onImageSelected,
              isShowButton: false,
              updateSelected: updateSelected,
            ),
          ),
        ],
      ),
    );
  }
}
