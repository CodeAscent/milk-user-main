import 'dart:convert';

import 'package:water/Utils/utils.dart';

class ProductData {
  int? currentPage;
  List<Product>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  int? to;
  int? total;

  ProductData(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.to,
      this.total});

  ProductData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(Product.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? image;
  double? price;
  double? discountPrice;
  int? stock;
  String? description;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic cartInfo;
  bool? isFavorite;
  int quantity = 0;
  int? mininumOrderQuantity;
  String? orderFrequency = "once";
  List<int>? days;
  List<DateTime>? selectedDates = [DateTime.now().add(Duration(days: 1))];
  DateTime? startDate = DateTime.now().add(Duration(days: 1));
  DateTime? endDate = DateTime.now().add(Duration(days: 1));

  Product({
    this.id,
    this.name,
    this.image,
    this.price,
    this.discountPrice,
    this.stock,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.cartInfo,
    this.isFavorite,
    this.orderFrequency = "once",
    this.days,
    this.selectedDates,
    this.quantity = 0,
    this.startDate,
    this.endDate,
    this.mininumOrderQuantity,
  });

  Product.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // name = json['name'];
    // image = json['image'];
    // price = json['price'].toDouble();
    // discountPrice = json['discount_price'] != null ? json['discount_price'].toDouble() : null;
    // stock = json['stock'];
    // description = json['description'];
    // status = json['status'];
    // createdAt = DateTime.parse(json["created_at"]);
    // updatedAt = DateTime.parse(json["updated_at"]);
    // cartInfo = json['cart_info'];
    // mininumOrderQuantity  = json['minimum_order_quantity'];
    // isFavorite = json['is_favorite'];
    // selectedDates = [DateTime.now().add(Duration(days: 1))];
    // startDate = DateTime.now().add(Duration(days: 1));
    // endDate = DateTime.now().add(Duration(days: 1));
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price']?.toDouble();
    discountPrice = json['discount_price'] != null
        ? json['discount_price'].toDouble()
        : null;
    stock = json['stock'];
    description = json['description'];
    status = json['status'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt =
        json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
    cartInfo = json['cart_info'];
    mininumOrderQuantity = json['minimum_order_quantity'];
    isFavorite = json['is_favorite'];
    selectedDates = [DateTime.now().add(Duration(days: 1))];
    startDate = DateTime.now().add(Duration(days: 1));
    endDate = DateTime.now().add(Duration(days: 1));
  }

  Product.fromCartJson(Map<String, dynamic> json) {
    // id = json['id'];
    // name = json['name'];
    // image = json['image'];
    // mininumOrderQuantity= json['minimum_order_quantity'];
    // price = json['price'].toDouble();
    // discountPrice = json['discount_price'] != null ? json['discount_price'].toDouble() : null;
    // stock = json['stock'];
    // description = json['description'];
    // status = json['status'];
    // createdAt = DateTime.parse(json["created_at"]);
    // updatedAt = DateTime.parse(json["updated_at"]);
    // cartInfo = json['cart_info'];
    // isFavorite = json['is_favorite'];
    // quantity = json['quantity'];
    // orderFrequency = json['orderFrequency'];
    // days = json['days'];
    // selectedDates = List<DateTime>.from(json["selectedDates"].map((x) => DateTime.parse(x)));
    id = json['id'];
    name = json['name'];
    image = json['image'];
    mininumOrderQuantity = json['minimum_order_quantity'];
    price = json['price']?.toDouble();
    discountPrice = json['discount_price'] != null
        ? json['discount_price'].toDouble()
        : null;
    stock = json['stock'];
    description = json['description'];
    status = json['status'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt =
        json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
    cartInfo = json['cart_info'];
    isFavorite = json['is_favorite'];
    quantity = json['quantity'];
    orderFrequency = json['orderFrequency'];
    days = json['days'];
    selectedDates = json['selectedDates'] != null
        ? List<DateTime>.from(
            json['selectedDates'].map((x) => DateTime.parse(x)))
        : [DateTime.now().add(Duration(days: 1))];
  }

  Product.fromLocalJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    mininumOrderQuantity = json['minimum_order_quantity'];
    price = json['price'].toDouble();
    discountPrice = json['discount_price'] != null
        ? json['discount_price'].toDouble()
        : null;
    stock = json['stock'];
    description = json['description'];
    status = json['status'];
    createdAt = DateTime.parse(json["created_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
    startDate = DateTime.parse(json["start_date"]);
    endDate = DateTime.parse(json["end_date"]);
    cartInfo = json['cart_info'];
    isFavorite = json['is_favorite'];
    quantity = json['quantity'];
    orderFrequency = json['orderFrequency'];
    if (json['days'] != null) {
      days = [];
      jsonDecode(json['days']).forEach((v) {
        days!.add(v);
      });
    }
    if (json['selectedDates'] != null) {
      selectedDates = [];
      jsonDecode(json['selectedDates']).forEach((x) {
        selectedDates!.add(DateTime.parse(x));
      });
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['stock'] = this.stock;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    data['cart_info'] = this.cartInfo;
//    data['is_favorite'] = this.isFavorite;
    data['quantity'] = this.quantity;
    data['minimum_order_quantity'] = mininumOrderQuantity;
    data['orderFrequency'] = this.orderFrequency;
    data['days'] = this.days != null ? json.encode(this.days) : null;
    data['selectedDates'] = this.selectedDates != null
        ? json.encode(List<dynamic>.from(
            this.selectedDates!.map((x) => x.toIso8601String())))
        : null;
    data["start_date"] =
        this.startDate != null ? startDate!.toIso8601String() : null;
    data["end_date"] = this.endDate != null ? endDate!.toIso8601String() : null;
    return data;
  }

  Map<String, dynamic> toCartApiJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.id;
    data['quantity'] = this.quantity;
    data['minimum_order_quantity'] = mininumOrderQuantity;
    data['order_frequency'] = this.orderFrequency;
    data['days'] = this.days != null ? this.days : [];
    data['delivery_dates'] = this.selectedDates != null
        ? List<dynamic>.from(
            this.selectedDates!.map((x) => x.toIso8601String()))
        : null;
    data["start_date"] =
        this.startDate != null ? startDate!.toIso8601String() : null;
    data["end_date"] = this.endDate != null ? endDate!.toIso8601String() : null;
    return data;
  }

  getFrequencyCount() {
    switch (orderFrequency) {
      case 'once':
        return 1;
      case 'daily':
        if (endDate != null && startDate != null) {
          return daysBetweenDates(startDate!, endDate!) + 1;
        } else {
          return 0;
        }
      case 'weekly':
        if (endDate != null && startDate != null) {
          int _days = endDate!.difference(startDate!).inDays + 1;
          List<DateTime> _list = [];
          DateTime _dateTime;
          for (int i = 0; i < _days; i++) {
            _dateTime = startDate!.add(Duration(days: i));
            if (days != null && days!.contains(_dateTime.weekday % 7)) {
              _list.add(_dateTime);
            }
          }
          return _list.length;
        } else {
          return 0;
        }
      case 'monthly':
        return selectedDates?.length ?? 0;
      case 'alternative':
        if (endDate != null && startDate != null) {
          int days = endDate!.difference(startDate!).inDays + 1;
          List<DateTime> _list = [];
          for (int i = 0; i < days; i += 2) {
            DateTime _cDate = startDate!.add(Duration(days: i));
            _list.add(_cDate);
          }
          print(_list.length);
          return _list.length;
        } else {
          return 0;
        }
      case 'flexible':
        print('---------------> iam here7');
        if (selectedDates != null) {
          return selectedDates!.length;
        } else {
          return 0;
        }
      default:
        return 1;
    }
  }

  List<DateTime> getSelectedDates() {
    switch (orderFrequency) {
      case 'once':
        return selectedDates ?? [];
      case 'daily':
        if (endDate != null && startDate != null) {
          int _days = daysBetweenDates(startDate!, endDate!) + 1;
          selectedDates = [];
          for (int i = 0; i < _days; i++) {
            selectedDates!.add(startDate!.add(Duration(days: i)));
          }
          return selectedDates!;
        } else {
          return [];
        }
      case 'weekly':
        if (endDate != null && startDate != null) {
          int _days = endDate!.difference(startDate!).inDays + 1;
          selectedDates = [];
          DateTime _dateTime;
          for (int i = 0; i < _days; i++) {
            _dateTime = startDate!.add(Duration(days: i));
            if (days != null && days!.contains(_dateTime.weekday % 7)) {
              selectedDates!.add(_dateTime);
            }
          }
          return selectedDates!;
        } else {
          return [];
        }
      case 'monthly':
        return selectedDates ?? [];
      case 'alternative':
        if (endDate != null && startDate != null) {
          int days = endDate!.difference(startDate!).inDays + 1;
          selectedDates = [];
          for (int i = 0; i < days; i += 2) {
            DateTime _cDate = startDate!.add(Duration(days: i));
            selectedDates!.add(_cDate);
          }
          print(selectedDates!.length);
          return selectedDates!;
        } else {
          return [];
        }
      default:
        return [];
    }
  }

  @override
  int get hashCode => super.hashCode;
}
