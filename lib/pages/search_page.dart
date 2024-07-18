import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  UserController userController = Get.find<UserController>();

  List<ChatRoom> filteredChatRooms = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  ValueNotifier<List<ChatRoom>> chatRooms = ValueNotifier<List<ChatRoom>>([]);

  void fetchChatRooms() async {
    try {
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching chat rooms: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterChatRooms(String query) {
    final List<ChatRoom> results = chatRooms.value
        .where((chatRoom) => chatRoom.target['username']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredChatRooms = results;
    });
  }

  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterChatRooms(searchQuery.value);
    });
    _tabController = TabController(length: 2, vsync: this);
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
              child: Expanded(
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
        body: const Column(
          children: [],
        ));
  }
}
