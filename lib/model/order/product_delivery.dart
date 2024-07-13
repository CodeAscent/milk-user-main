import 'package:water/Utils/display_format.dart';

import 'order.dart';

class ProductDelivery {
  ProductDelivery({
    this.id,
    this.userId,
    this.orderId,
    this.productOrderId,
    this.productId,
    this.deliveryDate,
    this.orderStatusId,
    this.createdAt,
    this.updatedAt,
    this.deliveryStatus,
  });

  int? id;
  int? userId;
  int? orderId;
  int? productOrderId;
  int? productId;
  DateTime? deliveryDate;
  int? orderStatusId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Status? deliveryStatus;

  factory ProductDelivery.fromJson(Map<String, dynamic> json) => ProductDelivery(
    id: json["id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    productOrderId: json["product_order_id"],
    productId: json["product_id"],
    deliveryDate: DateTime.parse(json["delivery_date"]),
    orderStatusId: json["order_status_id"],
    createdAt: json["created_at"] !=null? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] !=null? DateTime.parse(json["updated_at"]) : null,
    deliveryStatus: Status.fromJson(json["delivery_status"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_id": orderId,
    "product_order_id": productOrderId,
    "product_id": productId,
    "delivery_date": deliveryDate?.toIso8601String(),
    "order_status_id": orderStatusId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "delivery_status": deliveryStatus?.toJson(),
  };

  getDeliveryDateString() {
    return getDayFormat(this.deliveryDate, ddMMYYYYFormat);
  }
}