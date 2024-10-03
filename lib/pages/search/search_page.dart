import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_search.dart';
import 'package:oilie_butt_skater_app/components/profile_detail.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/response.search_tag.dart';
import 'package:oilie_butt_skater_app/models/response_search_post.dart';
import 'package:oilie_butt_skater_app/models/response_search_profile.dart';
import 'package:oilie_butt_skater_app/pages/post/tag_post_page.dart';
import 'package:oilie_butt_skater_app/pages/profile/target_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.loadMorePosts});

  final Function loadMorePosts;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;

 UserController userController = Get.find<UserController>();
  dynamic user;
  
  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  ValueNotifier<DataSearchUser> dataUser =
      ValueNotifier<DataSearchUser>(DataSearchUser(users: []));

  ValueNotifier<DataSearchPost> dataPost =
      ValueNotifier<DataSearchPost>(DataSearchPost(posts: []));

  ValueNotifier<DataSearchTag> dataTag =
      ValueNotifier<DataSearchTag>(DataSearchTag(tags: []));

  Timer? _debounce;

  void onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel(); // ยกเลิก Timer เก่าถ้ากำลังทำงานอยู่
    }

    // ตั้ง Timer ใหม่เมื่อมีการเปลี่ยนแปลงข้อความ
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filter(text); // ยิงคำขอค้นหาเมื่อครบกำหนดเวลา 500ms
    });
  }

  Future<void> filter(String text) async {
    if (text == '') {
      return;
    }
    if (_tabController.index == 0) {
      try {
        final d = await ApiSearch.getUsers(text);
        setState(() {
          dataUser.value = d;
        });
      } catch (e) {
        print('Error fetching tag post: $e');
      }
    } else {
      try {
        final d = await ApiSearch.getTags(text);
        setState(() {
          dataTag.value = d;
        });
      } catch (e) {
        print('Error fetching tag post: $e');
      }
    }
  }

  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      onSearchChanged(searchQuery.value);
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      searchQuery.value = searchController.text;
      onSearchChanged(searchQuery.value);
    });

     user = userController.user.value;
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
                  onChanged: onSearchChanged,
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
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: dataUser,
                    builder: (context, value, child) {
                      return Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: dataUser.value.users.length,
                            itemBuilder: (context, index) {
                              final user = dataUser.value.users[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(TargetProfilePage(
                                    user: user,
                                    loadMorePosts: widget.loadMorePosts,
                                  ));
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: dataTag,
                    builder: (context, value, child) {
                      return Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: dataTag.value.tags.length,
                            itemBuilder: (context, index) {
                              final tag = dataTag.value.tags[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(TagPostPage(tag: tag.tag,loadMorePosts: widget.loadMorePosts,));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: TextCustom(
                                      size: 15,
                                      text: tag.tag,
                                      color: AppColors.textColor,
                                    ),
                                    subtitle: TextCustom(
                                      size: 13,
                                      text: tag.tag,
                                      color: AppColors.textColor,
                                    ),
                                    leading: const TextCustom(
                                      text: "#",
                                      size: 23,
                                      color: AppColors.textColor,
                                    ),
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
          ],
        ));
  }
}
