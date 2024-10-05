import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/model/address_item.dart';
import 'package:water/repository/address_repository.dart';

class AddressController extends ControllerMVC {
  List<AddressItem>? pickupAddressList;

  void getAddressListApi() async {
    getAddressList().then((value) {
      if (value.success!) {
        pickupAddressList = List<AddressItem>.from(
            value.data.map((x) => AddressItem.fromJson(x)));
        appState.pickupAddressList.value = pickupAddressList!;
        setState(() {});
      } else {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }

  void addressAddUpdateApi(
      BuildContext context, AddressItem addressItem) async {
    showLoader();
    addressAddUpdate(addressItem).then((value) {
      if (value.success!) {
        pickupAddressList = List<AddressItem>.from(
            value.data.map((x) => AddressItem.fromJson(x)));
        appState.pickupAddressList.value = pickupAddressList!;
        appState.pickupAddressList.notifyListeners();
        Navigator.pop(context);

        if (addressItem.id == 0) {
          Navigator.pop(context);
          appState.selectedPickupAddress = appState.pickupAddressList.value
              .firstWhere((element) => element.address == addressItem.address);
          // Navigator.of(context).pushNamed(RoutePath.checkout_pay);
          // Navigator.pop(context);
        }
      } else {
        appState.selectedPickupAddress = appState.pickupAddressList.value
            .firstWhere((element) => element.address == addressItem.address);

        // commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      hideLoader();
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      hideLoader();
    });
  }

  void addressDeleteApi(BuildContext context, AddressItem addressItem) async {
    showLoader();
    addressDelete(addressItem.id!).then((value) {
      if (value.success!) {
        commonAlertNotification("Success",
            message: UtilsHelper.getString(null, "address_delete_sucessfully"));
        appState.pickupAddressList.value.remove(addressItem);
        setState(() {});
      } else {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      hideLoader();
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      hideLoader();
    });
  }
}
