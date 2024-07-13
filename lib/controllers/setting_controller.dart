import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/model/contact_us_item.dart';
import 'package:water/repository/setting_repository.dart';

import '../model/product/product_item.dart';

class SettingController extends ControllerMVC {

  List<Product> searchList = [];

  void contactUsApi(BuildContext context, ContactItem contactItem) async {
    showLoader();
    contactUs(contactItem).then((value) {
      if (value.success!) {
        commonAlertNotification("Success", message: UtilsHelper.getString(context, "contact_add_successfully"));
        Navigator.of(context).pop();
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

  Future searchApi(BuildContext context, String key,{ValueChanged? onChanged}) async {
    // showLoader();
   await search(key).then((value) {
      if (value.success!) {
        searchList = value.productList as List<Product>;
        onChanged!(false);
        setState(() { });
       // commonAlertNotification("Success", message: UtilsHelper.getString(context, value.message.toString()));

      } else {
        onChanged!(false);
        commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
      }
    }).catchError((e) {
      onChanged!(false);
      // print(e.value.first.toString());
      commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
    }).whenComplete(() {
      onChanged!(false);
      
    });
  }

}