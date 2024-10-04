import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';

class Rankingbackground extends StatelessWidget {
  const Rankingbackground(
      {super.key,
      required this.child,
      required this.month,
      required this.amount});
  final Widget child;
  final String month;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextCustom(
          size: 45,
          text: "Ranking",
          color: AppColors.rankingSecondaryLabelColor,
        ),
        const TextCustom(
          size: 30,
          text: "Popular",
          color: AppColors.rankingThirdLabelColor,
        ),
        const SizedBox(height: 10),
        TextCustom(
          size: 19,
          text: "ประจำเดือน $month",
          color: AppColors.primaryColor,
        ),
        Image.asset(
          'assets/images/ranking_icon.png', // เพิ่มรูปภาพแทน Icon
          width: 150, // ขนาดรูปภาพสามารถปรับได้
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextCustom(
              text: amount,
              size: 24,
              color: AppColors.secondaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            const TextCustom(
              text: "Like",
              size: 24,
              color: AppColors.textColor,
            )
          ],
        ),
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Divider(
            color: Color.fromARGB(255, 158, 158, 158),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: child,
            ),
            
          ],
        )
      ],
    );
  }
}
