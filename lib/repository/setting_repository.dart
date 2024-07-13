import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as d;
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/common/common.dart';
import 'package:water/model/contact_us_item.dart';
import 'package:water/model/search_response.dart';
import 'package:water/model/settings_model/setting_model.dart';

d.Dio dio = new d.Dio();
String isPaypal = '0';

ValueNotifier<SettingData> setting = new ValueNotifier(SettingData());
bool isfirebase = true;

Future<SettingData> initSettings() async {
  try {
    d.Response response;
    print(Urls.settings);
    response = await dio.get(Urls.settings,
        options: d.Options(
            contentType: "application/json", validateStatus: (status) => true));
    print(response);
    if (response.statusCode == 200) {
      SettingData _setting = SettingData.fromJson(response.data['data']);

      setting.value = _setting;
      //Set default currency and their code to use to display with price in app
      appState.defaultCurrency = _setting.setting!['default_currency'];
      appState.defaultCurrencyCode = _setting.setting!["default_currency_code"];
      appState.defaultCurrencyDecimalDigits =
          int.parse(_setting.setting!["default_currency_decimal_digits"]);
      appState.defaultTax = double.parse(_setting.setting!["default_tax"]);
      isfirebase = _setting.setting!["is_enable_firebase"] == '1';
      isPaypal = _setting.setting!["enable_paypal"];
      appState.shippingCharge =
          double.parse(_setting.setting!["shipping_charge"]);
      appState.minimumOrderValue =
          double.parse(_setting.setting!["minimum_order_value"]);
      appState.currencyRight = _setting.setting!["currency_right"];
      setting.notifyListeners();
      return _setting;
    } else {
      return SettingData.fromJson({});
    }
  } on d.DioException catch (e) {
    print(e);
    return SettingData.fromJson({});
  }
}

Future<CommonResponse> contactUs(ContactItem contactItem) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
//    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.post(Urls.contectUs,
        data: contactItem.toJson(), options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data['data']);
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioError catch (e) {
    throw handleError(e);
  }
}

Future<SearchResponse> search(String string) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,

//    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.post(Urls.getSearchedProducts,
        data: {"search": string}, options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data['data']);
      SearchResponse commonResponse = SearchResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw Exception(response.data);
    }
    // ignore: deprecated_member_use
  } on d.DioError catch (e) {
    print(e);
    throw handleError(e);
  }
}

Future<Map<String, dynamic>> getKeysLists(String languageCode) async {
  try {
    print(Urls.keysLists);
    print(languageCode);
    d.Response response;
    response = await dio
        .get(Urls.keysLists, queryParameters: {"lang_code": languageCode});
    print(response);
    print(response.data['data'][0]);
    if (response.statusCode == 200) {
      return response.data['data'].isEmpty ? {} : response.data['data'][0];
    } else {
      return Map<String, dynamic>();
    }
  } on d.DioException catch (e) {
    print(e);
    return Map<String, dynamic>();
  }
}
