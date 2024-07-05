import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  final num id;
  final String firstName;
  final String lastName;
  final String user;
  final String password;
  final String phone;
  final String image;
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.user,
      required this.password,
      required this.image,
      required this.phone,
      
      });
}
