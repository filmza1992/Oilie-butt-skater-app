import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_search.dart';
import 'package:oilie_butt_skater_app/components/post.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';
import 'package:video_player/video_player.dart';

class TagPostPage extends StatefulWidget {
  const TagPostPage({
    super.key,
    required this.tag,
    required this.loadMorePosts,
  });
  final String tag;
  final Function loadMorePosts;
  @override
  State<TagPostPage> createState() => _TagPostPageState();
}

class _TagPostPageState extends State<TagPostPage> {
  late ScrollController _scrollController;
  UserController userController = Get.find<UserController>();
  dynamic user;

  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);
  bool _isLoadingMore = false;

  final List<VideoPlayerController> _activeControllers = [];
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
      //final fetchedPosts =
      final d = await ApiSearch.getPosts(widget.tag, user.userId);
      setState(() {
        posts.value = d.posts;
        print(posts.value);
      });
    } catch (e) {
      print('Error fetching post tag: $e');
    }
  }

  Future<void> _refreshPosts() async {
    // ฟังก์ชันเพื่อรีเฟรชโพสต์ (pull to refresh)
    _loadMorePosts();
  }

  @override
  void initState() {
    super.initState();
    // สร้าง ScrollController และเลื่อนไปยัง index ที่ส่งมาเมื่อเริ่มต้น
    _scrollController = ScrollController();
    user = userController.user.value;
    fetchPosts();
  }

  void disposeAllVideos() {
    // หยุดและ dispose controller ทั้งหมดที่เล่นอยู่
    for (var controller in _activeControllers) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
    _activeControllers.clear(); // ล้างรายการ controller
  }

  @override
  void dispose() {
    _scrollController.dispose();
    disposeAllVideos();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("will pop");
        disposeAllVideos();
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              disposeAllVideos();
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
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
                      updateStatus: (int status, int likes, int dislikes) {
                        setState(() {
                          post.status = status;
                          post.likes = likes;
                          post.dislikes = dislikes;
                          widget.loadMorePosts();
                        });
                      },
                      user: userController.user.value,
                      onVideoStart: (controller) {
                        _activeControllers.add(
                            controller); // เพิ่ม controller ที่กำลังเล่นเข้าไปใน list
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
