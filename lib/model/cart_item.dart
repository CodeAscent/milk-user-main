import 'product/product_item.dart';

class CartItem {
  CartItem({
    this.id,
    this.userId,
    this.productId,
    this.quantity,
    this.perItemAmount,
    this.perDeliveryAmount,
    this.totalDeliveryAmount,
    this.noOfDelivery,
    this.deliveryDates,
    this.orderFrequency,
    this.days,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  int? id;
  int? userId;
  int? productId;
  int? quantity;
  int? perItemAmount;
  int? perDeliveryAmount;
  int? totalDeliveryAmount;
  int? noOfDelivery;
  String? deliveryDates;
  String? orderFrequency;
  String? days;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Product? product;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    perItemAmount: json["per_item_amount"],
    perDeliveryAmount: json["per_delivery_amount"],
    totalDeliveryAmount: json["total_delivery_amount"],
    noOfDelivery: json["no_of_delivery"],
    deliveryDates: json["delivery_dates"],
    orderFrequency: json["order_frequency"],
    days: json["days"],
    startDate: json["start_date"]!=null ? DateTime.parse(json["start_date"]) : null,
    endDate: json["end_date"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "quantity": quantity,
    "per_item_amount": perItemAmount,
    "per_delivery_amount": perDeliveryAmount,
    "total_delivery_amount": totalDeliveryAmount,
    "no_of_delivery": noOfDelivery,
    "delivery_dates": deliveryDates,
    "order_frequency": orderFrequency,
    "days": days,
    "start_date": startDate,
    "end_date": endDate,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "product": product?.toJson(),
  };
}