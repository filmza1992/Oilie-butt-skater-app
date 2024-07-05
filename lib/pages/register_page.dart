import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_page.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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
          title: Text("Sign Up"),
        ),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "คอนเฟิร์ม Password"),
                ),
                ElevatedButton(
                  onPressed: _Mylogin,
                  child: Text("ยืนยันการสมัคร"),
                ),
              ],
            ),
          ),
        ));
  }

  void _Mylogin() {
    Get.to(const LoginPage());
  }
}
