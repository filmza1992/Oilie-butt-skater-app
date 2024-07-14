import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/pages/chat_room.dart';
import 'package:oilie_butt_skater_app/pages/create_post_page.dart';
import 'package:oilie_butt_skater_app/pages/login_page.dart';
import 'package:oilie_butt_skater_app/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
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
          child: Container(
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
          Center(child: Text('Home Page')),
          Center(child: Text('Search Page')),
          Center(child: page()),
          Center(child: Text('Notifications Page')),
          if (_selectedIndex == 4) Center(child: ProfilePage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
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
      body: const Center(
        child: Post(
          username: 'user123',
          postText: 'This is a mockup of an Instagram-like post.',
          likes: 120,
          dislikes: 5,
          comments: 30,
          imageUrl: '',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the post creation screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/icons/post-add.svg',
          ),
        ),
      ),
    );
  }
}
