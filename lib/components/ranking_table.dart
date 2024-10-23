import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/card/card_ranking.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response_ranking.dart';
import 'package:oilie_butt_skater_app/models/response_ranking_all.dart';

class RankingTable extends StatefulWidget {
  const RankingTable(
      {super.key,
      required this.text,
      required this.users,
      required this.user,
      required this.dataRankingAll});

  final String text;
  final List<Top5Ranking> users;
  final UserRanking user;
  final List<DataRankingAll> dataRankingAll;

  @override
  State<RankingTable> createState() => _RankingTableState();
}

class _RankingTableState extends State<RankingTable> {
  String selectedMonth = "";

  UserController userController = Get.find<UserController>();
  dynamic user;
  List<DataRankingAll> dataForSelectedMonth = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = userController.user.value;
    updateDataForSelectedMonth();
  }

  void updateDataForSelectedMonth() {
    // ค้นหา DataRankingAll ที่ตรงกับเดือนที่เลือก
    setState(() {
      if (widget.dataRankingAll.isNotEmpty && selectedMonth == "") {
        selectedMonth = widget.dataRankingAll.first.month;
      }

      dataForSelectedMonth = widget.dataRankingAll
          .where((data) => data.month == selectedMonth)
          .toList();
      log("=========");
      print(dataForSelectedMonth.first.userRanking.rankPosition);
    });
  }

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
                        maxRadius: 4,
                      ),
                      title: Row(
                        children: [
                          // ใช้ Image.network เพื่อแสดงภาพ
                          TextCustom(
                            text: "อันดับ",
                            size: 15,
                            color: AppColors.textColor,
                          ),
                          SizedBox(width: 30), // ช่องว่างระหว่างรูปภาพกับชื่อ
                          TextCustom(
                            text: "ชื่อ",
                            size: 15,
                            color: AppColors.textColor,
                          ),
                        ],
                      ),
                      trailing: TextCustom(
                        text: "คะแนน",
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
          if (widget.user.rankPosition != '0') ...[
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
                              color: AppColors.secondaryColor,
                            ),
                            const SizedBox(
                                width: 30), // ช่องว่างระหว่างรูปภาพกับชื่อ
                            TextCustom(
                              text: widget.user.username,
                              size: 15,
                              color: AppColors.secondaryColor,
                            ),
                          ],
                        ),
                        trailing: TextCustom(
                          text: widget.user.totalLikes,
                          size: 15,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 30),
          if (widget.dataRankingAll.isNotEmpty && selectedMonth != "") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextCustom(
                  text: "ประวัติอันดับความนิยม",
                  size: 18,
                  color: AppColors.rankingLabelColor,
                ),
                if (widget.dataRankingAll.isNotEmpty &&
                    selectedMonth != "") ...[
                  DropdownButton<String>(
                    value: selectedMonth,
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                        updateDataForSelectedMonth();
                      });
                    },
                    items: widget.dataRankingAll
                        .map<DropdownMenuItem<String>>((DataRankingAll value) {
                      return DropdownMenuItem<String>(
                        value: value.month,
                        child: TextCustom(
                          text: value.month,
                          size: 16,
                          color: AppColors.textColor,
                        ),
                      );
                    }).toList(),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 10),
            // ส่วนแสดงการจัดอันดับผู้ใช้
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          maxRadius: 4,
                        ),
                        title: Row(
                          children: [
                            // ใช้ Image.network เพื่อแสดงภาพ
                            TextCustom(
                              text: "อันดับ",
                              size: 15,
                              color: AppColors.textColor,
                            ),
                            SizedBox(width: 30), // ช่องว่างระหว่างรูปภาพกับชื่อ
                            TextCustom(
                              text: "ชื่อ",
                              size: 15,
                              color: AppColors.textColor,
                            ),
                          ],
                        ),
                        trailing: TextCustom(
                          text: "คะแนน",
                          size: 15,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: 340,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataForSelectedMonth.isNotEmpty
                            ? dataForSelectedMonth.first.top5Rankings.length
                            : 0,
                        itemBuilder: (context, index) {
                          final user =
                              dataForSelectedMonth.first.top5Rankings[index];
                          return CardRanking(user: user);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            if (dataForSelectedMonth.isNotEmpty &&
                dataForSelectedMonth.first.userRanking.rankPosition != '0') ...[
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
                    height: 68,
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
                            backgroundImage: dataForSelectedMonth
                                        .first.userRanking.imageUrl !=
                                    ""
                                ? NetworkImage(dataForSelectedMonth
                                    .first.userRanking.imageUrl)
                                : const NetworkImage(
                                    'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                            radius: 19,
                          ),
                          title: Row(
                            children: [
                              TextCustom(
                                text: dataForSelectedMonth
                                    .first.userRanking.rankPosition
                                    .toString(),
                                size: 15,
                                color: AppColors.secondaryColor,
                              ),
                              const SizedBox(width: 30),
                              TextCustom(
                                text: dataForSelectedMonth
                                    .first.userRanking.username,
                                size: 15,
                                color: AppColors.secondaryColor,
                              ),
                            ],
                          ),
                          trailing: TextCustom(
                            text: dataForSelectedMonth
                                .first.userRanking.totalLikes,
                            size: 15,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ]
        ],
      ),
    );
  }
}
