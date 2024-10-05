import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.padding,
    required this.onPressed,
    this.fontSize,
    this.backgroundColor,
    this.minWidth, // ปรับความกว้างขั้นต่ำ
    this.height, // ปรับความสูง
    this.borderRadius,
    this.width, // ปรับขอบโค้ง
    required this.type, // ระบุประเภทของปุ่ม
  });

  final String text;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final Function() onPressed;
  final double? minWidth;
  final double? width;
  final double? height;
  final double? borderRadius;
  final String type;

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบประเภทของปุ่มตามค่า type ที่รับเข้ามา
    if (type == 'Elevated') {
      return ElevatedButton(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            Size(minWidth ?? 100, height ?? 40),
          ), // กำหนดขนาดขั้นต่ำ
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? AppColors.primaryColor,
          ), // กำหนดสีพื้นหลัง
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          child: Text(
            text,
            textAlign: textAlign ?? TextAlign.center,
            style: GoogleFonts.kanit(
              fontSize: fontSize,
              color: color ?? Colors.black,
            ),
          ),
        ),
      );
    } else if (type == 'Text') {
      return TextButton(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            Size(minWidth ?? 100, height ?? 50),
          ),
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? Colors.transparent,
          ),
          
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.kanit(
            fontSize: fontSize,
            color: color ?? AppColors.primaryColor,
          ),
        ),
      );
    } else if (type == 'Outlined') {
      return OutlinedButton(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            Size(minWidth ?? 100, height ?? 50),
          ),
          side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.primaryColor),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.kanit(
            fontSize: fontSize,
            color: color ?? AppColors.primaryColor,
          ),
        ),
      );
    } else {
      return Container(); // ในกรณีที่ไม่มี type ที่ระบุ
    }
  }
}
