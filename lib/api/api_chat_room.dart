import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:oilie_butt_skater_app/api/api_follow.dart';
import 'package:oilie_butt_skater_app/models/chat_room_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

class ApiChatRoom {
  static Future<Map<String, List<ChatRoom>>> getChatRooms(
      User user, updateMessage, setLoading, setSubscription, room) async {
    try {
      final DatabaseReference chatRoomsRef =
          FirebaseDatabase.instance.ref().child('chat_rooms');

      final List<ChatRoom> chatRooms = [];
      final List<ChatRoom> requestRooms = [];
      StreamSubscription chatRoomsSubscription =
          chatRoomsRef.onValue.listen((event) async {
        chatRooms.clear();
        requestRooms.clear();
        final dynamic data = event.snapshot.value;
        print("get room");
        if (data != null) {
          for (var entry in data.entries) {
            var key = entry.key;
            var value = entry.value;
            if (value['type'] == 1) {
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
                if (chatRoom.messages
                    .where((message) => message['user_id'] == user.userId)
                    .isNotEmpty) {
                  print("This room user already chating");
                  chatRooms.add(chatRoom);
                } else if (await ApiFollow.checkFollower(
                    user.userId, target['user_id'], room)) {
                  print("This room user already following");
                  chatRooms.add(chatRoom);
                } else {
                  print("This room is request room");
                  requestRooms.add(chatRoom);
                }
              }
            }
          }

          // Sorting chat rooms and request rooms
          chatRooms.sort((a, b) =>
              DateTime.parse(b.updateAt).compareTo(DateTime.parse(a.updateAt)));
          requestRooms.sort((a, b) =>
              DateTime.parse(b.updateAt).compareTo(DateTime.parse(a.updateAt)));

          // Call updateMessage after all the operations are done
          updateMessage(chatRooms, requestRooms);
          setLoading();
        }
      });
      setSubscription(chatRoomsSubscription);
      return {"chatRooms": chatRooms, "requestRooms": requestRooms};
    } catch (e) {
      throw Exception(e);
    }
  }

  static void verifyChatRoom() {}
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
      ChatRoom chatRoom = ChatRoom("", [], "", "", "", "", "");
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
        return ChatRoom("", [], "", "", "", "", "");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<ChatRoom> getChatRoomsWithChatRoomId(String chatRoomId) async {
    try {
      ChatRoom chatRoom = ChatRoom("", [], "", "", "", "", "");

      final DatabaseReference roomRef =
          FirebaseDatabase.instance.ref().child('chat_rooms/$chatRoomId');

      final DataSnapshot snapshot = await roomRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> chat = snapshot.value as Map<dynamic, dynamic>;

        // users จะเป็น List<dynamic> ดังนั้นเราต้องแปลงมันเป็น List
        dynamic type = chat['type'];

        // ตรวจสอบว่าพบ user_id ที่ตรงหรือไม่ และเช็คว่ามีผู้ใช้ในห้องเท่ากับ 2 คน
        if (type == 2 &&
            chatRoomId == chat['chat_room_id'] &&
            chat['room_id'] != null) {
          chatRoom = ChatRoom(
            chat['chat_room_id'],
            chat['users'],
            chat['messages'],
            chat['update_at'],
            chat['create_at'],
            "",
            "",
          );
          print(chatRoom.chatRoomId);
          print("Found room with user");
        } else {
          print("User not found in this room.");
        }

        // Return หรือดำเนินการต่อถ้าไม่เจอห้อง
        return chatRoom;
      } else {
        print('User is not in any chat rooms.');
        return ChatRoom("", [], "", "", "", "", "");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<ChatRoom> getChatRoomsWithRoomId(String roomId) async {
    try {
      print("get room with roomId: $roomId");
      // สร้าง ChatRoom เปล่าเพื่อใช้ในกรณีที่ไม่เจอ roomId
      ChatRoom chatRoom = ChatRoom("", [], "", "", "", "", "");

      // อ้างอิงไปยังตำแหน่ง 'chat_rooms' ใน Firebase
      final DatabaseReference roomRef =
          FirebaseDatabase.instance.ref().child('chat_rooms/');

      // ดึงข้อมูล snapshot ของ chat_rooms ทั้งหมด
      final DataSnapshot snapshot = await roomRef.get();

      if (snapshot.value != null) {
        // แปลง snapshot เป็น Map
        Map<dynamic, dynamic> chatRooms =
            snapshot.value as Map<dynamic, dynamic>;
        // วนลูปผ่าน chat_rooms ทั้งหมด
        chatRooms.forEach((key, chat) {
          print("key: " + key);
          if (chat is Map &&
              chat['room_id'] != null &&
              chat['room_id'] == roomId) {
            print("room_id: " + chat['room_id']);
            print(chat['messages']);
            // หากเจอ chatRoom ที่ต้องการ ก็สร้าง ChatRoom ขึ้นมา
            chatRoom = ChatRoom(
              chat['chat_room_id'] ?? "",
              chat['users'] ?? [],
              chat['messages'] ?? [],
              chat['update_at'] ?? "",
              chat['create_at'] ?? "",
              "",
              "",
            );
            print("Found chat room with room_id: $roomId");
          }
        });

        // ตรวจสอบว่าเจอห้องหรือไม่
        if (chatRoom.chatRoomId.isNotEmpty) {
          return chatRoom;
        } else {
          print("Room with room_id: $roomId not found.");
          return ChatRoom("", [], "", "", "", "", "");
        }
      } else {
        print('No chat rooms found.');
        return ChatRoom("", [], "", "", "", "", "");
      }
    } catch (e) {
      throw Exception('Error fetching chat rooms: $e');
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

  static Future<String> createRoom(dynamic users, int type) async {
    final DatabaseReference chatRoomsRef =
        FirebaseDatabase.instance.ref().child('chat_rooms');
    String newRoomId = chatRoomsRef.push().key!;

    // เวลาสำหรับ create_at และ update_at
    String currentTime = DateTime.now().toIso8601String();

    // สร้างข้อมูลห้องแชทใหม่
    final ChatRoom newChatRoom =
        ChatRoom(newRoomId, users, [], currentTime, currentTime, "", "");

    // เพิ่มห้องแชทใหม่ลงใน Firebase
    await chatRoomsRef.child(newRoomId).set({
      'chat_room_id': newChatRoom.chatRoomId,
      'create_at': newChatRoom.createAt,
      'update_at': newChatRoom.updateAt,
      'users': users
          .map((user) => {
                'user_id': user['user_id'],
                'username': user['username'],
                'image_url': user['image_url'],
              })
          .toList(),
      'messages': [],
      'type': type,
    });

    for (var user in users) {
      final DatabaseReference chatRoomRef = FirebaseDatabase.instance
          .ref()
          .child('user_rooms/${user['user_id']}');
      final DataSnapshot snapshot = await chatRoomRef.get();
      Map<String, dynamic> chatRooms = {};
      print('in function');
      print(snapshot.value);
      if (snapshot.value != null) {
        chatRooms = Map<String, dynamic>.from(snapshot.value as Map);
        print(chatRooms);
      }

      chatRooms = {...chatRooms, newChatRoom.chatRoomId: true};

      final DatabaseReference userRoomsRef =
          FirebaseDatabase.instance.ref().child('user_rooms/');
      userRoomsRef.update({user['user_id']: chatRooms});
    }

    return newChatRoom.chatRoomId;
  }

  static Future<String> createRoomChatRoom(
      dynamic users, int type, String roomId) async {
    final DatabaseReference chatRoomsRef =
        FirebaseDatabase.instance.ref().child('chat_rooms');
    String newRoomId = chatRoomsRef.push().key!;

    // เวลาสำหรับ create_at และ update_at
    String currentTime = DateTime.now().toIso8601String();

    // สร้างข้อมูลห้องแชทใหม่
    final ChatRoom newChatRoom =
        ChatRoom(newRoomId, users, [], currentTime, currentTime, "", "");

    // เพิ่มห้องแชทใหม่ลงใน Firebase
    await chatRoomsRef.child(newRoomId).set({
      'chat_room_id': newChatRoom.chatRoomId,
      'create_at': newChatRoom.createAt,
      'update_at': newChatRoom.updateAt,
      'users': users
          .map((user) => {
                'user_id': user['user_id'],
                'username': user['username'],
                'image_url': user['image_url'],
              })
          .toList(),
      'messages': [],
      'type': type,
      'room_id': roomId
    });

    for (var user in users) {
      final DatabaseReference chatRoomRef = FirebaseDatabase.instance
          .ref()
          .child('user_rooms/${user['user_id']}');
      final DataSnapshot snapshot = await chatRoomRef.get();
      Map<String, dynamic> chatRooms = {};
      print('in function');
      print(snapshot.value);
      if (snapshot.value != null) {
        chatRooms = Map<String, dynamic>.from(snapshot.value as Map);
        print(chatRooms);
      }

      chatRooms = {...chatRooms, newChatRoom.chatRoomId: true};

      final DatabaseReference userRoomsRef =
          FirebaseDatabase.instance.ref().child('user_rooms/');
      userRoomsRef.update({user['user_id']: chatRooms});
    }

    return newChatRoom.chatRoomId;
  }

  static Future<void> deleteRoom(String roomId, dynamic users) async {
    final DatabaseReference chatRoomsRef =
        FirebaseDatabase.instance.ref().child('chat_rooms/$roomId');

    // 1. ลบข้อมูลห้องแชทออกจาก chat_rooms
    await chatRoomsRef.remove();

    // 2. ลบข้อมูล chat_room_id ของห้องที่ลบออกจาก user_rooms ของผู้ใช้แต่ละคน
    for (var user in users) {
      final DatabaseReference userRoomRef = FirebaseDatabase.instance
          .ref()
          .child('user_rooms/${user['user_id']}/$roomId');

      // ลบ chat_room_id ออกจาก user_rooms ของผู้ใช้
      await userRoomRef.remove();
    }

    print("Room $roomId and related user_room entries have been deleted.");
  }
}
