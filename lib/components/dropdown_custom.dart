import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';

class DropdownCustom extends StatefulWidget {
  const DropdownCustom({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final Function(String?)? onChanged;

  final String value;
  @override
  _DropdownCustomState createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.lightGreen, // สีพื้นหลัง
        borderRadius: BorderRadius.circular(20), // มุมกลม
        border: Border.all(color: Colors.blue, width: 2), // เส้นขอบ
      ),
      child: DropdownButton<String>(
        value: widget.value,
        underline: const SizedBox(), // ซ่อนเส้นใต้ของ Dropdown
        dropdownColor: Colors.lightGreen, // สีพื้นหลังของ dropdown
        icon: const Icon(Icons.arrow_drop_down,
            color: Colors.black), // ไอคอนลูกศร
        items: const [
          DropdownMenuItem(
            value: 'created',
            child: TextCustom(
              text: 'ห้องที่เคยสร้าง',
              size: 15,
            ), // ข้อความใน dropdown
          ),
          DropdownMenuItem(
            value: 'joined',
            child:
                Text('ห้องที่เข้าร่วม', style: TextStyle(color: Colors.black)),
          ),
        ],
        onChanged: widget.onChanged,
        // การจัดแนวให้ข้อความอยู่ตรงกลาง
        selectedItemBuilder: (BuildContext context) {
          return [
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.value == 'created'
                    ? 'ห้องที่เคยสร้าง'
                    : 'ห้องที่เข้าร่วม',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ];
        },
      ),
    );
  }
}
