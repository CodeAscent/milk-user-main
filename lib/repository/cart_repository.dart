import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/common/common.dart';

d.Dio dio = new d.Dio();

Future<CommonResponse> cartBulkAdd(Map<String, dynamic> data) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    "Content-Type": "application/json",
    Params.langCode: appState.languageItem.languageCode,
  };

  print(Urls.cartBulkAdd);
  print(data);
  print(headerData);
  try {
    d.Response response;
    response = await dio.post(Urls.cartBulkAdd,
        data: jsonEncode(data), options: d.Options(headers: headerData));
    print(response);
    if (response.statusCode == 200) {
      print(response.data['data']);
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw Exception(response.data);
    }
  } on d.DioException catch (e) {
    print(e);
    throw handleError(e);
  }
}
