import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final Function onPlayPause;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.onPlayPause,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  bool _showControls = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this); // เพิ่ม observer

    // อย่าทำให้เล่นอัตโนมัติใน initState
    widget.controller.addListener(() {
      if (widget.controller.value.isPlaying) {
        // ถ้าวิดีโอกำลังเล่น จะซ่อนปุ่ม play/pause หลังจาก 3 วินาที
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && widget.controller.value.isPlaying) {
            setState(() {
              _showControls = false;
            });
          }
        });
      } else {
        // แสดงปุ่ม play/pause เมื่อวิดีโอหยุด
        setState(() {
          _showControls = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // ลบ observer เมื่อ widget ถูกลบ
    widget.controller.pause(); // หยุดวิดีโอเมื่อ widget ถูกลบ

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // หยุดวิดีโอเมื่อแอปเปลี่ยนสถานะเป็น background หรือ inactive
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
        widget.onPlayPause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 400,
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            ),
          ),
        ),
        // ปุ่มควบคุมแสดงเมื่อวิดีโอหยุด หรือเมื่อแสดง controls
        AnimatedOpacity(
          opacity:
              _showControls || !widget.controller.value.isPlaying ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: Icon(
              widget.controller.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: const Color.fromARGB(255, 0, 0, 0),
              size: 50,
            ),
            onPressed: () {
              widget.onPlayPause();
              setState(() {
                _showControls = true; // แสดงปุ่มเมื่อคลิก
              });
            },
          ),
        ),
      ],
    );
  }
}
