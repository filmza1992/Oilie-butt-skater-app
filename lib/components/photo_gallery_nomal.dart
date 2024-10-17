import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoGalleryNomal extends StatefulWidget {
  final List<AssetEntity> images;
  final Function(AssetEntity) onImageSelected;
  final bool isShowButton;
  final Function? updateSelected;

  const PhotoGalleryNomal(
      {super.key,
      required this.images,
      required this.onImageSelected,
      required this.isShowButton,
      this.updateSelected});

  @override
  _PhotoGalleryNomalState createState() => _PhotoGalleryNomalState();
}

class _PhotoGalleryNomalState extends State<PhotoGalleryNomal> {
  AssetEntity? selectedImage;
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
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              if (!_thumbnailsCache.containsKey(image.id)) {
                _thumbnailsCache[image.id] = null;
                image
                    .thumbnailDataWithSize(const ThumbnailSize(200, 200))
                    .then((data) {
                  setState(() {
                    _thumbnailsCache[image.id] = data;
                  });
                });
              }

              final thumbnailData = _thumbnailsCache[image.id];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImage = image;

                    if (widget.updateSelected != null) {
                      widget.updateSelected!();
                      widget.onImageSelected(selectedImage!);
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
                    if (selectedImage == image)
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
                    if (selectedImage != null) {
                      widget.onImageSelected(selectedImage!);
                    } else {
                      // แจ้งเตือนถ้าไม่ได้เลือกรูป
                      Alert()
                          .newWarning(context, "ผิดพลาด", "โปรดเลือกรูปก่อน");
                    }
                  },
                  child: const Text('เลือกภาพนี้'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}