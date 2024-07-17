// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['post_id'],
      json['username'],
      json['user_image'],
      json['title'] as String,
      json['user_id'] as String,
      (json['type'] as num).toInt(),
      json['tag'] as String,
      json['create_at'],
      json['content'],
      json['likes'],
      json['dislikes'],
      json['comments']
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'title': instance.title,
      'user_id': instance.userId,
      'type': instance.type,
      'tag': instance.tag,
      'create_at': instance.createAt,
      'content': instance.content,
    };
