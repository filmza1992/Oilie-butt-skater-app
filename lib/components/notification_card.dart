import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/date.dart';
import 'package:oilie_butt_skater_app/%E0%B8%B5util/subString.dart';
import 'package:oilie_butt_skater_app/api/api_notification.dart';
import 'package:oilie_butt_skater_app/api/api_user.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response.notification.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/post/one_post_page.dart';
import 'package:oilie_butt_skater_app/pages/profile/target_page.dart';

class NotificationCard extends StatefulWidget {
  final DataNotification notify;
  final Function loadMorePosts;

  const NotificationCard(
      {super.key, required this.notify, required this.loadMorePosts});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>  with SingleTickerProviderStateMixin {
  double opacity = 1.0; // สถานะความโปร่งใสของ Card
  bool visible = true;

  UserController userController = Get.find<UserController>();
  dynamic user;

late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    user = userController.user.value;
    _tabController = TabController(length: 2, vsync: this);
  }

  void handleTap() async {
    if (widget.notify.interactionCount != null) {
      await ApiNotification.updatePostInteraction(
          widget.notify.postId.toString());
      // เริ่มการแอนิเมชันให้ Card หายไป
      setState(() {
        opacity = 0.0; // เปลี่ยนความโปร่งใสเป็น 0
      });
      // รอให้การเปลี่ยนแปลงเสร็จสิ้นก่อนลบ Card
      Future.delayed(const Duration(milliseconds: 250), () {
        if (widget.notify.interactionCount != null) {
          setState(() {
            visible = false;
            Get.to(OnePostPage(postId: widget.notify.postId.toString()));
          });
        }
      });
    } else if (widget.notify.followId != null) {
      await ApiNotification.updateFollow(widget.notify.followId.toString());

      User user = await ApiUser.getUserById(widget.notify.userId!);
      // เริ่มการแอนิเมชันให้ Card หายไป
      setState(() {
        opacity = 0.0; // เปลี่ยนความโปร่งใสเป็น 0
      });
      // รอให้การเปลี่ยนแปลงเสร็จสิ้นก่อนลบ Card
      Future.delayed(const Duration(milliseconds: 250), () {
        if (widget.notify.followId != null) {
          setState(() {
            visible = false;
            Get.to(TargetProfilePage(
                user: user, loadMorePosts: widget.loadMorePosts));
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity, // กำหนดความโปร่งใส
      duration:
          const Duration(milliseconds: 250), // ระยะเวลาที่ใช้ในการแอนิเมชัน
      child: visible
          ? GestureDetector(
              onTap: handleTap,
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: widget.notify.interactionCount != null
                              ? Image.asset(
                                  'assets/images/interaction_post.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset(
                                    'assets/images/cool_follow.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (widget.notify.interactionCount != null) ...[
                        TextCustom(
                          text:
                              'โพสต์: ${SubString.truncateString(widget.notify.title ?? "ไม่มีชื่อโพสต์", 20)}',
                          color: AppColors.textColor,
                          size: 16,
                          isBold: true,
                        ),
                        const SizedBox(height: 4),
                        TextCustom(
                            text:
                                'จำนวนคนที่แสดงความรู้สึก: ${widget.notify.interactionCount}',
                            size: 14,
                            color: Colors.grey[600]),
                      ] else if (widget.notify.followId != null) ...[
                        TextCustom(
                          text: 'ผู้ติดตามใหม่: ${widget.notify.username}',
                          color: AppColors.textColor,
                          size: 16,
                          isBold: true,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(
                            text: widget.notify.interactionCount != null
                                ? DateTimeUtil.formatDate(
                                    widget.notify.lastInteractionTime)
                                : DateTimeUtil.formatDate(
                                    widget.notify.createAt),
                            color: Colors.grey[600],
                            size: 14,
                          ),
                          TextCustom(
                            text: widget.notify.interactionCount != null
                                ? DateTimeUtil.formatTime(
                                    widget.notify.lastInteractionTime)
                                : DateTimeUtil.formatTime(
                                    widget.notify.createAt),
                            color: Colors.grey[600],
                            size: 14,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
