import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/repository/cart_repository.dart';

class CartController extends ControllerMVC {

  void cartBulkAddApi(BuildContext context) async {
    showLoader();
    Map<String, dynamic> requestBody = {
      "products" : List<dynamic>.from(appState.carts.value.map((x) => x.toCartApiJson()))
    };
    cartBulkAdd(requestBody).then((value) {
      if (value.success!) {
        // commonAlertNotification("Success", message: UtilsHelper.getString(context, "successfully_add_to_cart"));
        Navigator.of(context).pushNamed(RoutePath.checkout);
      } else {
        commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
      }
    }).catchError((e) {
      hideLoader();
      commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
    }).whenComplete(() {
      hideLoader();
    });
  }

}