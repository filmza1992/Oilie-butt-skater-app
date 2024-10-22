import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GridPostItem extends StatelessWidget {
  final String contentUrl; // URL ของวิดีโอหรือภาพ
  final bool isVideo; // ตรวจสอบว่าเป็นวิดีโอหรือภาพ

  const GridPostItem(
      {super.key, required this.contentUrl, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return isVideo
        ? Container(
            decoration: BoxDecoration(
              color: Colors.black, // พื้นหลังสีดำสำหรับพื้นที่ว่าง
              borderRadius:
                  BorderRadius.circular(8), // ปรับมุมให้โค้งถ้าต้องการ
            ),
            child: Center(
              child: AspectRatio(
                aspectRatio:
                    16 / 9, // กำหนดอัตราส่วนของวิดีโอ (สามารถเปลี่ยนได้)
                child: VideoPlayerWidget(contentUrl: contentUrl),
              ),
            ))
        : Ink(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(contentUrl),
                fit: BoxFit.cover, // ภาพจะครอบคลุมเต็มพื้นที่
              ),
            ),
          );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String contentUrl;

  const VideoPlayerWidget({super.key, required this.contentUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.contentUrl)
      ..initialize().then((_) {
        setState(() {}); // เรียกเพื่อ refresh widget หลังจาก video โหลดเสร็จ
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
