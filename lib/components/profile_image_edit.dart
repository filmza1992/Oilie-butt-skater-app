import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../components/button_custom.dart';
import '../components/text_custom.dart';

import '../constant/color.dart';

class ProfileImageEditPage extends StatefulWidget {
  const ProfileImageEditPage({
    required this.setImageFile,
    super.key, this.imageUrl,
  });

  final String? imageUrl;
  final Function setImageFile;
  @override
  State<ProfileImageEditPage> createState() => _ProfileImageEditState();
}

class _ProfileImageEditState extends State<ProfileImageEditPage> {
  File? _imageFile;

  Future<void> getImage() async {
    print('get Image');
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        cropImage(pickedFile.path);
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  Future<void> cropImage(String imagePath) async {
    try {
      var croppedImage = await ImageCropper().cropImage(
        sourcePath: imagePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: AppColors.backgroundColor,
            toolbarWidgetColor: AppColors.textColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _imageFile = File(croppedImage.path);
          widget.setImageFile(_imageFile);
        });
      }
    } catch (e) {
      print("Image cropper error: $e");
    }
  }

  Widget buildImage() {
    final dynamic image = _imageFile != null
        ? FileImage(
            _imageFile!,
          )
        : widget.imageUrl != null ?
        NetworkImage(
            widget.imageUrl!)
        :const NetworkImage(
            'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png');
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: getImage,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: AppColors.backgroundColor,
        all: 3.0,
        child: buildCircle(
          color: color,
          all: 8.0,
          child: InkWell(
            onTap: getImage,
            child: const Icon(
              Icons.edit,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({required child, required color, required all}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(AppColors.secondaryColor),
          ),
        ],
      ),
    );
  }
}
