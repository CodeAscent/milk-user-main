import 'package:dio/dio.dart' as d;
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/address_item.dart';
import 'package:water/model/common/common.dart';

d.Dio dio = new d.Dio();

Future<CommonResponse> getAddressList() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.get(Urls.addressList,
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

Future<CommonResponse> addressAddUpdate(AddressItem addressItem) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
    Params.contentType: "application/json"
  };

  try {
    d.Response response;
    print(addressItem.toJson());

    response = await dio.post(Urls.addressAddUpdate,
        data: addressItem.toJson(), options: d.Options(headers: headerData));

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

Future<CommonResponse> addressDelete(int addressId) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.post(Urls.addressDelete + "/" + addressId.toString(),
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
