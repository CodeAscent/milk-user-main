import 'package:dio/dio.dart' as d;
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/card_item.dart';
import 'package:water/model/common/common.dart';

d.Dio dio = new d.Dio();

Future<CommonResponse> getCardList() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.contentType: "application/json",
    // Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response =
        await dio.get(Urls.cardList, options: d.Options(headers: headerData));
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

Future<CommonResponse> cardAddUpdate(CardItem cardItem) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.contentType: "application/json",
    // Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.post(Urls.cardAddUpdate,
        data: cardItem.toJson(), options: d.Options(headers: headerData));
    if (response.statusCode == 200) {
      print(response.data);
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioError catch (e) {
    throw handleError(e);
  }
}

Future<CommonResponse> cardDelete(int? cardId) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.contentType: "application/json",
//    Params.langCode: appState.languageItem.languageCode,
  };

  try {
    d.Response response;
    response = await dio.post(Urls.cardDelete + "/" + cardId.toString(),
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
