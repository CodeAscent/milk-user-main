import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/model/login_data.dart';
import 'package:water/model/user_model.dart';
import 'package:water/model/verify_otp_data.dart';
import 'package:water/repository/setting_repository.dart';
import 'package:water/repository/user_repository.dart' as userRepo;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

class AuthController extends ControllerMVC {
  TextEditingController numberController = TextEditingController();
  LoginData? loginData;
  VerifyOTPData? verifyOTPData;
  UserModel? userModel;

//  UserModel userModel = UserModel();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String _verificationId = "";
  int? _resendToken;

  Future<bool> resendOTP({required String phone}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        _resendToken = resendToken;
        commonAlertNotification('', message: "OTP Sent");
      },
      timeout: const Duration(seconds: 120),
      forceResendingToken: _resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = _verificationId;
      },
    );
    debugPrint("_verificationId: $_verificationId");
    return true;
  }

  void sendOtpApiCall(BuildContext context) async {
    FocusScope.of(context).unfocus();
    // FirebaseAuth _auth = FirebaseAuth.instance;

    print("numberController ${numberController.text}");

    if (numberController.text.trim().isNotEmpty) {
      if (numberController.text.length >= 8) {
        showLoader();
        var num = numberController.text.trim();

        userRepo.userLogin(num).then((value) async {
          if (value.success!) {
            loginData = LoginData.fromJson(value.data);

            if (isfirebase == true) {
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: '+91' + num,
                verificationCompleted: (PhoneAuthCredential credential) {
                  // commonAlertNotification("",message: UtilsHelper.getString(null, 'Logged In Successfully'));
                },
                verificationFailed: (FirebaseAuthException e) {
                  hideLoader();
                  commonAlertNotification("",
                      message:
                          UtilsHelper.getString(null, e.message.toString()));
                },
                timeout: Duration(milliseconds: 120),
                codeSent: (String verificationId, int? resendToken) {
                  hideLoader();
                  Navigator.of(context).pushNamed(
                    RoutePath.enter_otp,
                    arguments: [verificationId, num],
                  );
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            } else {
              hideLoader();
              commonAlertNotification("",
                  message:
                      UtilsHelper.getString(null, 'Logged In Successfully'));
              Navigator.of(context)
                  .pushNamed(RoutePath.enter_otp, arguments: [num]);
            }
          } else {
            commonAlertNotification("",
                message: UtilsHelper.getString(null, value.toString()));
          }
        }).catchError((e) {
          hideLoader();
          commonAlertNotification("Error",
              message: UtilsHelper.getString(null, "something_went_wrong"));
        }).whenComplete(() {
          // hideLoader();
        });
      } else {
        hideLoader();
        commonAlertNotification("Error", message: 'Enter at least 8 digits');
      }
    } else {
      hideLoader();
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "please_enter_mobile_number"));
    }
  }

  void verifyOTPApiCall(BuildContext context, String otp, String phone,
      String verificationCode) async {
    FocusScope.of(context).unfocus();
    print("otp $otp");

    if ((otp.isNotEmpty && isfirebase == true && otp.length == 6) ||
        otp.isNotEmpty && otp.length == 4) {
      showLoader();
      if (isfirebase == true) {
        await signInFirebase(otp, verificationCode, context)
            .then((value) async {
          if (value == true) {
            await verifyNonFirebase(phone, otp, context);
          }
        });
      } else {
        verifyNonFirebase(phone, otp, context);
      }
    } else {
      hideLoader();
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "please_enter_otp_properly"));
    }
  }

  Future verifyNonFirebase(
      String phone, String otp, BuildContext context) async {
    userRepo
        .verifyOTP(phone: phone, token: appState.deviceTokenId, otp: otp)
        .then((value) {
      if (value.success!) {
        verifyOTPData = VerifyOTPData.fromJson(value.data);
        appState.apiToken = verifyOTPData!.apiToken!;
        userGetProfileCall(context).then((value) {
          hideLoader();
          commonAlertNotification("",
              message: UtilsHelper.getString(null, 'Logged In Successfully'));
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutePath.home_screen, (Route<dynamic> route) => false);
        }).catchError((e) {
          hideLoader();
          print(e);
        });
      } else {
        /// print(e);
        hideLoader();
        commonAlertNotification("Error",
            message: "Incorrect OTP! \nPlease try again later");
      }
    }).catchError((e) {
      hideLoader();
      print(e);
      commonAlertNotification("Error",
          message: "Incorrect OTP! \nPlease try again later");
    }).whenComplete(() {});
  }

  Future<bool> signInFirebase(
      String otp, String verificationCode, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var smsCode = otp;
    var _credential = PhoneAuthProvider.credential(
        verificationId: verificationCode.toString(), smsCode: smsCode);

    return auth.signInWithCredential(_credential).then((result) {
      //hideLoader();
      return true;
      //  commonAlertNotification("",message: UtilsHelper.getString(null, 'Logged In Successfully'));
      //  Navigator.of(context).pushNamedAndRemoveUntil(
      //      RoutePath.home_screen, (Route<dynamic> route) => false);
    }).catchError((e) {
      hideLoader();
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
      return false;
    });
  }

  void userResendOtpApiCall(BuildContext context, String phone) async {
    FocusScope.of(context).unfocus();
    print("Phone $phone");
    showLoader();
    userRepo.userResendOtp(phone).then((value) {
      if (value.success!) {
        // resendOTP(phone: '+91' + phone).then((value) =>
        commonAlertNotification("Success",
            message: UtilsHelper.getString(null, "resend_otp_successfully"));
      } else {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      hideLoader();
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      hideLoader();
    });
  }

  void userLogoutApiCall(BuildContext context) async {
    FocusScope.of(context).unfocus();
    showLoader();
    userRepo.userLogout().then((value) {
      if (value.success!) {
        commonAlertNotification("Success",
            message: UtilsHelper.getString(null, "logout_successfully"));
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutePath.sign_in, (Route<dynamic> route) => false);
      } else {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      hideLoader();
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      hideLoader();
    });
  }

  Future<void> userGetProfileCall(BuildContext context,
      {bool isDisplayLoader = false}) async {
    if (isDisplayLoader) {
      showLoader();
    }
    userRepo.userGetProfile().then((value) {
      if (value.success!) {
        userModel = UserModel.fromJson(value.data);
        userModel!.apiToken = appState.apiToken;
        appState.userModel = userModel!;

        print(userModel);
      } else {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      if (isDisplayLoader) {
        hideLoader();
      }
      commonAlertNotification("Error",
          message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      if (isDisplayLoader) {
        hideLoader();
      }
    });
  }

  Future<void> userUpdateNotificationAPI(BuildContext context, bool isEnable,
      {bool isDisplayLoader = false}) async {
    if (isDisplayLoader) {
      showLoader();
    }
    userRepo.userUpdateNotification(isEnable).then((value) {
      if (value.success!) {
        userModel = UserModel.fromJson(value.data);
        userModel!.apiToken = appState.apiToken;
        appState.userModel = userModel!;
        print(userModel);
        setState(() {});
      } else {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).catchError((e) {
      if (isDisplayLoader) {
        hideLoader();
      }
      // commonAlertNotification("Error",
      //     message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      if (isDisplayLoader) {
        hideLoader();
      }
    });
  }

  Future<void> userUpdateProfileAPI(
      BuildContext context, Map<String, dynamic> bodyData,
      {bool isDisplayLoader = true}) async {
    if (isDisplayLoader) {
      showLoader();
    }
    userRepo.userUpdateProfile(bodyData).then((value) {
      if (value.success!) {
        userModel = UserModel.fromJson(value.data);
        userModel!.apiToken = appState.apiToken;
        appState.userModel = userModel!;
        print(userModel);
        Navigator.pop(context);
        setState(() {});
      }
    }).catchError((e) {
      if (isDisplayLoader) {
        hideLoader();
      }
      if (e is String) {
        commonAlertNotification("Error",
            message: UtilsHelper.getString(
                null, "number_you_entered_is_already_registered"));
      } else {
        print(e.toString());
        commonAlertNotification("Error",
            message: UtilsHelper.getString(null, "something_went_wrong"));
      }
    }).whenComplete(() {
      if (isDisplayLoader) {
        hideLoader();
      }
    });
  }

  Future<void> notificationInit() async {
    await Firebase.initializeApp();
    //appState.deviceTokenId = (await _firebaseMessaging.getToken())!;
    print("tokenId ${appState.deviceTokenId}");
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("---message--->");
//        Navigator.pushNamed(context, '/message',
//            arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (!kIsWeb) {
        print(
            "showNotificationWithDefaultSound  ${message.data} ${message.notification}");
        var largeIconPath;
        if (message.data['image'] != null && message.data['image'] is String) {
          largeIconPath = await _downloadAndSaveFile(
              message.data['image'], 'largeIcon.jpg');
        }

        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel!.id, channel!.name,
                    icon: 'ic_launcher',
                    playSound: true,
                    priority: Priority.high,
                    importance: Importance.max,
                    largeIcon: largeIconPath != null
                        ? FilePathAndroidBitmap(largeIconPath)
                        : null),
                iOS: DarwinNotificationDetails(
                    attachments: largeIconPath != null
                        ? [DarwinNotificationAttachment(largeIconPath)]
                        : null)));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
//      Navigator.pushNamed(context, '/message',
//          arguments: MessageArguments(message, true));
    });
  }
}

Future<String?> _downloadAndSaveFile(String url, String fileName) async {
  try {
    var directory = await getTemporaryDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  } catch (e) {
    return null;
  }
}
