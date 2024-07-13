import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'UtilHelper.dart';
import 'local_data/app_state.dart';

commonAlertNotification(String title, {String? message}) {
  bool isSuccess = ['Success', 'success'].contains(title);
  BotToast.showSimpleNotification(
      title: message.toString(),
      titleStyle: TextStyle(
          fontSize: 14,
          fontFamily: !UtilsHelper.rightHandLang
                  .contains(appState.currentLanguageCode.value)
              ? UtilsHelper.wr_default_font_family
              : UtilsHelper.the_sans_font_family),
      subTitleStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: !UtilsHelper.rightHandLang
                  .contains(appState.currentLanguageCode.value)
              ? UtilsHelper.wr_default_font_family
              : UtilsHelper.the_sans_font_family),
      hideCloseButton: true
      // closeIcon: Icon(isSuccess ? Icons.check : Icons.close,
      //     color: isSuccess ? Colors.green : Colors.red)
      );
}

showLoader() {
  BotToast.showLoading();
}

hideLoader() {
  BotToast.closeAllLoading();
}
