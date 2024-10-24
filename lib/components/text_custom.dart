import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextCustom extends StatelessWidget {
  const TextCustom({
    Key? key,
    required this.text,
    required this.size,
    this.color,
    this.isBold = false,
    this.textAlign,
    this.padding,
    this.onTap,
    this.underline,
  });

  final String? text;
  final double size;
  final Color? color;
  final bool isBold;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final Function()? onTap;
  final TextDecoration? underline;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Text(
          text!,
          style: GoogleFonts.kanit(
            fontSize: size,
            color: color ?? Colors.black,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            decoration: underline,
          ),
          textAlign: textAlign ?? TextAlign.start,
        ),
      ),
    );
  }
}

