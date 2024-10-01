import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/firebase_upload_image_.dart';
import 'package:oilie_butt_skater_app/api/api_profile.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/profile_image_edit.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/text_field_custom.dart';
import 'package:oilie_butt_skater_app/components/text_field_date.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.updateProfile});

  final Function updateProfile;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  dynamic user;
  final UserController userController = Get.find<UserController>();

  final _formKey = GlobalKey<FormState>();

  var _imageFile;
  TextEditingController usernameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

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

  Future<void> updateProfile(File? imageFile, BuildContext context) async {
    String imageUrl = "";
    Navigator.pop(context);

    if (_formKey.currentState!.validate()) {
      if (imageFile != null) {
        imageUrl = await uploadImageToFirebaseProfile(imageFile);
      } else {
        imageUrl = user.imageUrl;
      }
      dynamic data = {
        'user_id': user.userId,
        'username': usernameController.text,
        'birth_day': dateController.text,
        'image_url': imageUrl
      };
      User u = await ApiProfile.editProfile(data);
      userController.updateUser(u);
      widget.updateProfile();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = userController.user.value;

    usernameController.text = user.username;
    dateController.text = user.birthDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const TextCustom(
                    size: 20,
                    text: "แก้ไขข้อมูลส่วนตัว",
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 30),
                  ProfileImageEditPage(
                    setImageFile: (imageFile) {
                      setState(() {
                        _imageFile = imageFile;
                        print(imageFile);
                      });
                    },
                    imageUrl: user.imageUrl,
                  ),
                  const SizedBox(height: 40.0),
                  TextFieldCustom(
                    controller: usernameController,
                    hint: 'ชื่อ',
                    prefixIcon: const Icon(Icons.person_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่ชื่อ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFieldDateCustom(
                    hint: "วันเกิด",
                    controller: dateController,
                    widthSizedBox: 70,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่วันเกิด';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonCustom(
                          text: "แก้ไข",
                          onPressed: () => updateProfile(_imageFile, context),
                          type: 'Elevated'),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
