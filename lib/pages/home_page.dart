import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/chat/chat_room.dart';
import 'package:oilie_butt_skater_app/pages/noitfication/notification_page.dart';
import 'package:oilie_butt_skater_app/pages/post/create_post_page.dart';
import 'package:oilie_butt_skater_app/pages/profile/profile_page.dart';
import 'package:oilie_butt_skater_app/pages/room/room_page.dart';
import 'package:oilie_butt_skater_app/pages/search/search_page.dart';
import 'package:oilie_butt_skater_app/pages/trophy_page.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.selectedIndex});
  final int? selectedIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final List<VideoPlayerController> _activeControllers =
      []; // เก็บ controller ที่เล่นอยู่

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.emoji_events),
      label: 'Trophy',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Room',
    ),
    BottomNavigationBarItem(
      icon: Container(
        height: 60.0,
        width: 60.0,
        decoration: const BoxDecoration(
          color: AppColors.secondaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            width: 45, // ปรับขนาดไอคอนที่นี่
            height: 45, // ปรับขนาดไอคอนที่นี่
            child: Image.asset('assets/images/skateboard_home.png',
                fit: BoxFit.contain),
          ),
        ),
      ),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notifications',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    disposeAllVideos();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const Center(child: TrophyPage()),
          const Center(
            child: RoomPage(),
          ),
          Center(child: page()),
          Center(
              child: NotificationPage(
            loadMorePosts: _loadMorePosts,
          )),
          if (_selectedIndex == 4)
            Center(
                child: ProfilePage(
              loadMorePosts: _loadMorePosts,
            )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);
  UserController userController = Get.find<UserController>();

  void update() {
    _loadMorePosts();
  }

  void _loadMorePosts() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      print(_isLoadingMore);
      // เรียกฟังก์ชันเพื่อโหลดโพสต์เพิ่มเติม
      Future.delayed(const Duration(seconds: 1), () {
        // เรียกฟังก์ชันเพื่อโหลดโพสต์เพิ่มเติม
        fetchPosts(); // โหลดโพสต์ใหม่

        setState(() {
          _isLoadingMore = false; // เมื่อโหลดเสร็จแล้ว ตั้งค่าเป็นไม่กำลังโหลด
        });

        print("การโหลดเพิ่มเติมเสร็จสิ้น");
      });
    }
  }

  void fetchPosts() async {
    print('initState');
    posts.value.clear();
    try {
      final newPost = await ApiPost.getFeed(userController.user.value.userId);
      //final fetchedPosts =
      setState(() {
        posts.value = newPost;
      });
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
  }

  Future<void> _refreshPosts() async {
    // ฟังก์ชันเพื่อรีเฟรชโพสต์ (pull to refresh)
    _loadMorePosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    disposeAllVideos();
    super.dispose();
  }

  void disposeAllVideos() {
    // หยุดและ dispose controller ทั้งหมดที่เล่นอยู่
    log("disposeall");
    for (var controller in _activeControllers) {
      log("is playing");
      if (controller.value.isPlaying) {
        log("pause");
        controller.pause();
      }
    }
    _activeControllers.clear(); // ล้างรายการ controller
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 2;
    _loadMorePosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  Widget page() {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchPage(
                              loadMorePosts: _loadMorePosts,
                            )),
                  );
                },
                icon: const Icon(Icons.search)),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatRoomPage()),
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/chatbubble-ellipses-outline.svg',
                fit: BoxFit.cover,
                width: 25,
                height: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: _isLoadingMore
            ? const Center(
                child:
                    CircularProgressIndicator(), // แสดง loading ขณะโหลดข้อมูล
              )
            : Center(
                child: ValueListenableBuilder(
                  valueListenable: posts,
                  builder: (context, value, child) {
                    return RefreshIndicator(
                      onRefresh: _refreshPosts,
                      child: ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          final post = value[index];
                          return PostComponent(
                              key: ValueKey(post),
                              userId: post.userId,
                              postId: post.postId,
                              username: post.username,
                              userImage: post.userImage,
                              postText: post.title,
                              likes: post.likes,
                              dislikes: post.dislikes,
                              comments: post.comments,
                              content: post.content,
                              status: post.status,
                              type: post.type,
                              updateStatus:
                                  (int status, int likes, int dislikes) {
                                setState(() {
                                  post.status = status;
                                  post.likes = likes;
                                  post.dislikes = dislikes;
                                });
                              },
                              user: userController.user.value,
                              onVideoStart: (controller) {
                                _activeControllers.add(
                                    controller); // เพิ่ม controller ที่กำลังเล่นเข้าไปใน list
                              });
                        },
                      ),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the post creation screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePostPage(
                        update: update,
                      )),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/post-add.svg',
                width: 40, // ปรับขนาดไอคอน
                height: 40, // ปรับขนาดไอคอน
              ),
            ),
          ),
        ),
      ),
    );
  }
}
