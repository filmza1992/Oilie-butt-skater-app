import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';

class TagText extends StatefulWidget {
  final String postText;

  const TagText({super.key, required this.postText});

  @override
  _TagTextState createState() => _TagTextState();
}

class _TagTextState extends State<TagText> {
  bool _isExpanded = false; // ควบคุมสถานะการแสดงข้อความ

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // สร้างข้อความทั้งหมดสำหรับวัดขนาด
        final TextSpan fullTextSpan = TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: _buildTextSpans(widget.postText),
        );

        // ใช้ TextPainter เพื่อวัดความสูงของข้อความ
        final TextPainter textPainter = TextPainter(
          text: fullTextSpan,
          maxLines:
              _isExpanded ? null : 2, // จำกัดบรรทัดถ้ายังไม่กด 'เพิ่มเติม'
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        // ถ้าข้อความเกิน 2 บรรทัด จะแสดงปุ่มเพิ่มเติม
        final bool overflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: fullTextSpan,
                    maxLines: _isExpanded ? null : 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (overflow)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'ย่อ' : '...เพิ่มเติม',
                      style: GoogleFonts.kanit(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 140, 138, 138),
                      ),
                    ),
                  ),
              ],
            )
          ],
        );
      },
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp tagRegExp = RegExp(r'(#[\wก-๙]+)');
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(text);
    int start = 0;

    for (final match in matches) {
      // เพิ่มข้อความก่อนหน้าที่ไม่ใช่แท็ก
      if (match.start > start) {
        log(text.substring(start));
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: GoogleFonts.kanit(
            fontSize: 15,
            color: AppColors.textColor,
          ),
        ));
      }

      // เพิ่มข้อความที่เป็นแท็กและเปลี่ยนสี
      final String tag = match.group(0)!;
      spans.add(TextSpan(
        text: tag,
        style: GoogleFonts.kanit(
          fontSize: 15,
          color: Colors.blue,
        ),
      ));

      start = match.end;
    }

    // เพิ่มข้อความหลังแท็กสุดท้าย (ถ้ามี)
    if (start < text.length) {
      log(text.substring(start));
      spans.add(TextSpan(
        text: text.substring(start),
        style: GoogleFonts.kanit(
          fontSize: 15,
          color: AppColors.textColor,
        ),
      ));
    }

    return spans;
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: TagText(
            postText:
                "โพสต์นี้มี #แท็ก1 และ #tag2 อยู่ในข้อความ โพสต์นี้ยาวมากๆ เพื่อให้เราสามารถทดสอบปุ่มเพิ่มเติมได้อย่างเต็มที่",
          ),
        ),
      ),
    ),
  ));
}
