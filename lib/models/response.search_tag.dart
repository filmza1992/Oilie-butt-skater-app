// To parse this JSON data, do
//
//     final responseSearchTag = responseSearchTagFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/tag_model.dart';

ResponseSearchTag responseSearchTagFromJson(String str) => ResponseSearchTag.fromJson(json.decode(str));

String responseSearchTagToJson(ResponseSearchTag data) => json.encode(data.toJson());

class ResponseSearchTag {
    String message;
    DataSearchTag data;

    ResponseSearchTag({
        required this.message,
        required this.data,
    });

    factory ResponseSearchTag.fromJson(Map<String, dynamic> json) => ResponseSearchTag(
        message: json["message"],
        data: DataSearchTag.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class DataSearchTag {
    List<Tag> tags;
  

    DataSearchTag({
        required this.tags,
    });

    factory DataSearchTag.fromJson(Map<String, dynamic> json) => DataSearchTag(
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    };
}
