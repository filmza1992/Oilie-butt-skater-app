import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:oilie_butt_skater_app/components/text_field_date.dart';
import 'package:oilie_butt_skater_app/components/text_field_password.dart';
import 'package:oilie_butt_skater_app/pages/picker_profile_page.dart';

import '../components/button_custom.dart';
import '../components/text_custom.dart';
import '../components/text_field_custom.dart';
import '../constant/color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          TextCustom(
                            text: "สร้างบัญชี",
                            size: 20,
                            color: AppColors.primaryColor,
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                          ),
                          TextCustom(
                            text: "กรุณาใส่ข้อมูลบัญชีของคุณ",
                            size: 14,
                            color: AppColors.textColor,
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                        ],
                      )
                    ],
                  ),
                  TextFieldCustom(
                    controller: _usernameController,
                    hint: 'ชื่อ',
                    prefixIcon: const Icon(Icons.person_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่ชื่อ';
                      }
                      return null;
                    },
                  ),
                  TextFieldDateCustom(
                    hint: "วันเกิด",
                    controller: _dateController,
                    widthSizedBox: 70,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่วันเกิด';
                      }
                      return null;
                    },
                  ),
                  TextFieldCustom(
                    controller: _emailController,
                    hint: 'อีเมล',
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่อีเมล';
                      }
                      return null;
                    },
                  ),
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
                  TextFieldPassword(
                    controller: _confirmPController,
                    hint: 'ยืนยันรหัสผ่าน',
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่ยืนยันรหัสผ่าน';
                      }
                      return null;
                    },
                  ),
                  ButtonCustom(text: "เข้าสู่ระบบ", onPressed: register,type: 'Elevated'),
                ],
              ),
            ),
          ),
        ));
  }

  void register() {
    if (_formKey.currentState!.validate()) {
      dynamic user = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'birth_day': _dateController.text,
      };
      if (_passwordController.text == _confirmPController.text) {
        Get.to(PickerProfilePage(user: user));
      } else {
         Alert().newWarning(context, 'รหัสผ่านไม่เหมือนกัน', 'กรุณากรอกรหัสผ่านให้เหมือนกัน');
      }
    } else {
      Alert().newWarning(context, 'ข้อมูลไม่ครบ', 'กรุณากรอกข้อมูลให้ครบ');
    }
  }
}
