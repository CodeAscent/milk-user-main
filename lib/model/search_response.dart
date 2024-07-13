import 'package:water/model/product/product_item.dart';


class SearchResponse {
  SearchResponse({
    this.success,
    this.productList,
    this.message,
  });

  bool? success;
  List<Product>? productList;
  String? message;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    success: json.containsKey('status') ? json['status'] : json["success"], 
    productList: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(productList!.map((x) => x.toJson())),
    "message": message,
  };
}