import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
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
      builder: (context) => Scaffold(
       
        body: LoginPage(),
      ),
    ),
  );
}

class _SettingPageState extends State<SettingPage> {
  final UserController userController = Get.find<UserController>();
  dynamic user;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              child: Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
