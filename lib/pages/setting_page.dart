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
                  _logout(context);
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
