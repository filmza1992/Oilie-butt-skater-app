import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/api/api_post.dart';
import 'package:oilie_butt_skater_app/models/post_model.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchPosts(userId) async {
    try {
      var fetchedPosts = await ApiPost.getAllPost(userId);
      posts.assignAll(fetchedPosts);
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }
}
