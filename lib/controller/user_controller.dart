import 'package:get/get.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class UserController extends GetxController {
  var user = User(
    id: '',
    username: '',
    email: '',
    password: '',
    imageUrl: '',
    birthDay: '',
    createAt: '', 
  ).obs;
  void updateUser(User newUser) {
    user.value = newUser;
  }

  // Add other methods as needed
}
