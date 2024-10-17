import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatefulWidget {
  TextFieldCustom(
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
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
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
                contentPadding: widget.edgeInsets ??
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                prefixIcon: widget.prefixIcon, // ไอคอนทางซ้าย
                suffixIcon: widget.suffixIcon, // ไอคอนทางขวา),
                errorText: widget.errorText,
              ),
              textAlign: widget.textAlign ?? TextAlign.start,
              style: GoogleFonts.kanit(
                fontSize: 16,
              ),
              onChanged: (String value) {},
              validator: widget.validator),
        ),
      ],
    );
  }
}
