import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextFieldEmailCustom extends StatefulWidget {
  TextFieldEmailCustom(
      {key,
      this.label,
      required this.hint,
      required this.controller,
      this.textAlign,
      this.circular,
      this.widthSizedBox,
      this.mainAxisAlignment,
      this.widthText,
      this.edgeInsets,
      this.ob,
      this.prefixIcon,
      this.suffixIcon,
      this.errorText,
      this.validator,
      this.maxLines,
      this.maxLength});

  String? label;
  String hint;
  TextEditingController controller;
  TextAlign? textAlign;
  double? circular;
  double? widthSizedBox;
  MainAxisAlignment? mainAxisAlignment;
  double? widthText;
  EdgeInsets? edgeInsets;
  String? ob;
  Icon? prefixIcon;
  Icon? suffixIcon;
  String? errorText;
  FormFieldValidator<String>? validator;
  int? maxLines;
  int? maxLength;
  @override
  State<TextFieldEmailCustom> createState() => _TextFieldEmailCustomState();
}

class _TextFieldEmailCustomState extends State<TextFieldEmailCustom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines ?? 1,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.circular ?? 10),
                  ),
                ),
                labelText: widget.hint,
                labelStyle: GoogleFonts.kanit(
                  fontSize: 16,
                ),
                contentPadding: widget.edgeInsets ?? const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                prefixIcon: widget.prefixIcon, // ไอคอนทางซ้าย
                suffixIcon: widget.suffixIcon, // ไอคอนทางขวา),
                errorText: widget.errorText,
              ),
              textAlign: widget.textAlign ?? TextAlign.start,
              style: GoogleFonts.kanit(
                fontSize: 16,
              ),
              onChanged: (String value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกอีเมล';
                }
                // ตรวจสอบรูปแบบอีเมล
                String pattern =
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return 'กรุณากรอกอีเมลให้ถูกต้อง';
                }
                return null; // ถ้าไม่มีปัญหา
              }),
        ),
      ],
    );
  }
}
