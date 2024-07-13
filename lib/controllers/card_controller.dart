import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/model/card_item.dart';
import 'package:water/repository/card_repository.dart';

class CardController extends ControllerMVC {
  List<CardItem>? cardList;

  void getCardListApi() async {
    getCardList().then((value) {
      if (value.success!) {
        cardList =
            List<CardItem>.from(value.data.map((x) => CardItem.fromJson(x)));
        appState.cardList.value = cardList!;
        setState(() {});
      } else {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      print(e.toString());
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }

  void cardAddUpdateApi(BuildContext context, CardItem cardItem) async {
    showLoader();
    cardAddUpdate(cardItem).then((value) {
      if (value.success == true) {
        cardList =
            List<CardItem>.from(value.data.map((x) => CardItem.fromJson(x)));
        appState.cardList.value = cardList!;
        appState.cardList.notifyListeners();
        commonAlertNotification("Success",
            message: UtilsHelper.getString(null, "card_added_successfully"));
        Navigator.of(context).pop();
      }
      //  else {
      //   commonAlertNotification("Error",
      //       message: UtilsHelper.getString(null, "something_went_wrong"));
      // }
    }).catchError((e) {
      hideLoader();
      print(e.toString());
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, e.toString()));
    }).whenComplete(() {
      hideLoader();
    });
  }

  void cardDeleteApi(BuildContext context, CardItem cardItem) async {
    showLoader();
    cardDelete(cardItem.id).then((value) {
      if (value.success!) {
        commonAlertNotification("Success",
            message: UtilsHelper.getString(null, "card_delete_successfully"));
        appState.cardList.value.remove(cardItem);
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
