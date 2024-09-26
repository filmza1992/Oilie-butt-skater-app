import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';

class BackgroundLogin extends StatelessWidget {
  const BackgroundLogin({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            child: Image.asset(
              "assets/icons/app_icon.png",
              fit: BoxFit.cover,
              width: 105,
              height: 87,
            ),
          ),
          const TextCustom(
            text: "ยินดีต้อนรับ",
            size: 20,
            color: AppColors.primaryColor,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          ),
          const TextCustom(
            text: "กรุณาใส่ข้อมูลบัญชีของคุณ",
            size: 14,
            color: AppColors.textColor,
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          child,
        ],
      ),
    );
  }
}
