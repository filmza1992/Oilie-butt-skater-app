import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';

class RoomEmpty extends StatelessWidget {
  const RoomEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 85,
          ),
          Container(
            width: 150, // กำหนดขนาดของวงกลม
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black, // สีพื้นหลังของวงกลม
              border: Border.all(
                color: Colors.white, // ขอบสีขาวรอบวงกลม
                width: 3,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.meeting_room_outlined,
                size: 95, // ขนาดของไอคอน
                color: Colors.white, // สีของไอคอน
              ),
            ),
          ),
          const SizedBox(height: 16), // เพิ่มช่องว่างระหว่างไอคอนกับข้อความ
          const TextCustom(
            text: 'ยังไม่มีห้อง', // ข้อความที่จะแสดงด้านล่างไอคอน
            size: 20, // ขนาดฟอนต์
            color: AppColors.textColor, // สีของข้อความ
          ),
        ],
      ),
    );
  }
}
