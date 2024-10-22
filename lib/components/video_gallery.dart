import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoGallery extends StatefulWidget {
  final List<AssetEntity> mediaItems; // เปลี่ยนจาก images เป็น mediaItems เพื่อครอบคลุมวิดีโอ
  final Function(List<AssetEntity> selectedMedia) onMediaSelected;
  final bool isShowButton;
  final Function? updateSelected;

  const VideoGallery({
    super.key,
    required this.mediaItems,
    required this.onMediaSelected,
    required this.isShowButton,
    this.updateSelected,
  });

  @override
  _VideoGalleryState createState() => _VideoGalleryState();
}

class _VideoGalleryState extends State<VideoGallery> {
  final Set<AssetEntity> selectedVideos = {}; // เก็บวิดีโอที่เลือก
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
              
              if (media.type != AssetType.video) return const SizedBox(); // เฉพาะวิดีโอเท่านั้น

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
              final isSelected = selectedVideos.contains(media);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedVideos.remove(media); // ถ้าเลือกแล้ว ให้ลบออก
                    } else {
                      if (selectedVideos.length < 1) { // จำกัดการเลือกที่ 5 วิดีโอ
                        selectedVideos.add(media);
                      } else {
                        Alert().newWarning(context, "ผิดพลาด", "คุณสามารถเลือกได้สูงสุด 1 วิดีโอ");
                      }
                    }

                    if (widget.updateSelected != null) {
                      widget.updateSelected!();
                      widget.onMediaSelected(selectedVideos.toList());
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

                    // แสดงไอคอนวิดีโอ
                    const Positioned(
                      right: 5,
                      bottom: 5,
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                      ),
                    ),
                    
                    // แสดงระยะเวลาวิดีโอ
                    Positioned(
                      left: 5,
                      bottom: 5,
                      child: Text(
                        _formatDuration(media.videoDuration),
                        style: const TextStyle(color: Colors.white),
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
                    if (selectedVideos.isNotEmpty) {
                      widget.onMediaSelected(
                          selectedVideos.toList()); // ส่งวิดีโอที่เลือก
                    } else {
                      // แจ้งเตือนถ้าไม่ได้เลือก
                      Alert().newWarning(context, "ผิดพลาด", "โปรดเลือกวิดีโอก่อน");
                    }
                  },
                  child: const Text('เลือกวิดีโอที่เลือก'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
