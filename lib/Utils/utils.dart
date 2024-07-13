import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:water/Utils/local_data/app_state.dart';

import 'UtilHelper.dart';

displayPrice(double? price,{int? stringAsFixed}) {
  if (!UtilsHelper.rightHandLang.contains(appState.currentLanguageCode.value)) {
    if (appState.currencyRight == "1") {
      return price!.toStringAsFixed(stringAsFixed ?? appState.defaultCurrencyDecimalDigits) +
          " " +
          appState.defaultCurrency;
    }
    return "${appState.defaultCurrency} ${price!.toStringAsFixed( stringAsFixed ??appState.defaultCurrencyDecimalDigits)}";
  } else {
    if (appState.currencyRight == "1") {
      return appState.defaultCurrency +
          " " + 
          price!.toStringAsFixed(stringAsFixed ?? appState.defaultCurrencyDecimalDigits);
    }
    return "${price!.toStringAsFixed(stringAsFixed ?? appState.defaultCurrencyDecimalDigits)} ${appState.defaultCurrency}";
  }
}

displayPriceDouble(double price) {
  if (!UtilsHelper.rightHandLang.contains(appState.currentLanguageCode.value)) {
    if (appState.currencyRight == "1") {
      return price.toStringAsFixed(appState.defaultCurrencyDecimalDigits) +
          " " +
          appState.defaultCurrency;
    }
    return appState.defaultCurrency +
        " " +
        price.toStringAsFixed(appState.defaultCurrencyDecimalDigits);
  } else {
    if (appState.currencyRight == "1") {
      return appState.defaultCurrency +
          " " +
          price.toStringAsFixed(appState.defaultCurrencyDecimalDigits);
    }
    return price.toStringAsFixed(appState.defaultCurrencyDecimalDigits) +
        " " +
        appState.defaultCurrency;
  }
}

Future<Placemark> getAddressFromLatLong(double lat, double lng) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  return placemarks.first;
}

int daysBetweenDates(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

double decimalValueWithPlaces(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
