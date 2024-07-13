// import 'package:flutter/material.dart';
// import 'local_data/app_state.dart';

// class UtilsHelper {
//   UtilsHelper._();

//   static const String wr_default_font_family = 'Helvetica';
//   static const String the_sans_font_family = 'TheSans';
//   static const List<String> rightHandLang = [
//     //TODO: add more Right to Left languages
//     'ar', // Arabic
//     'fa', // Farsi
//     'he', // Hebrew
//     'ps', // Pashto
//     'ur', // Urdu
//   ];

//   static String getString(BuildContext? context, String key) {
//     print("This is key $key");
//     print(appState.languageKeys)
//     if (key != '' && appState.languageKeys.containsKey(key)) {
//       print("language key ${appState.languageKeys[key]}");
//       return appState.languageKeys[key];
//     } else if (key != '') {
//       print("$key NOT AVAILABLE");
//       return key;
//     } else {
//       return '';
//     }
//   }

//   static bool isLightMode(BuildContext context) {
//     return Theme.of(context).brightness == Brightness.light;
//   }
// }

import 'package:flutter/material.dart';
import 'local_data/app_state.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UtilsHelper {
  UtilsHelper._();

  static const String wr_default_font_family = 'Helvetica';
  static const String the_sans_font_family = 'TheSans';
  static const List<String> rightHandLang = [
    //TODO: add more Right to Left languages
    'ar', // Arabic
    'fa', // Farsi
    'he', // Hebrew
    'ps', // Pashto
    'ur', // Urdu
  ];

  static Future<void> loadLocalization(String languageCode) async {
    String jsonString =
        await rootBundle.loadString('assets/translations/$languageCode.json');
    Map<String, dynamic> languageKeys = json.decode(jsonString);
    appState.languageKeys = languageKeys;
  }

  static String getString(BuildContext? context, String key) {
    if (key.isNotEmpty && appState.languageKeys.containsKey(key)) {
      return appState.languageKeys[key];
    } else {
      return key;
    }
  }

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }
}
