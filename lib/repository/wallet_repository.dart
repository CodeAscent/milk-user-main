import 'package:dio/dio.dart' as d;
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/card_item.dart';
import 'package:water/model/common/common.dart';

d.Dio dio = new d.Dio();

Future<CommonResponse> getWalletHistory() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
//    Params.langCode: appState.languageItem.languageCode,
  };

  print(headerData);
  print(Urls.walletHistory);
  try {
    d.Response response;
    response = await dio.get(Urls.walletHistory,
        options: d.Options(headers: headerData));
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

Future<CommonResponse> addWalletAmount(
   String walletAmount, String method) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.contentType: "application/json"
//    Params.langCode: appState.languageItem.languageCode,
  };

  Map<String, dynamic> bodyData = {
    "payment_type": method,
    "wallet_amount" : walletAmount
  };

  try {
    d.Response response;
    response = await dio.post(Urls.addWalletAmount,
        data: bodyData, options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data['data']);
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      print(response.data);
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
     print(e);
    throw handleError(e);
  }
}

Future<CommonResponse> getMyWalletAmount() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
//    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.get(Urls.myWalletAmount,
        options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data['data']);
      appState.myWalletBalance.value = response.data['data'] is String
          ? double.parse(response.data['data'])
          : response.data['data'].toDouble();
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      print(response.data);
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    print(e);
    throw handleError(e);
  }
}
