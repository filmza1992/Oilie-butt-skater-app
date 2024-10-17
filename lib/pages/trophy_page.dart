import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_ranking.dart';
import 'package:oilie_butt_skater_app/components/background/rankingBackground.dart';
import 'package:oilie_butt_skater_app/components/ranking_table.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response_ranking.dart';
import 'package:oilie_butt_skater_app/models/response_ranking_all.dart';

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

  ValueNotifier<List<DataRankingAll>> dataRankingAll =
      ValueNotifier<List<DataRankingAll>>([]);

  void _loadMorePosts() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      // เรียกฟังก์ชันเพื่อโหลดโพสต์เพิ่มเติม
      Future.delayed(const Duration(seconds: 1), () {
        fetchRankingData();
        setState(() {
          _isLoadingMore = false; // เมื่อโหลดเสร็จแล้ว ตั้งค่าเป็นไม่กำลังโหลด
        });

        print("การโหลดเพิ่มเติมเสร็จสิ้น");
      });
    }
  }

  Future<Map<String, dynamic>> fetchRankingData() async {
    // Fetch user ranking
    final result = await ApiRanking.getRankingPostPopular(
        userController.user.value.userId);
    final allRanking =
        await ApiRanking.getAllRanking(userController.user.value.userId);

    return {
      'userRanking': result.userRanking,
      'top5Rankings': result.top5Rankings,
      'allRanking': allRanking,
      'month': result.month,
    };
  }

  String selectedMonth = "";
  void updateDataForSelectedMonth() {
    // ค้นหา DataRankingAll ที่ตรงกับเดือนที่เลือก
    setState(() {
      if (dataRankingAll.value.isNotEmpty) {
        selectedMonth = dataRankingAll.value.first.month;
      }
    });
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchRankingData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No Data Found'));
          }

          final data = snapshot.data!;
          final userRanking = data['userRanking'] as UserRanking;
          final top5Rankings = data['top5Rankings'] as List<Top5Ranking>;
          final month = data['month'] as String;
          final allRanking = data['allRanking'] as List<DataRankingAll>;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              children: [
                Rankingbackground(
                  amount: userRanking.totalLikes,
                  month: month,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 20),
                    child: RankingTable(
                      text: "Popular Player",
                      users: top5Rankings,
                      user: userRanking,
                      dataRankingAll: allRanking,
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
