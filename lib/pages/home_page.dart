import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:oilie_butt_skater_app/pages/chat_room.dart';
import 'package:oilie_butt_skater_app/pages/post/create_post_page.dart';
import 'package:oilie_butt_skater_app/pages/profile/profile_page.dart';
import 'package:oilie_butt_skater_app/pages/room_page.dart';
import 'package:oilie_butt_skater_app/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
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
          const Center(child: Text('Trophy')),
          const Center(
              child: Center(
            child: RoomPage(),
          )),
          Center(child: page()),
          const Center(child: Text('Notifications Page')),
          if (_selectedIndex == 4) Center(child: ProfilePage(loadMorePosts: _loadMorePosts,)),
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
      final fetchedPosts =
          await ApiPost.getAllPost(userController.user.value.userId);
      setState(() {
        posts.value = fetchedPosts;
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadMorePosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  Widget page() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
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
              child: CircularProgressIndicator(), // แสดง loading ขณะโหลดข้อมูล
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
                          updateStatus: (int status, int likes, int dislikes) {
                            setState(() {
                              post.status = status;
                              post.likes = likes;
                              post.dislikes = dislikes;
                            });
                          },
                        );
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
                builder: (context) => CreatePostPage(update: update)),
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
    );
  }
}
