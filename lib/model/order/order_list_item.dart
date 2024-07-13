import 'package:water/Utils/display_format.dart';

import '../address_item.dart';
import 'order.dart';
import 'order_payment.dart';

class OrderListItem {
  OrderListItem({
    this.id,
    this.userId,
    this.orderStatusId,
    this.deliveryAddressId,
    this.paymentId,
    this.promotionalDisount,
    this.isCouponApplied,
    this.couponCode,
    this.subtotal,
    this.finalAmount,
    this.tax,
    this.deliveryFee,
    this.paymentMethod,
    this.timeslotId,
    this.createdAt,
    this.updatedAt,
    this.productOrders,
    this.orderStatus,
    this.payment,
    this.deliveryAddress,
    this.cancelRequest,
  });

  int? id;
  int? userId;
  int? orderStatusId;
  int? deliveryAddressId;
  int? paymentId;
  double? promotionalDisount;
  int? isCouponApplied;
  String? couponCode;
  double? subtotal;
  double? finalAmount;
  double? tax;
  double? deliveryFee;
  String? paymentMethod;
  int? timeslotId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ProductOrder>? productOrders;
  Status? orderStatus;
  OrderPayment? payment;
  AddressItem? deliveryAddress;
  CancelRequest? cancelRequest;

  factory OrderListItem.fromJson(Map<String, dynamic> json) {
    print(json);
    return OrderListItem(
      id: json["id"],
      userId: json["user_id"],
      orderStatusId: json["order_status_id"],
      deliveryAddressId: json["delivery_address_id"],
      paymentId: json["payment_id"],
      promotionalDisount: json["promotional_disount"]!=null ? json["promotional_disount"].toDouble(): null,
      isCouponApplied: json["is_coupon_applied"],
      couponCode: json["coupon_code"],
      subtotal: json["subtotal"].toDouble(),
      finalAmount: json["final_amount"].toDouble(),
      tax: json["tax"].toDouble(),
      deliveryFee: json["delivery_fee"].toDouble(),
      paymentMethod: json["payment_method"],
      timeslotId: json["timeslot_id"],
      createdAt: json["created_at"]!=null ? DateTime.parse(json["created_at"]) : null,
      updatedAt: json["updated_at"]!=null ? DateTime.parse(json["updated_at"]) : null,
      productOrders: List<ProductOrder>.from(json["product_orders"].map((x) => ProductOrder.fromJson(x))),
      orderStatus: Status.fromJson(json["order_status"]),
      payment: json["payment"] == null ? null : OrderPayment.fromJson(json["payment"]),
      deliveryAddress: json["delivery_address"] == null ? null : AddressItem.fromJson(json["delivery_address"]),
      cancelRequest: json["cancel_request"]!=null ? CancelRequest.fromJson(json["cancel_request"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_status_id": orderStatusId,
    "delivery_address_id": deliveryAddressId,
    "payment_id": paymentId,
    "promotional_disount": promotionalDisount,
    "is_coupon_applied": isCouponApplied,
    "coupon_code": couponCode,
    "subtotal": subtotal,
    "final_amount": finalAmount,
    "tax": tax,
    "delivery_fee": deliveryFee,
    "payment_method": paymentMethod,
    "timeslot_id": timeslotId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product_orders": List<dynamic>.from(productOrders!.map((x) => x.toJson())),
    "order_status": orderStatus?.toJson(),
//    "cancel_request": cancelRequest?.toJson(),
  };


  Map<String, dynamic> toPaymentJson() => {
     "payment": {
        "method": paymentMethod
      },
    "order_status_id": orderStatusId,
    "delivery_address_id": deliveryAddressId,
    "payment_id": paymentId,
    "promotional_disount": promotionalDisount,
    "is_coupon_applied": isCouponApplied,
    "coupon_code": couponCode,
    "subtotal": subtotal,
    "final_amount": finalAmount,
    "tax": tax,
    "delivery_fee": deliveryFee,
    "timeslot_id": timeslotId,
//    "cancel_request": cancelRequest?.toJson(),
  };

  getOrderTime() {
    if(this.createdAt==null) {
      return "-";
    }
    return getDayFormat(this.createdAt, ddMMMMYYYYhhmmaFormat);
  }
}
