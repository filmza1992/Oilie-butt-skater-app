import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/text_field_date.dart';
import 'package:oilie_butt_skater_app/components/text_field_password.dart';

import '../components/button_custom.dart';
import '../components/text_custom.dart';
import '../components/text_field_custom.dart';
import '../contant/color.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final tabs = [
    const LoginPage(),
  ];
  void _incrementCounter() {
    setState(() {
      _usernameController.text = "";
      _passwordController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:10,horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const TextCustom(
                          text: "สร้างบัญชี",
                          size: 20,
                          color: AppColors.primaryColor,
                          padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                        ),
                        const TextCustom(
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
                ),
                TextFieldDateCustom(
                  hint: "วันเกิด",
                  controller: _dayController,
                  widthSizedBox: 70,
                ),
                TextFieldCustom(
                  controller: _usernameController,
                  hint: 'อีเมล',
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                TextFieldPassword(
                  controller: _passwordController,
                  hint: 'รหัสผ่าน',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                TextFieldPassword(
                  controller: _confirmPController,
                  hint: 'ยืนยันรหัสผ่าน',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                ButtonCustom(text: "เข้าสู่ระบบ", onPressed: mylogin),
              ],
            ),
          ),
        ));
  }

  void mylogin() {
    Get.to(const LoginPage());
  }
}
