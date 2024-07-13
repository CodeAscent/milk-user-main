import 'package:dio/dio.dart' as d;
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/home_data.dart';

d.Dio dio = new d.Dio();

Future<HomeData> getHomeProductList({String? nexrtUrl}) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode,
  };

  print(headerData);
  try {
    d.Response response;
    response = await dio.get(nexrtUrl ?? Urls.homeProductList,
        options: d.Options(headers: headerData));

    if (response.statusCode == 200) {
      print(response.data['data']);
      HomeData homeData = HomeData.fromJson(response.data['data']);
      return homeData;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    print("This is error $e");
    throw handleError(e);
  }
}
