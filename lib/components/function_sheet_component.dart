import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/button_custom.dart';
import 'package:oilie_butt_skater_app/components/map_message.dart';
import 'package:oilie_butt_skater_app/components/photo_gallery_nomal.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:photo_manager/photo_manager.dart';

class FunctionBottomSheetContent extends StatefulWidget {
  final List<AssetEntity> images;
  final Function onImageSelected;
  final String roomId;
  const FunctionBottomSheetContent({
    super.key,
    required this.images,
    required this.onImageSelected,
    required this.roomId,
  });

  @override
  _FunctionBottomSheetContentState createState() =>
      _FunctionBottomSheetContentState();
}

class _FunctionBottomSheetContentState
    extends State<FunctionBottomSheetContent> {
  bool isGalleryMode = true; // ตัวแปรสำหรับตรวจสอบโหมด

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ButtonCustom(
                  backgroundColor: AppColors.secondaryColor,

                  text: "",
                  onPressed: () =>
                      _changeMode(true), // เปลี่ยนไปที่โหมดแกลเลอรี
                  type: isGalleryMode ? "Elevated" : "Outlined",
                  icon: Icons.image,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ButtonCustom(
                  text: "",
                  onPressed: () => _changeMode(false), // เปลี่ยนไปที่โหมดแผนที่
                  icon: Icons.pin_drop,
                  type: !isGalleryMode ? "Elevated" : "Outlined",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: isGalleryMode
              ? PhotoGalleryNomal(
                  images: widget.images,
                  onImageSelected: (selectedImage) {
                    // จัดการรูปภาพที่เลือกแล้ว
                    widget.onImageSelected(selectedImage);
                    Navigator.pop(context);
                  },
                  isShowButton: true,
                )
              : _buildMapView(), // แสดงแผนที่เมื่ออยู่ในโหมดแผนที่
        ),
      ],
    );
  }

  void _changeMode(bool isGallery) {
    setState(() {
      isGalleryMode = isGallery; // เปลี่ยนสถานะโหมด
    });
  }

  // ส่วนการแสดงแผนที่ (mock up)
  Widget _buildMapView() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[300],
            child: Center(
                child: MapMessage(
              roomId: widget.roomId,
            )),
          ),
        ),
      ],
    );
  }
}
