import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

Future<String> uploadImageToFirebaseMessage(File imageFile) async {
  String fileName =
      '${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}_${imageFile.path.split('/').last}';

  try {
    final storageRef =
        FirebaseStorage.instance.ref().child("messages/$fileName");
    await storageRef.putFile(imageFile);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading image: $e");
    return '';
  }
}



Future<String> uploadImageToFirebaseRoom(File imageFile) async {
  String fileName =
      '${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}_${imageFile.path.split('/').last}';
  try {
    final storageRef =
        FirebaseStorage.instance.ref().child("room/$fileName");
    await storageRef.putFile(imageFile);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading image: $e");
    return '';
  }
}
Future<String> uploadImageToFirebaseProfile(File imageFile) async {
  String fileName =
      '${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}_${imageFile.path.split('/').last}';
  try {
    final storageRef =
        FirebaseStorage.instance.ref().child("profile/$fileName");
    await storageRef.putFile(imageFile);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading image: $e");
    return '';
  }
}

Future<String> uploadImageToFirebasePost(File imageFile) async {
  String fileName =
      '${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}_${imageFile.path.split('/').last}';

  try {
    final storageRef =
        FirebaseStorage.instance.ref().child("post/$fileName");
    await storageRef.putFile(imageFile);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading image: $e");
    return '';
  }
}


void sendImageMessage(String imageUrl) {
  // Your logic to send the image message, e.g., update Firebase Realtime Database or Firestore
  print("Image uploaded and message sent with URL: $imageUrl");
  // Add your logic here to send the message with the image URL
}