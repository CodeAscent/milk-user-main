import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:water/Utils/error_handling.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/params.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/model/common/common.dart';
import 'package:water/model/user_model.dart';
import 'package:water/repository/setting_repository.dart';

d.Dio dio = new d.Dio();

ValueNotifier<bool> darkMode = ValueNotifier<bool>(false);

Future<CommonResponse> userLogin(String phone) async {
  print("phone" + phone);
  try {
    d.Response response;
    response = await dio.post(
      Urls.userLogin,
      options: d.Options(headers: {"Content-Type": "application/json"}),
      data: jsonEncode({Params.phone: phone}),
    );
    if (response.statusCode == 200) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      print(response.data);
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    throw handleError(e);
  }
}

Future<CommonResponse> verifyOTP(
    {String? phone, String? token, String? otp}) async {
  print("phone $phone");
  try {
    d.Response response;
    response = await dio.post(Urls.userVerifyOtp,
        options: d.Options(
            headers: {"Content-Type": "application/json"},
            validateStatus: (status) => true),
        data: jsonEncode({
          // Params.deviceToken: token,
          Params.deviceType: Platform.isAndroid ? "android" : "ios",
          Params.otp: isfirebase == false ? otp : "1234",
          Params.phone: phone,
          "player_id": OneSignal.User.pushSubscription.id
        }));
    print("*****************************");
    print(response.statusCode);

    if (response.statusCode == 200) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    print(e);
    throw handleError(e);
  }
}

Future<CommonResponse> userResendOtp(String phone) async {
  print("phone $phone");
  try {
    d.Response response;
    response = await dio.post(
      Urls.userResendOtp,
      data: {Params.phone: phone},
      options: d.Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => true),
    );
    print("reSendOtp  $response");
    if (response.statusCode == 200) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    print(e.error.toString());
    throw handleError(e);
  }
}

Future<CommonResponse> userGetProfile() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode
  };

  try {
    d.Response response;
    response = await dio.get(
      Urls.userGetProfile,
      options: d.Options(headers: headerData),
    );
    print("userGetProfile  $response");
    if (response.statusCode == 200) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      commonResponse.data['api_token'] = appState.apiToken;
      setCurrentUser(commonResponse.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioError catch (e) {
    print(e);
    throw handleError(e);
  }
}

Future<CommonResponse> userUpdateNotification(bool enableNotification) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
    Params.langCode: appState.languageItem.languageCode
  };

  Map<String, dynamic> bodyData = {
    Params.enableNotificaton: enableNotification ? 1 : 0
  };

  try {
    d.Response response;
    response = await dio.post(Urls.userUpdateNotification,
        options: d.Options(headers: headerData), data: bodyData);
    print("userUpdateNotification  $response");
    if (response.statusCode == 200) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      commonResponse.data['api_token'] = appState.apiToken;
      setCurrentUser(commonResponse.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    print(e);
    throw handleError(e);
  }
}

Future<CommonResponse> userUpdateProfile(Map<String, dynamic> bodyData) async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.userModel.apiToken,
    Params.contentType: "application/json",
    //   Params.langCode: appState.languageItem.languageCode
  };

  try {
    d.Response response;
    response = await dio.post(Urls.userUpdateProfile,
        options: d.Options(headers: headerData), data: bodyData);
    print("userUpdateProfile  $response");
    if (response.statusCode == 200) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      commonResponse.data['api_token'] = appState.apiToken;
      setCurrentUser(commonResponse.data);
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
    // ignore: deprecated_member_use
  } on d.DioError catch (e) {
    if (e.response!.statusCode == 401) {
      throw "number_you_entered_is_already_registered";
    }
    throw handleError(e);
  }
}

Future<CommonResponse> userLogout() async {
  Map<String, dynamic> headerData = {
    Params.apiToken: appState.apiToken,
  };

  try {
    d.Response response;
    response = await dio.post(
      Urls.userLogout,
      options: d.Options(headers: headerData),
    );
    print("logout  $response");
    if (response.statusCode == 200) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      logoutLocalUser();
      return commonResponse;
    } else {
      throw new Exception(response.data);
    }
  } on d.DioException catch (e) {
    print(e);
    throw handleError(e);
  }
}

Future setCurrentUser(data) async {
  final box = GetStorage();
  if (data != null) {
    await box.write('current_user', json.encode(UserModel.fromJson(data)));
  }
}

Future<UserModel> getCurrentUser() async {
  final box = GetStorage();
  String userString = await box.read('current_user');
  appState.userModel = UserModel.fromJson(json.decode(userString));
  appState.apiToken = appState.userModel.apiToken!;
  print("current user token ${appState.userModel.apiToken}");
  return appState.userModel;
}

Future logoutLocalUser() async {
  final box = GetStorage();
  box.erase();
}
