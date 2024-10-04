// To parse this JSON data, do
//
//     final responseRanking = responseRankingFromJson(jsonString);

import 'dart:convert';

ResponseRanking responseRankingFromJson(String str) =>
    ResponseRanking.fromJson(json.decode(str));

String responseRankingToJson(ResponseRanking data) =>
    json.encode(data.toJson());

class ResponseRanking {
  String message;
  DataRanking data;

  ResponseRanking({
    required this.message,
    required this.data,
  });

  factory ResponseRanking.fromJson(Map<String, dynamic> json) =>
      ResponseRanking(
        message: json["message"],
        data: DataRanking.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class DataRanking {
  List<Top5Ranking> top5Rankings;
  UserRanking userRanking;
  String month;

  DataRanking({
    required this.top5Rankings,
    required this.userRanking,
    required this.month,
  });

  factory DataRanking.fromJson(Map<String, dynamic> json) => DataRanking(
        top5Rankings: List<Top5Ranking>.from(
            json["top_5_rankings"].map((x) => Top5Ranking.fromJson(x))),
        userRanking: UserRanking.fromJson(json["user_ranking"]),
        month: json["month"],
      );

  Map<String, dynamic> toJson() => {
        "top_5_rankings":
            List<dynamic>.from(top5Rankings.map((x) => x.toJson())),
        "user_ranking": userRanking.toJson(),
        "month": month,
      };
}

class Top5Ranking {
  int rank;
  String userId;
  String username;
  String totalLikes;
  String imageUrl;

  Top5Ranking(
      {required this.rank,
      required this.userId,
      required this.username,
      required this.totalLikes,
      required this.imageUrl});

  factory Top5Ranking.fromJson(Map<String, dynamic> json) => Top5Ranking(
      rank: json["rank"],
      userId: json["user_id"],
      username: json["username"],
      totalLikes: json["total_likes"],
      imageUrl: json['image_url']);

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "user_id": userId,
        "username": username,
        "total_likes": totalLikes,
        "image_url": imageUrl
      };
}

class UserRanking {
  String username;
  String rankPosition;
  String totalLikes;
  String imageUrl;

  UserRanking({
    required this.username,
    required this.rankPosition,
    required this.totalLikes,
    required this.imageUrl
  });

  factory UserRanking.fromJson(Map<String, dynamic> json) => UserRanking(
        username: json["username"],
        rankPosition: json["rank_position"],
        totalLikes: json["total_likes"],
        imageUrl: json['image_url']
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "rank_position": rankPosition,
        "total_likes": totalLikes,
        "image_url": imageUrl
      };
}
