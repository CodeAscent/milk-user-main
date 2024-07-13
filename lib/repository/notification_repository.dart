import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/common/common.dart';

d.Dio dio = new d.Dio();

Future<CommonResponse> getNotificationList({String? url}) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.get(url??Urls.notification,
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

ValueNotifier<int> notificationCount = ValueNotifier(0);

Future<CommonResponse> getNotificationCount() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  print(headerData);
  try {
    d.Response response;
    response = await dio.get(Urls.notificationCount,
        options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data['data']);
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      notificationCount.value = commonResponse.data;
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioError catch (e) {
    throw handleError(e);
  }
}

Future<CommonResponse> getNotificationDelete() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.get(Urls.notificationDelete,
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