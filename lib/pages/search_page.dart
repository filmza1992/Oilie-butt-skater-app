import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_search.dart';
import 'package:oilie_butt_skater_app/components/profile_detail.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/response_profile.dart';
import 'package:oilie_butt_skater_app/models/response_search_profile.dart';
import 'package:oilie_butt_skater_app/pages/profile/profile_page.dart';
import 'package:oilie_butt_skater_app/pages/profile/target_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  ValueNotifier<DataSearchUser> data =
      ValueNotifier<DataSearchUser>(DataSearchUser(users: []));

  Future<void> filter(String text) async {
    if (text == '') {
      return;
    }
    if (_tabController.index == 0) {
      try {
        final d = await ApiSearch.getUsers(text);
        setState(() {
          data.value = d;
        });
      } catch (e) {
        print('Error fetching profile post: $e');
      }
    } else {}
  }

  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filter(searchQuery.value);
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      searchQuery.value = searchController.text;
      filter(searchQuery.value);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          actions: [
            SizedBox(
              width: 270,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'ค้นหา',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.textColor,
            unselectedLabelColor: AppColors.textColor,
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.person)),
              Tab(
                  icon: TextCustom(
                text: "#",
                size: 23,
                color: AppColors.textColor,
              )),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: data,
                    builder: (context, value, child) {
                      return Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: data.value.users.length,
                            itemBuilder: (context, index) {
                              final user = data.value.users[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(TargetProfilePage(user: user));
                                },
                                child: Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 0),
                                child: ProfileDetail(
                                  user: user,
                                ),
                              ),
                              );
                         
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),

            // หน้าที่สอง ประวัติการเข้าใช้
            const Center(
              child: Text(
                "History Page", // ข้อความสำหรับแท็บที่สอง
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ));
  }
}
