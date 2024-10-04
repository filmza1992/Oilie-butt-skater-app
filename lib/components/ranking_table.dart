import 'package:flutter/material.dart';
import 'package:oilie_butt_skater_app/components/card/card_ranking.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/models/response_ranking.dart';

class RankingTable extends StatefulWidget {
  const RankingTable(
      {super.key, required this.text, required this.users, required this.user});

  final String text;
  final List<Top5Ranking> users;
  final UserRanking user;
  @override
  State<RankingTable> createState() => _RankingTableState();
}

class _RankingTableState extends State<RankingTable> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextCustom(
                text: widget.text,
                size: 18,
                color: AppColors.rankingLabelColor,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.backgroundColor,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.backgroundColor,
                      border: Border.all(
                        color: const Color.fromARGB(255, 98, 98, 98),
                        width: 2,
                      ),
                    ),
                    child: const ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        maxRadius: 17,
                      ),
                      title: Row(
                        children: [
                          // ใช้ Image.network เพื่อแสดงภาพ
                          TextCustom(
                            text: "rank",
                            size: 15,
                            color: AppColors.textColor,
                          ),
                          SizedBox(width: 30), // ช่องว่างระหว่างรูปภาพกับชื่อ
                          TextCustom(
                            text: "name",
                            size: 15,
                            color: AppColors.textColor,
                          ),
                        ],
                      ),
                      trailing: TextCustom(
                        text: "score",
                        size: 15,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    // กำหนดความสูงของ ListView
                    height: 340, // คุณสามารถปรับความสูงตามต้องการ
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.users.length,
                      itemBuilder: (context, index) {
                        final user = widget.users[index];
                        return CardRanking(user: user);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.backgroundColor,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                // กำหนดความสูงของ ListView
                height: 68, // คุณสามารถปรับความสูงตามต้องการ
                child: Card(
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
                            text: widget.user.rankPosition.toString(),
                            size: 15,
                            color: AppColors.textColor,
                          ),
                          const SizedBox(
                              width: 30), // ช่องว่างระหว่างรูปภาพกับชื่อ
                          TextCustom(
                            text: widget.user.username,
                            size: 15,
                            color: AppColors.textColor,
                          ),
                        ],
                      ),
                      trailing: TextCustom(
                        text: widget.user.totalLikes,
                        size: 15,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
