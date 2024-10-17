import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoGallery extends StatefulWidget {
  final List<AssetEntity> mediaItems; // เปลี่ยนจาก images เป็น mediaItems เพื่อครอบคลุมภาพและวิดีโอ
  final Function(List<AssetEntity> selectedMedia) onMediaSelected;
  final bool isShowButton;
  final Function? updateSelected;

  const PhotoGallery({
    super.key,
    required this.mediaItems,
    required this.onMediaSelected,
    required this.isShowButton,
    this.updateSelected,
  });

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final Set<AssetEntity> selectedMedia = {}; // เก็บทั้งรูปภาพและวิดีโอที่เลือก
  final Map<String, Uint8List?> _thumbnailsCache = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: widget.mediaItems.length,
            itemBuilder: (context, index) {
              final media = widget.mediaItems[index];
              if (!_thumbnailsCache.containsKey(media.id)) {
                _thumbnailsCache[media.id] = null;
                media
                    .thumbnailDataWithSize(const ThumbnailSize(200, 200))
                    .then((data) {
                  setState(() {
                    _thumbnailsCache[media.id] = data;
                  });
                });
              }

              final thumbnailData = _thumbnailsCache[media.id];
              final isSelected = selectedMedia.contains(media);
              final isVideo = media.type == AssetType.video; // ตรวจสอบว่าเป็นวิดีโอหรือไม่

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedMedia.remove(media); // ถ้าเลือกแล้ว ให้ลบออก
                    } else {
                      if (selectedMedia.length < 10) {
                        selectedMedia.add(media); // ถ้ายังไม่เลือก ให้เพิ่มเข้าไป
                      } else {
                        // แสดงข้อความเตือนว่าถึงจำนวนสูงสุดแล้ว
                        Alert().newWarning(context, "ผิดพลาด", "คุณสามารถเลือกได้สูงสุด 10 รายการ");
                      }
                    }

                    if (widget.updateSelected != null) {
                      widget.updateSelected!();
                      widget.onMediaSelected(selectedMedia.toList());
                    }
                  });
                },
                child: Stack(
                  children: [
                    if (thumbnailData != null)
                      Positioned.fill(
                        child: Image.memory(
                          thumbnailData,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                    
                    // แสดงไอคอนกล้องถ้าเป็นวิดีโอ
                    if (isVideo)
                      const Positioned(
                        right: 5,
                        bottom: 5,
                        child: Icon(
                          Icons.videocam,
                          color: Colors.white,
                        ),
                      ),
                    
                    if (isSelected)
                      const Positioned(
                        right: 5,
                        top: 5,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        if (widget.isShowButton)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedMedia.isNotEmpty) {
                      widget.onMediaSelected(
                          selectedMedia.toList()); // ส่งรายการที่เลือก
                    } else {
                      // แจ้งเตือนถ้าไม่ได้เลือก
                      Alert().newWarning(context, "ผิดพลาด", "โปรดเลือกรายการก่อน");
                    }
                  },
                  child: const Text('เลือกรายการที่เลือก'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
