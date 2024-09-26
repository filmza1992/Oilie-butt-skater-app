import 'package:firebase_database/firebase_database.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class ApiRoom {
  static Future<List<ChatRoom>> getChatRooms(User user, updateMessage) async {
    try {
      final DatabaseReference chatRoomsRef =
          FirebaseDatabase.instance.ref().child('chat_rooms');

      final List<ChatRoom> chatRooms = [];

      chatRoomsRef.onValue.listen((event) {
        chatRooms.clear();
        final dynamic data = event.snapshot.value;
        print("get room");
        if (data != null) {
          data.forEach((key, value) {
            dynamic users = value['users'];

            // Check if the current user is in this chat room
            bool isUserInRoom =
                users.any((userMap) => userMap['user_id'] == user.userId);

            List<dynamic> messages = [];
            if (value['messages'] != null) {
              messages = value['messages'];
            }

            String lastMessage = "";
            if (messages.isNotEmpty) {
              if (messages.last['text'] != null) {
                lastMessage = messages.last['text'];
              } else if (messages.last['url'] != null) {
                lastMessage = 'ได้ส่งรูปภาพ';
              }
            } else {
              lastMessage = 'แชทใหม่ข้อความเลย';
            }

            final target = users
                .where((userMap) => userMap['user_id'] != user.userId)
                .first;

            if (isUserInRoom) {
              ChatRoom chatRoom = ChatRoom(
                value['chat_room_id'],
                value['users'],
                value['messages'],
                value['update_at'],
                value['create_at'],
                lastMessage,
                target,
              );
              chatRooms.add(chatRoom);
            }
          });
        }
        chatRooms.sort((a, b) =>
            DateTime.parse(b.updateAt).compareTo(DateTime.parse(a.updateAt)));
        updateMessage(chatRooms);
      });

      return chatRooms;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<ChatRoom> getChatRoomsWithUser(
      String userId, String targetId) async {
    try {
      final DatabaseReference userRoomsRef =
          FirebaseDatabase.instance.ref().child('user_rooms').child(userId);

      final DataSnapshot snapshot = await userRoomsRef.get();

      List<String> chatRooms = [];

      if (snapshot.exists) {
        for (var room in snapshot.children) {
          chatRooms.add(room.key!); // ดึง chat_room_id
        }
      }
      List<String> rooms = chatRooms;
      ChatRoom chatRoom = ChatRoom("", "", "", "", "", "", "");
      if (rooms.isNotEmpty) {
        for (var roomId in rooms) {
          final DatabaseReference roomRef =
              FirebaseDatabase.instance.ref().child('chat_rooms/$roomId');

          final DataSnapshot snapshot = await roomRef.get();
          if (snapshot.value != null) {
            Map<dynamic, dynamic> room =
                snapshot.value as Map<dynamic, dynamic>;

            // users จะเป็น List<dynamic> ดังนั้นเราต้องแปลงมันเป็น List
            List<dynamic> users = room['users'] as List<dynamic>;

            // ใช้ for loop เพื่อหา user_id ที่ต้องการ
            bool found = false;
            for (var user in users) {
              if (user['user_id'] == targetId) {
                found = true;
                break;
              }
            }

            // ตรวจสอบว่าพบ user_id ที่ตรงหรือไม่ และเช็คว่ามีผู้ใช้ในห้องเท่ากับ 2 คน
            if (found && users.length == 2) {
              final target =
                  users.where((userMap) => userMap['user_id'] != userId).first;
              chatRoom = ChatRoom(
                room['chat_room_id'],
                room['users'],
                room['messages'],
                room['update_at'],
                room['create_at'],
                "",
                target,
              );
              print(chatRoom.chatRoomId);
              print("Found room with user: $targetId and total 2 users.");
            } else {
              print(
                  "User not found in this room or room doesn't have 2 users.");
            }
          }
        }

        // Return หรือดำเนินการต่อถ้าไม่เจอห้อง
        return chatRoom;
      } else {
        print('User is not in any chat rooms.');
        return ChatRoom("", "", "", "", "", "", "");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> sendMessageText(
      String roomId, String userId, String messageText) async {
    try {
      final DatabaseReference messagesRef =
          FirebaseDatabase.instance.ref().child('chat_rooms/$roomId/messages');

      // Fetch the current messages array
      final DataSnapshot snapshot = await messagesRef.get();
      List<dynamic> messagesList = [];

      if (snapshot.value != null) {
        messagesList = snapshot.value as List<dynamic>;
      }

      messagesList = List.from(messagesList);
      // Create a new message object
      Map<String, dynamic> messageData = {
        'create_at': DateTime.now().toIso8601String(),
        'text': messageText,
        'type': 1, // Assuming type 1 is for text messages
        'user_id': userId,
      };

      // Append the new message to the array
      messagesList.add(messageData);

      // Update the messages array in Firebase
      await messagesRef.set(messagesList);
      final DatabaseReference roomRef =
          FirebaseDatabase.instance.ref().child('chat_rooms/$roomId');

      roomRef.update({
        "update_at": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }
}
