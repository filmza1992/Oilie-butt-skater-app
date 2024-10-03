// To parse this JSON data, do
//
//     final tag = tagFromJson(jsonString);

import 'dart:convert';

Tag tagFromJson(String str) => Tag.fromJson(json.decode(str));

String tagToJson(Tag data) => json.encode(data.toJson());


class Tag {
    String tag;
    int count;

    Tag({
        required this.tag,
        required this.count,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tag: json["tag"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "count": count,
    };
}
