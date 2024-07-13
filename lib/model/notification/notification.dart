class NotificationItem {
  NotificationItem({
    this.id,
    this.langCode,
    this.userId,
    this.image,
    this.title,
    this.message,
    this.readStatus,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? langCode;
  int? userId;
  String? image;
  String? title;
  String? message;
  int? readStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json["id"],
    langCode: json["lang_code"],
    userId: json["user_id"],
    image: json["image"],
    title: json["title"],
    message: json["message"],
    readStatus: json["read_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lang_code": langCode,
    "user_id": userId,
    "image": image,
    "title": title,
    "message": message,
    "read_status": readStatus,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt,
  };
}