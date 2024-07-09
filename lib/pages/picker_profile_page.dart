import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilie_butt_skater_app/api/api_auth.dart';
import 'package:oilie_butt_skater_app/components/profile_image_edit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';

import '../components/button_custom.dart';
import '../components/text_custom.dart';

import '../contant/color.dart';

class PickerProfilePage extends StatefulWidget {
  const PickerProfilePage({
    super.key,
    required this.user,
  });

  final dynamic user;

  @override
  State<PickerProfilePage> createState() => _PickerProfilePageState();
}

class _PickerProfilePageState extends State<PickerProfilePage> {
  final UserController userController = Get.find<UserController>();
  late File _imageFile;

  Future<void> getImage() async {
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
        maxWidth: 512, // กำหนดความกว้างสูงสุดของรูปภาพ
        maxHeight: 512, // กำหนดความสูงสูงสุดของรูปภาพ
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: const Color.fromARGB(255, 11, 9, 9),
            toolbarWidgetColor: AppColors.textColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _imageFile = File(croppedImage.path);
        });
      }
    } catch (e) {
      print("Image cropper error: $e");
    }
  }

  void signup(File imageFile) async {
    // อัปโหลดรูปภาพไปยัง Firebase Storage
    String imageUrl = await uploadImageToFirebase(imageFile);
    dynamic user = widget.user;
    user['image_url'] = imageUrl;

    User u = await ApiAuth.signUpUser(user);
    userController.updateUser(u);
    Get.to(HomePage());
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    String fileName =
        '${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}_${imageFile.path.split('/').last}';

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("profile/$fileName");
      await storageRef.putFile(imageFile);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      TextCustom(
                        text: "เลือกรูปโปรไฟล์ของคุณ",
                        size: 20,
                        color: AppColors.primaryColor,
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                      ),
                    ],
                  )
                ],
              ),
              ProfileImageEditPage(setImageFile: (imageFile) {
                setState(() {
                  _imageFile = imageFile;
                  print(imageFile);
                });
              }),
              ButtonCustom(
                text: "ยืนยันการเลือกรูปภาพ",
                onPressed: () => signup(_imageFile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
