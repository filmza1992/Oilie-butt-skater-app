import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/color.dart';

class Alert {
  final String? title;
  final String? message;
  Alert({
    this.title,
    this.message,
  });
  void loading(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      text: "กำลังโหลด...",
      autoCloseDuration: const Duration(seconds: 30),
      barrierDismissible: false,
    );
  }

  void success(BuildContext context,
      [VoidCallback? onConfirmBtnTap, bool barrierDismissible = true]) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      title: "สำเร็จ",
      backgroundColor: Colors.greenAccent,
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: onConfirmBtnTap,
      barrierDismissible: barrierDismissible,
    );
  }

  void error(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: "เกิดข้อผิดพลาด !",
      backgroundColor: Colors.redAccent,
      confirmBtnColor: Colors.red,
    );
  }

  void warning(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: "เกิดข้อผิดพลาด !",
      backgroundColor: Colors.amberAccent.shade700,
      confirmBtnColor: Colors.amber,
    );
  }

  void newError(BuildContext context, String title, message) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: title,
      text: message,
      loopAnimation: true,
      backgroundColor: AppColors.primaryColor.withOpacity(0.8),
      confirmBtnColor: AppColors.primaryColor,
    );
  }

  void newWarning(BuildContext context, String title, message) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: title,
      text: message,
      titleTextStyle: GoogleFonts.kanit(fontSize: 20),
      textTextStyle: GoogleFonts.kanit(),
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      confirmBtnColor: Colors.red,
    );
  }

  void info(BuildContext context, String title) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      title: title,
      backgroundColor: Colors.blue.shade200,
      confirmBtnColor: Colors.blue,
    );
  }

  static void decision(
      [String? title, String? message, VoidCallback? onConfirmBtnTap]) {
    BuildContext context = Get.context!;
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: title,
      text: message,
      // barrierDismissible: false,
      cancelBtnText: 'ยกเลิก',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      confirmBtnText: 'ตกลง',
      onConfirmBtnTap: onConfirmBtnTap,
    );
  }

  static void decisionDanger(
      [String? title, String? message, VoidCallback? onConfirmBtnTap]) {
    BuildContext context = Get.context!;
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: title,
      text: message,
      // barrierDismissible: false,
      backgroundColor: Colors.redAccent,
      confirmBtnColor: Colors.red,
      showCancelBtn: true,
      cancelBtnText: 'ยกเลิก',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      confirmBtnText: 'ตกลง',
      onConfirmBtnTap: onConfirmBtnTap,
    );
  }

  void dismiss(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (context != null) {
      Navigator.pop(context);
    }
  }

  void customeAlert(
    BuildContext context,
    String title,
    message,
    CoolAlertType type,
    VoidCallback? onConfirmBtnTap,
    VoidCallback? onCancelBtnTap,
    String confirmBtnText,
    String cancelBtnText,
    bool showCancelBtn,
  ) {
    CoolAlert.show(
      context: context,
      type: type,
      title: title,
      text: message,
      showCancelBtn: showCancelBtn,
      backgroundColor: AppColors.primaryColor.withOpacity(0.8),
      confirmBtnColor: AppColors.primaryColor,
      confirmBtnText: confirmBtnText,
      cancelBtnText: cancelBtnText,
      onConfirmBtnTap: onConfirmBtnTap,
      onCancelBtnTap: onCancelBtnTap,
    );
  }
}


// ListTile(
//   title: const Text('CoolAlert'),
//   onTap: () {
//     Alert().success(context);
//   },
// ),
// ListTile(
//   title: const Text('CoolAlert'),
//   onTap: () {
//     Alert().error(context);
//   },
// ),
// ListTile(
//   title: const Text('CoolAlert'),
//   onTap: () {
//     Alert().warning(context);
//   },
// ),