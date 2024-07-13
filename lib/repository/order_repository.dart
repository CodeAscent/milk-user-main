import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/common/common.dart';

d.Dio dio = new d.Dio();

Future<CommonResponse> orderPlace(Map<String, dynamic> requestData) async {
  Map<String, dynamic> headerData = {
    Params.contentType: "application/json",
    Params.apiToken: appState.apiToken,
  };
  print('========== Api token ==============');
print(appState.apiToken);
  print(Urls.orderPlace);
  print(requestData);
  try {
    d.Response response;
    response = await dio.post(Urls.orderPlace,
        data: requestData, options: d.Options(headers: headerData,
        responseType: ResponseType.json,
        validateStatus: (status) => true));
    if (response.statusCode == 200) {
      print(response.data['data']);

      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
       print('----------- Order Place ----------');
      print(response.data.toString());
      throw new Exception(response.data);
    }
  } on d.DioError catch (e) {
     print('----------- Order Place ----------');
     print(e.toString());

    throw handleError(e);
  }
}

Future<CommonResponse> getOrderList() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response =
        await dio.get(Urls.orderLists, options: d.Options(headers: headerData));
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

Future<CommonResponse> getOrderDetail(int productId) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  print(Urls.orderDetail + "/" + productId.toString());
  try {
    d.Response response;
    response = await dio.get(Urls.orderDetail + "/" + productId.toString(),
        options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data['data']);
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    throw handleError(e);
  }
}

Future<CommonResponse> orderCancelRequest(int orderId) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
//    Params.langCode: appState.languageItem.languageCode,
  };

  print(Urls.orderCancelRequest + "/" + orderId.toString());
  print(headerData);
  try {
    d.Response response;
    response = await dio.get(Urls.orderCancelRequest + "/" + orderId.toString(),
        options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data['data']);
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    throw handleError(e);
  }
}
