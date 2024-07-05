import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:oilie_butt_skater_app/pages/login_page.dart';

import 'contant/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          background: AppColors.backgroundColor,
          onBackground: AppColors.textColor,
          
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor, // Set scaffold background color
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor, // Set AppBar background color
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage(),
    );
  }
}
