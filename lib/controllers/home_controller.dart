import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/model/banner/banner.dart';
import 'package:water/model/product/product.dart';
import 'package:water/repository/product_repository.dart';

ProductData? products;
List<BannerItem>? banners;

class HomeController extends ControllerMVC {
  void getHomeBannersApi() async {
    getHomeProductList().then((value) {
      print("Banner ${value.banners}");
      print("Products ${value.products}");
      banners = value.banners;
      products = value.products;
      setState(() {});
    }).catchError((e) {
      print("This is error $e");
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }

  Future getPaginatedProducts(String nexrtUrl) async {
    await getHomeProductList(nexrtUrl: nexrtUrl).then((value) {
      products!.currentPage = value.products!.currentPage;
      products!.nextPageUrl = value.products!.nextPageUrl;
      products!.data!.addAll(value.products!.data!.toList());
      setState(() {});

      print(products!.nextPageUrl);
    }).catchError((e) {
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }
}
