import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/icon_button.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/textfield/text_field_custom.dart';
import 'package:oilie_butt_skater_app/components/textfield/text_field_password.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/pages/home_page.dart';
import 'package:oilie_butt_skater_app/pages/register_page.dart';

import '../../models/user.dart';
import '../api/api_auth.dart';
import '../components/background/backgroundLogin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User user = User(
    userId: '',
    username: '',
    email: '',
    password: '',
    imageUrl: '',
    birthDay: '',
    createAt: '',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _emailController.text = "";
      _passwordController.text = "";
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> myLogin() async {
    user = await ApiAuth.verifyUser(
        _emailController.text, _passwordController.text, context);

    userController.updateUser(user);
    Get.to(const HomePage());
  }

  void mySignIn() {
    Get.to(const RegisterPage());
  }

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final googleProfile = {
          "email": googleUser.email,
          "username": googleUser.displayName,
          "image_url": googleUser.photoUrl,
          "birth_day": "" // ใช้ birth_day เป็นค่าว่างไปก่อน
        };

        // เรียกใช้ API เพื่อตรวจสอบและเพิ่มข้อมูลผู้ใช้ในฐานข้อมูลของคุณ
        User user = await ApiAuth.registerGoogleUser(googleProfile);
        // อัปเดตผู้ใช้ใน controller
        userController.updateUser(User(
          userId: user.userId, // ID ควรดึงมาจากฐานข้อมูล
          username: user.username,
          email: user.email,
          password: user.password, // ไม่ควรเก็บรหัสผ่านในกรณีนี้
          imageUrl: user.imageUrl,
          birthDay: user.birthDay,
          createAt: '',
        ));

        print(userController.user.value);
        Get.to(const HomePage());
      }
    } catch (error) {
      print('Sign-In failed: $error');
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const TextCustom(
              text: 'ออกจากแอป?',
              size: 17,
              color: AppColors.textColor,
            ),
            content: const TextCustom(
                text: 'คุณต้องการออกจากแอปหรือไม่?',
                size: 17,
                color: AppColors.textColor),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // ไม่ออก
                child: const TextCustom(
                    text: 'ไม่', size: 17, color: AppColors.primaryColor),
              ),
              TextButton(
                onPressed: () => {SystemNavigator.pop()}, // ออกจากแอป
                child: const TextCustom(
                    text: 'ใช่', size: 17, color: AppColors.primaryColor),
              ),
            ],
          ),
        ) ??
        false; // จัดการค่าที่อาจเป็น null
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: const [],
            automaticallyImplyLeading: false,
          ),
          body: BackgroundLogin(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    TextFieldCustom(
                      controller: _emailController,
                      hint: 'อีเมล',
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldPassword(
                      controller: _passwordController,
                      hint: 'รหัสผ่าน',
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextCustom(
                          text: "ลืมรหัสผ่าน ?",
                          size: 13,
                          color: AppColors.secondaryColor,
                          onTap: () => {},
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonCustom(
                              text: "เข้าสู่ระบบ",
                              onPressed: myLogin,
                              type: 'Elevated'),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 158, 158, 158),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    IconButtonCustom(
                        onPressed: signInWithGoogle,
                        icon: Image.asset('assets/icons/google_color.png')),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextCustom(
                          text: "ยังไม่ได้ลงทะเบียน? ",
                          size: 13,
                          color: AppColors.textColor,
                        ),
                        TextCustom(
                          text: "สร้างบัญชี",
                          size: 13,
                          color: AppColors.secondaryColor,
                          onTap: () => mySignIn(),
                          underline: TextDecoration.underline,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
