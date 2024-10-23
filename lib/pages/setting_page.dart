import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/pages/edit/edit_password.dart';
import 'package:oilie_butt_skater_app/pages/login_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

void _confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const TextCustom(
          text: 'ยืนยันการออกจากระบบ',
          size: 20,
          color: AppColors.textColor,
        ),
        content: const TextCustom(
          text: 'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?',
          size: 15,
          color: AppColors.textColor,
        ),
        actions: <Widget>[
          TextButton(
            child: const TextCustom(
              text: 'ไม่',
              size: 15,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog เมื่อกดปุ่มไม่
            },
          ),
          TextButton(
            child: const TextCustom(
              text: 'ใช่',
              size: 15,
              color: Color.fromARGB(255, 244, 50, 50),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog เมื่อกดใช่
              _logout(context); // เรียกฟังก์ชัน logout
            },
          ),
        ],
      );
    },
  );
}

void _logout(context) {
  // Implement your logout logic here
  print("User logged out");
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: LoginPage(),
      ),
    ),
  );
}

class _SettingPageState extends State<SettingPage> {
  final UserController userController = Get.find<UserController>();
  dynamic user;

  void updateProfile() {
    setState(() {
      user = userController.user.value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    user = userController.user.value;
    print(userController.user.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Center(
          child: Column(
            children: [
              const TextCustom(
                size: 20,
                text: "การตั้งค่า",
                color: AppColors.primaryColor,
              ),
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(EditPasswordPage(updateProfile: updateProfile));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // ทำให้ขอบเป็นสี่เหลี่ยม
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(
                        text: "จัดการรหัสผ่าน",
                        size: 17,
                        color: AppColors.primaryColor,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _confirmLogout(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // ทำให้ขอบเป็นสี่เหลี่ยม
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(
                        text: "ออกจากระบบ",
                        size: 17,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
