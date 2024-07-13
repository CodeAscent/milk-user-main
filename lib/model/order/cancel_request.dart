class CancelRequest {
  CancelRequest({
    this.id,
    this.userId,
    this.orderId,
    this.refundAmount,
    this.refundStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? orderId;
  int? refundAmount;
  int? refundStatus;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CancelRequest.fromJson(Map<String, dynamic> json) => CancelRequest(
    id: json["id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    refundAmount: json["refund_amount"],
    refundStatus: json["refund_status"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_id": orderId,
    "refund_amount": refundAmount,
    "refund_status": refundStatus,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}