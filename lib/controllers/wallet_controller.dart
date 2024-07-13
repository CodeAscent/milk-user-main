import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/model/card_item.dart';
import 'package:water/model/wallet_history_item.dart';
import 'package:water/repository/wallet_repository.dart';

class WalletController extends ControllerMVC {
  List<WalletHistoryItem>? walletHistoryItemList;

  void getWalletHistoryApi() async {
    getWalletHistory().then((value) {
      if (value.success!) {
        walletHistoryItemList = List<WalletHistoryItem>.from(
            value.data.map((x) => WalletHistoryItem.fromJson(x)));
        appState.walletHistoryItemList.value = walletHistoryItemList!;
        setState(() {});
      } else {
        commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
        commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }

  void addWalletAmountApi(
      BuildContext context,String walletAmount,{String method='Razorpay'}) async {
    showLoader();
    addWalletAmount( walletAmount, method).then((value) {
      if (value.success ?? false) {
//        cardList = List<CardItem>.from(
//            value.data.map((x) => CardItem.fromJson(x)));
//        appState.cardList.value = cardList!;
//        appState.cardList.notifyListeners();
        commonAlertNotification("Success", message: UtilsHelper.getString(context, "add_balance_successfully_in_wallet"));
        Navigator.of(context).pop();
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

  void getMyWalletAmountApi(BuildContext context) async {
    getMyWalletAmount().then((value) {
      if (value.success ?? true) {
      } else {
        print("--------------");
        commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
      }
    }).catchError((e) {
      print("--------------");
      print(e);
      commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
    }).whenComplete(() {
      hideLoader();
    });
  }
}
