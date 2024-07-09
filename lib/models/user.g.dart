// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['user_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      imageUrl: json['image_url'] as String,
      birthDay: json['birth_day'] as String,
      createAt: json['create_at'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'image_url': instance.imageUrl,
      'birth_day': instance.birthDay,
      'create_at': instance.createAt,
    };
