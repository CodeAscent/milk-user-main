import 'package:water/model/product/product_item.dart';

import 'order.dart';

class ProductOrder {
  ProductOrder({
    this.id,
    this.userId,
    this.orderId,
    this.productId,
    this.quantity,
    this.perItemAmount,
    this.perDeliveryAmount,
    this.totalDeliveryAmount,
    this.noOfDelivery,
    this.orderFrequency,
    this.days,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.productDeliverys,
  });

  int? id;
  int? userId;
  int? orderId;
  int? productId;
  int? quantity;
  int? perItemAmount;
  int? perDeliveryAmount;
  int? totalDeliveryAmount;
  int? noOfDelivery;
  String? orderFrequency;
  String? days;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Product? product;
  List<ProductDelivery>? productDeliverys;

  factory ProductOrder.fromJson(Map<String, dynamic> json) => ProductOrder(
    id: json["id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    perItemAmount: json["per_item_amount"],
    perDeliveryAmount: json["per_delivery_amount"],
    totalDeliveryAmount: json["total_delivery_amount"],
    noOfDelivery: json["no_of_delivery"],
    orderFrequency: json["order_frequency"],
    days: json["days"],
    startDate: json["start_date"] != null ? DateTime.parse(json["start_date"]) : null,
    endDate: json["end_date"] != null ? DateTime.parse(json["end_date"]) : null,
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    product:json["product"] != null ? Product.fromJson(json["product"]) : null,
    productDeliverys: List<ProductDelivery>.from(json["product_deliverys"].map((x) => ProductDelivery.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_id": orderId,
    "product_id": productId,
    "quantity": quantity,
    "per_item_amount": perItemAmount,
    "per_delivery_amount": perDeliveryAmount,
    "total_delivery_amount": totalDeliveryAmount,
    "no_of_delivery": noOfDelivery,
    "order_frequency": orderFrequency,
    "days": days,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product": product!.toJson(),
    "product_deliverys": List<dynamic>.from(productDeliverys!.map((x) => x.toJson())),
  };
}