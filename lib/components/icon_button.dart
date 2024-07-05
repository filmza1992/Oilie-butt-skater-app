import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oilie_butt_skater_app/contant/color.dart';

// ignore: must_be_immutable
class IconButtonCustom extends StatefulWidget {
  IconButtonCustom({
    key,
    required this.onPressed,
    required this.icon,
  });

  final Function() onPressed;
  final dynamic icon;
  @override
  State<IconButtonCustom> createState() => _IconButtonCustomState();
}

class _IconButtonCustomState extends State<IconButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundColor,
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Color.fromARGB(255, 60, 61, 62),
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: widget.icon,
            color: Colors.white,
            onPressed: widget.onPressed,
          ),
        ),
      ),
    );
  }
}
