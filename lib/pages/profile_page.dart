import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/profile_image.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

void _logout() {
    // Implement your logout logic here
    print("User logged out");
    Get.to(const LoginPage());
  }
class _ProfilePageState extends State<ProfilePage> {
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
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile Page',
              style: TextStyle(fontSize: 24.0),
            ),
            ProfileImagePage(user:user),
            const SizedBox(height: 20.0),
            const Text(
              'Add your profile content here',
              style: TextStyle(fontSize: 16.0),
            ),
             ElevatedButton(
            onPressed: _logout,
            child: const Text("Logout"),
          )
          ],
        ),
      ),
    );
  }
}
