import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    required this.text,
    this.color,
    this.textAlign,
    this.padding,
    required this.onPressed,
    this.fontSize
  });

  final String text;
  final Color? color;
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
