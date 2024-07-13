import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/model/offer_item.dart';
import 'package:water/repository/offer_repository.dart';
class OfferController extends ControllerMVC {
  List<OfferItem>? offerList;
  OfferItem? appliedOfferItem;
  bool? isChecking = false;

  void getOffersCouponListsApi() async {
    getOffersCouponLists().then((value) {
      offerList =
          List<OfferItem>.from(value.data.map((x) => OfferItem.fromJson(x)));
      setState(() {});
    }).catchError((e) {
        commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }

  Future offersVerifyCodeApi(String code) async {
    appliedOfferItem = null;

    setState(() {
      isChecking = true;
    });

    await offersVerifyCode(code).then((value) {
      if (value.success!) {
        appliedOfferItem = OfferItem.fromJson(value.data);
//        commonAlertNotification("Error", message: value.message);
      } else {
//        commonAlertNotification("Error", message: value.message);
      }
      setState(() {});
    }).catchError((e) {
        commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      setState(() {
        isChecking = false;
      });
    });
  }
}
