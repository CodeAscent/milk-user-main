class OrderPayment {
  OrderPayment({
    this.id,
    this.price,
    this.description,
    this.userId,
    this.status,
    this.method,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  double? price;
  String? description;
  int? userId;
  String? status;
  String? method;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory OrderPayment.fromJson(Map<String, dynamic> json) => OrderPayment(
    id: json["id"],
    price: json["price"].toDouble(),
    description: json["description"],
    userId: json["user_id"],
    status: json["status"],
    method: json["method"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "description": description,
    "user_id": userId,
    "status": status,
    "method": method,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}