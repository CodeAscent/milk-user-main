import 'banner/banner.dart';
import 'product/product.dart';

class HomeData {
  List<BannerItem>? banners;
  ProductData? products;

  HomeData({this.banners, this.products});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners!.add(new BannerItem.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products  = ProductData.fromJson(json['products']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }
}