import 'package:water/Utils/display_format.dart';
import 'package:water/Utils/utils.dart';

class OfferItem {
  OfferItem({
    this.id,
    this.couponName,
    this.image,
    this.type,
    this.value,
    this.startDate,
    this.endDate,
    this.description,
    this.minimumOrderValue,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.discountPrice
  });

  int? id;
  String? couponName;
  String? image;
  String? type;
  double? value;
  DateTime? startDate;
  DateTime? endDate;
  String? description;
  int? minimumOrderValue;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? discountPrice;

  factory OfferItem.fromJson(Map<String, dynamic> json) => OfferItem(
        id: json["id"],
        couponName: json["coupon_name"],
        image: json["image"],
        type: json["type"],
        value: json["value"].toDouble(),
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        description: json["description"],
        minimumOrderValue: json["minimum_order_value"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_name": couponName,
        "image": image,
        "type": type,
        "value": value,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "minimum_order_value": minimumOrderValue,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };

  String getSaveString({ int? stringAsFixed }) {
    if (type == "Percent") {
      return value!.toStringAsFixed(0) + "%";
    } else {
      return displayPrice(value, stringAsFixed: stringAsFixed);
    }
  }

  String expireDateTimeDescription() {
    return getDayFormat(endDate!, ddMMMMYYYYhhmmaFormat);
  }
}
