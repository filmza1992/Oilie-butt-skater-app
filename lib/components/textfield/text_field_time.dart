import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextFieldTimeCustom extends StatefulWidget {
  TextFieldTimeCustom(
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
      this.validator,
      this.updateDateTime});

  String? label;
  String hint;
  TimeOfDay controller;
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
  Function? updateDateTime;
  @override
  State<TextFieldTimeCustom> createState() => _TextFieldTimeCustomState();
}

class _TextFieldTimeCustomState extends State<TextFieldTimeCustom> {
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final hours = picked.hour.toString().padLeft(2, '0');
        final minutes = picked.minute.toString().padLeft(2, '0');
        _timeController.text = '$hours:$minutes'; // แสดงเวลาในรูปแบบ HH:mm
        // เก็บค่า TimeOfDay ที่เลือก
        print(widget.controller);
        widget.updateDateTime!(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _timeController,
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
              _selectTime(context);
            },
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
