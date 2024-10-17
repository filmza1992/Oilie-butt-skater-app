// To parse this JSON data, do
//
//     final responseRankingAll = responseRankingAllFromJson(jsonString);

import 'dart:convert';

import 'package:oilie_butt_skater_app/models/response_ranking.dart';

ResponseRankingAll responseRankingAllFromJson(String str) =>
    ResponseRankingAll.fromJson(json.decode(str));

String responseRankingAllToJson(ResponseRankingAll data) =>
    json.encode(data.toJson());

class ResponseRankingAll {
  String message;
  List<DataRankingAll> data;

  ResponseRankingAll({
    required this.message,
    required this.data,
  });

  factory ResponseRankingAll.fromJson(Map<String, dynamic> json) =>
      ResponseRankingAll(
        message: json["message"],
        data: List<DataRankingAll>.from(
            json["data"].map((x) => DataRankingAll.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataRankingAll {
  String month;
  List<Top5Ranking> top5Rankings;
  UserRanking userRanking;

  DataRankingAll({
    required this.month,
    required this.top5Rankings,
    required this.userRanking,
  });

  factory DataRankingAll.fromJson(Map<String, dynamic> json) => DataRankingAll(
        month: json["month"],
        top5Rankings: List<Top5Ranking>.from(
            json["top_5_rankings"].map((x) => Top5Ranking.fromJson(x))),
        userRanking: UserRanking.fromJson(json["user_ranking"]),
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "top_5_rankings":
            List<dynamic>.from(top5Rankings.map((x) => x.toJson())),
        "user_ranking": userRanking.toJson(),
      };
}
