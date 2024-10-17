import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PostImageSlider extends StatefulWidget {
  final List<String> content; // รายการ URL ของภาพ

  const PostImageSlider({super.key, required this.content});

  @override
  _PostImageSliderState createState() => _PostImageSliderState();
}

class _PostImageSliderState extends State<PostImageSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0; // เพื่อเก็บสถานะของหน้า

  @override
  void initState() {
    super.initState();
    // ฟังการเปลี่ยนหน้าใน PageView
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.round(); // อัปเดตหน้าที่กำลังแสดง
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300, // กำหนดความสูงให้กับภาพ (ปรับได้ตามต้องการ)
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.content.length, // จำนวนภาพในโพสต์
            itemBuilder: (context, index) {
              return Image.network(
                widget.content[index], // ใช้ index เพื่อดึงภาพจาก List
                fit: BoxFit.cover, // ปรับให้พอดีกับพื้นที่
              );
            },
          ),

          // จุดบอกตำแหน่ง
          Positioned(
            bottom: 10, // ระยะห่างจากด้านล่าง
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller:
                    _controller, // กำหนด controller ให้กับ SmoothPageIndicator
                count: widget.content.length, // จำนวนจุดที่ต้องแสดง
                effect: const WormEffect(
                  activeDotColor:
                      AppColors.secondaryColor, // สีของจุดที่กำลังแสดง
                  dotColor: Colors.grey, // สีของจุดที่ไม่ได้แสดง
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
