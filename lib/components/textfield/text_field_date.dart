import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextFieldDateCustom extends StatefulWidget {
  TextFieldDateCustom(
      {super.key,
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
      this.validator});

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
  FormFieldValidator<String>? validator;
  @override
  State<TextFieldDateCustom> createState() => _TextFieldDateCustomState();
}

class _TextFieldDateCustomState extends State<TextFieldDateCustom> {
  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
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
            ),
            textAlign: widget.textAlign ?? TextAlign.start,
            style: GoogleFonts.kanit(
              fontSize: 16,
            ),
            readOnly: true,
            onTap: () {
              selectDate();
            },
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
