import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextFieldPassword extends StatefulWidget {
  TextFieldPassword({
    key,
    this.label,
    required this.hint,
    required this.controller,
    this.textAlign,
    this.circular,
    this.widthSizedBox,
    this.mainAxisAlignment,
    this.widthText,
    this.edgeInsets,
    this.prefixIcon,
    this.validator,
  });

  String? label;
  String hint;
  TextEditingController controller;
  TextAlign? textAlign;
  double? circular;
  double? widthSizedBox;
  MainAxisAlignment? mainAxisAlignment;
  double? widthText;
  EdgeInsets? edgeInsets;
  Icon? prefixIcon;
  FormFieldValidator<String>? validator;

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          controller: widget.controller,
          obscureText: isObscure,
          obscuringCharacter: '•',
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
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  if (isObscure) {
                    isObscure = false;
                  } else {
                    isObscure = true;
                  }
                });
              },
              child: isObscure
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : const Icon(Icons.remove_red_eye),
            ), // ไอคอนทางขวา),
          ),
          textAlign: widget.textAlign ?? TextAlign.start,
          style: GoogleFonts.kanit(
            fontSize: 16,
          ),
          onChanged: (String value) {},
          validator: widget.validator,
        )),
      ],
    );
  }
}
