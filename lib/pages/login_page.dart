import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/icon_button.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/text_field_custom.dart';
import 'package:oilie_butt_skater_app/components/text_field_password.dart';
import 'package:oilie_butt_skater_app/contant/color.dart';
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

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController userController = Get.find<UserController>();

  User user = User(
    id: '',
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

  Future<void> myLogin() async {
    user = await ApiAuth.verifyUser(
        _emailController.text, _passwordController.text);

    userController.updateUser(user);
    Get.to(const HomePage());
    }

  void mySignIn() {
    Get.to(const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [],
        ),
        body: BackgroundLogin(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                        onTap: () => {print("forgot password")},
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ButtonCustom(
                    text: "เข้าสู่ระบบ",
                    onPressed: myLogin,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 10,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  IconButtonCustom(
                      onPressed: () {},
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
        ));
  }
}
