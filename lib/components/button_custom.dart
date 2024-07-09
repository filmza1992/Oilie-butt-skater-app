import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oilie_butt_skater_app/contant/color.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom(
      {Key? key,
      required this.text,
      this.color,
      this.textAlign,
      this.padding,
      required this.onPressed,
      this.fontSize,
      this.backgroundColor});

  final String text;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  AppColors.primaryColor), // Set the background color
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: GoogleFonts.kanit(
                fontSize: fontSize,
                color: color ?? Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
