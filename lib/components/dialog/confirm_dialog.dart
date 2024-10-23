import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';

class DialogUtils {
  static Future<void> confirmQuitRoom(
      BuildContext context, Function onConfirm) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const TextCustom(
            text: 'ยืนยันการออกจากห้อง',
            size: 20,
            color: AppColors.textColor,
          ),
          content: const TextCustom(
            text: 'คุณต้องการออกจากห้องนี้หรือไม่?',
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
                Navigator.of(context).pop(); // ปิด dialog ถ้ากดไม่
              },
            ),
            TextButton(
              child: const TextCustom(
                text: 'ใช่',
                size: 15,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog เมื่อกดใช่
                onConfirm(); // เรียก callback เมื่อยืนยัน
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> confirmDeleteRoom(
      BuildContext context, Function onConfirm) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const TextCustom(
            text: 'ยืนยันการลบห้อง',
            size: 20,
            color: AppColors.textColor,
          ),
          content: const TextCustom(
            text: 'คุณต้องการลบห้องนี้หรือไม่?',
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
                Navigator.of(context).pop(); // ปิด dialog ถ้ากดไม่
              },
            ),
            TextButton(
              child: const TextCustom(
                text: 'ใช่',
                size: 15,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog เมื่อกดใช่
                onConfirm(); // เรียก callback เมื่อยืนยัน
              },
            ),
          ],
        );
      },
    );
  }
}
