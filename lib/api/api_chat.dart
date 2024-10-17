import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'package:oilie_butt_skater_app/models/chat_model.dart';
import 'package:oilie_butt_skater_app/models/user_chat_model.dart';

class ApiChat {
  static Future<dynamic> getMessages(
      String roomId, String userId, updateMessages, setSubscription) async {
    try {
      final messagesRef =
          FirebaseDatabase.instance.ref().child("chat_rooms/$roomId/messages");

      final userRef =
          FirebaseDatabase.instance.ref().child("chat_rooms/$roomId/users");

      // Fetch users in the chat room
      final userMap = [];
      final List<Chat> messageRooms = [];

      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final usersData = userSnapshot.value as List<dynamic>;
        for (var user in usersData) {
          userMap.add(user);
        }
        StreamSubscription messagesSubscription = messagesRef.onValue.listen(
          (event) {
            print("get messages");
            messageRooms.clear();
            final dynamic data = event.snapshot.value;
            if (data != null) {
              data.forEach((value) {
                final messages = value as Map<dynamic, dynamic>;
                final senderId = messages['user_id'];
                final userType = senderId == userId ? 'sender' : 'receiver';

                final userEntry =
                    userMap.where((item) => item['user_id'] == senderId).first;
                if (userEntry.isNotEmpty) {
                  final userMapData = Map<String, dynamic>.from(userEntry);

                  final user = UserChat.fromMap(userMapData);
                  final chatRoom = Chat.fromMap(messages, userType, user);
                  messageRooms.add(chatRoom);
                }
              });
            }
            messageRooms.sort((a, b) => DateTime.parse(b.createAt)
                .compareTo(DateTime.parse(a.createAt)));
            updateMessages(messageRooms);
          },
        );
        setSubscription(messagesSubscription);
        return messageRooms;
      }
    } catch (e) {
      print('Error fetching messages: $e');
      throw Exception('Failed to fetch messages');
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
      print("roomId: $roomId");
      final DatabaseReference roomRef =
          FirebaseDatabase.instance.ref().child('chat_rooms/$roomId');

      roomRef.update({
        "update_at": DateTime.now().toIso8601String(),
        "messages": messagesList
      });
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }

  static Future<void> sendMessageImage(
      String roomId, String userId, String url) async {
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
        'url': url,
        'type': 2, // Assuming type 1 is for text messages
        'user_id': userId,
      };

      // Append the new message to the array
      messagesList.add(messageData);

      // Update the messages array in Firebase
      await messagesRef.set(messagesList);
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }

  static Future<void> sendMessageLocation(
      String roomId, String userId, LatLng location) async {
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
        'latitude': location.latitude,
        'longitude': location.longitude,
        'type': 3, // Assuming type 3 is for location messages
        'user_id': userId,
      };

      // Append the new message to the array
      messagesList.add(messageData);

      // Update the messages array in Firebase
      await messagesRef.set(messagesList);
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }
}
