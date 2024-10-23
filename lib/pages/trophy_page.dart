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

  late Future<Map<String, dynamic>>
      _rankingDataFuture; // ใช้เก็บ Future ของ fetch

  void _loadMorePosts() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        fetchRankingData();
        setState(() {
          _isLoadingMore = false;
        });
        print("การโหลดเพิ่มเติมเสร็จสิ้น");
      });
    }
  }

  Future<Map<String, dynamic>> fetchRankingData() async {
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

  @override
  void initState() {
    super.initState();
    user = userController.user.value;
    // เรียก fetch ข้อมูลครั้งแรกใน initState
    _rankingDataFuture = fetchRankingData();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _rankingDataFuture = fetchRankingData(); // เรียก fetch ใหม่ตอน refresh
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        future: _rankingDataFuture, // ใช้ Future ที่เก็บไว้
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
            onRefresh: _refreshPosts, // ใช้ฟังก์ชัน refresh
            child: ListView(
              children: [
                Rankingbackground(
                  amount: userRanking.totalLikes,
                  month: month,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 20),
                    child: RankingTable(
                      text: "อันดับผู้เล่นที่มีความนิยมมากที่สุด",
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
