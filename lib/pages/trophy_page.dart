import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_ranking.dart';
import 'package:oilie_butt_skater_app/components/background/rankingBackground.dart';
import 'package:oilie_butt_skater_app/components/ranking_table.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response_ranking.dart';

class TrophyPage extends StatefulWidget {
  const TrophyPage({super.key});

  @override
  State<TrophyPage> createState() => _TrophyPageState();
}

class _TrophyPageState extends State<TrophyPage> {
  ValueNotifier<UserRanking> dataUser = ValueNotifier<UserRanking>(UserRanking(
      username: "", rankPosition: "", totalLikes: "", imageUrl: ''));
  ValueNotifier<List<Top5Ranking>> dataTop5 =
      ValueNotifier<List<Top5Ranking>>([]);
  String month = "";

  UserController userController = Get.find<UserController>();

  dynamic user;
  bool _isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();

  void _loadMorePosts() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      // เรียกฟังก์ชันเพื่อโหลดโพสต์เพิ่มเติม
      Future.delayed(const Duration(seconds: 1), () {
        // เรียกฟังก์ชันเพื่อโหลดโพสต์เพิ่มเติม
        fetchData(); // โหลดโพสต์ใหม่

        setState(() {
          _isLoadingMore = false; // เมื่อโหลดเสร็จแล้ว ตั้งค่าเป็นไม่กำลังโหลด
        });

        print("การโหลดเพิ่มเติมเสร็จสิ้น");
      });
    }
  }

  void fetchData() async {
    dataUser.value = UserRanking(
        username: "", rankPosition: "", totalLikes: "", imageUrl: '');
    dataTop5.value.clear();
    try {
      final result = await ApiRanking.getRankingPostPopular(
          userController.user.value.userId);
      //final fetchedPosts =

      setState(() {
        dataTop5.value = result.top5Rankings;
        dataUser.value = result.userRanking;
        month = result.month;
      });
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
  }

  Future<void> _refreshPosts() async {
    // ฟังก์ชันเพื่อรีเฟรชโพสต์ (pull to refresh)
    print("refreshPost");
    _loadMorePosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMorePosts();

    user = userController.user.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: dataTop5,
        builder: (context, value, child) {
          return RefreshIndicator(
            onRefresh: _refreshPosts,
            child: ListView(
              controller: _scrollController,
              children: [
                Rankingbackground(
                  amount: dataUser.value.totalLikes,
                  month: month,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 20),
                    child: RankingTable(
                      text: "Popular Player",
                      users: dataTop5.value,
                      user: dataUser.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
