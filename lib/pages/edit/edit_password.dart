import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_profile.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/text_field_password.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key, required this.updateProfile});

  final Function updateProfile;
  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  dynamic user;
  final UserController userController = Get.find<UserController>();

  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPController = TextEditingController();
  bool isNull = false;

  void updateIsNull(value) {
    setState(() {
      isNull = value;
    });
    if (isNull) {
      _passwordController.text = "";
    }
  }

  Future<void> checkPassword() async {
    bool response = await ApiProfile.checkPassword(
      user.userId,
    );

    print(response);
    updateIsNull(response);
  }

  Future<void> updatePassword(BuildContext context) async {
    if (_newPasswordController.text == _confirmPController.text) {
      if (_formKey.currentState!.validate()) {
        dynamic data = {
          'user_id': user.userId,
          'password': _passwordController.text,
          'new_password': _newPasswordController.text,
        };
        User u = await ApiProfile.editPassword(data, context);
        userController.updateUser(u);
        widget.updateProfile();
      }
    } else {
      Alert().newWarning(
          context, 'รหัสผ่านไม่เหมือนกัน', 'กรุณากรอกรหัสผ่านให้เหมือนกัน');
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    user = userController.user.value;
    checkPassword();
    super.initState();
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
                  isNull
                      ? const TextCustom(
                          size: 20,
                          text: "เพิ่มรหัสผ่าน",
                          color: AppColors.primaryColor,
                        )
                      : const TextCustom(
                          size: 20,
                          text: "แก้ไขรหัสผ่าน",
                          color: AppColors.primaryColor,
                        ),
                  const SizedBox(height: 70),
                  if (!isNull) ...[
                    TextFieldPassword(
                      controller: _passwordController,
                      hint: 'รหัสผ่าน',
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่รหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  TextFieldPassword(
                    controller: _newPasswordController,
                    hint: 'รหัสผ่านใหม่',
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่รหัสผ่าน';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFieldPassword(
                    controller: _confirmPController,
                    hint: 'ยืนยันรหัสผ่านใหม่',
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่ยืนยันรหัสผ่าน';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            isNull
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ButtonCustom(
                              text: "เพิ่ม",
                              onPressed: () => updatePassword(context),
                              type: 'Elevated'),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ButtonCustom(
                              text: "เปลี่ยนรหัสผ่าน",
                              onPressed: () => updatePassword(context),
                              type: 'Elevated'),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
