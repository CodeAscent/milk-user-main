class Status {
  Status({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    status: json["status"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status, 
    // "created_at": createdAt?.toIso8601String(),
    // "updated_at": updatedAt?.toIso8601String(),
  };
}