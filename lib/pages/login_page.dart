import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/icon_button.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/components/text_field_custom.dart';
import 'package:oilie_butt_skater_app/components/text_field_password.dart';
import 'package:oilie_butt_skater_app/contant/color.dart';
import 'package:oilie_butt_skater_app/pages/register_page.dart';

import '../../models/user.dart';

import '../components/backgroundLogin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  User user = User(
    id: 0,
    firstName: "0",
    lastName: "0",
    user: "0",
    password: "0",
    phone: "0",
    image: "0",
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                    controller: _usernameController,
                    hint: 'อีเมล',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(
                    height: 10,
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _Mylogin,
                          child: Text("Login"),
                        ),
                      ),
                    ],
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
                        onTap: () => {print("signup")},
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

  Future<void> _Mylogin() async {
    print("Success");
  }

  void _MySignIn() {
    Get.to(const RegisterPage());
  }
}
