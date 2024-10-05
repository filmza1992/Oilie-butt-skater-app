
class Room {
    int roomId;
    String userId;
    String name;
    String detail;
    String imageUrl;
    String latitude;
    String longitude;
    DateTime dateTime;
    int status;
    DateTime createAt;

    Room({
        required this.roomId,
        required this.userId,
        required this.name,
        required this.detail,
        required this.imageUrl,
        required this.latitude,
        required this.longitude,
        required this.dateTime,
        required this.status,
        required this.createAt,
    });

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomId: json["room_id"],
        userId: json["user_id"],
        name: json["name"],
        detail: json["detail"],
        imageUrl: json["image_url"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        dateTime: DateTime.parse(json["date_time"]),
        status: json["status"],
        createAt: DateTime.parse(json["create_at"]),
    );

    Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "user_id": userId,
        "name": name,
        "detail": detail,
        "image_url": imageUrl,
        "latitude": latitude,
        "longitude": longitude,
        "date_time": dateTime.toIso8601String(),
        "status": status,
        "create_at": createAt.toIso8601String(),
    };
}