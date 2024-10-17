import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response_ranking.dart';

class CardRanking extends StatefulWidget {
  const CardRanking({super.key, required this.user});

  final Top5Ranking user;
  @override
  State<CardRanking> createState() => _CardRankingState();
}

class _CardRankingState extends State<CardRanking> {
  UserController userController = Get.find<UserController>();
  dynamic user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = userController.user.value;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.backgroundColor,
          border: Border.all(
            color: const Color.fromARGB(255, 98, 98, 98),
            width: 2,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: widget.user.imageUrl != ""
                ? NetworkImage(widget.user.imageUrl)
                : const NetworkImage(
                    'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
            radius: 19,
          ),
          title: Row(
            children: [
              // ใช้ Image.network เพื่อแสดงภาพ
              TextCustom(
                text: widget.user.rank.toString(),
                size: 15,
                color: widget.user.userId == user.userId
                    ? AppColors.secondaryColor
                    : AppColors.textColor,
              ),
              const SizedBox(width: 30), // ช่องว่างระหว่างรูปภาพกับชื่อ
              TextCustom(
                text: widget.user.username,
                size: 15,
                color: widget.user.userId == user.userId
                    ? AppColors.secondaryColor
                    : AppColors.textColor,
              ),
            ],
          ),
          trailing: TextCustom(
            text: widget.user.totalLikes,
            size: 15,
            color: widget.user.userId == user.userId
                ? AppColors.secondaryColor
                : AppColors.textColor,
          ),
        ),
      ),
    );
  }
}
