import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_notification.dart';
import 'package:oilie_butt_skater_app/components/notification_card.dart';
import 'package:oilie_butt_skater_app/components/notification_empty.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response.notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.loadMorePosts});

  final Function loadMorePosts;
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  UserController userController = Get.find<UserController>();
  dynamic user;

  @override
  void initState() {
    super.initState();
    user = userController.user.value;
  }

  Future<List<DataNotification>> fetchNotifications() async {
    // ดึงข้อมูลจาก API
    final List<DataNotification> data =
        await ApiNotification.getNotification(user.userId);
    return data;
  }

  Future<void> _refreshNotifications() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<DataNotification>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const NotificationEmpty();
          } else {
            final notifications = snapshot.data!;

            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final DataNotification notify = notifications[index];

                  return NotificationCard(
                    notify: notify,
                    loadMorePosts: widget.loadMorePosts,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}