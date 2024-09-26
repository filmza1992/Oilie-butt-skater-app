import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';

class ButtonImage extends StatefulWidget {
  const ButtonImage(
      {super.key,
      required this.image,
      required this.text,
      required this.textColor,
      required this.onPressd,
      this.width});
  final String image;
  final String text;
  final Color textColor;
  final Function() onPressd;
  final double? width;

  @override
  State<ButtonImage> createState() => _ButtonImageState();
}

class _ButtonImageState extends State<ButtonImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.width ?? double.infinity,
          height: 135,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // ทำขอบมน
            image: DecorationImage(
              image: AssetImage(widget.image),
              fit: BoxFit.cover,
            ),
          ),
          child: InkWell(
            onTap: widget.onPressd,
            borderRadius: BorderRadius.circular(12), // ทำขอบมนของ InkWell ด้วย
            child: Container(), // ทำให้ InkWell ทำงานได้
          ),
        ),
        const SizedBox(height: 8), // เพิ่มระยะห่างระหว่างรูปภาพกับข้อความ
        TextCustom(
          text: widget.text, // ข้อความที่ต้องการแสดงใต้ปุ่ม
          size: 20,
          color: widget.textColor ??
              AppColors.textColor, // เปลี่ยนสีข้อความตามที่คุณต้องการ
        ),
      ],
    );
  }
}
