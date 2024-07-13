import 'dart:async';
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/Router/router.dart';
import 'package:water/firebase_options.dart';
import 'package:water/repository/setting_repository.dart';
import 'package:water/repository/user_repository.dart';
import 'Utils/ThemeData/setDefault.dart';
import 'Utils/UtilHelper.dart';
import 'Utils/local_data/app_state.dart';
import 'model/settings_model/setting_model.dart';
import 'repository/setting_repository.dart' as settingRepo;

final get = GetStorage();
GlobalKey<NavigatorState> navkey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  OneSignal.initialize("c2708dac-1973-44d7-9c86-d383e2a1c29e");

  try {
    final id = OneSignal.User.pushSubscription.id;
    if (id != null) {
      // setOnesignalUserId(id);
      await OneSignal.Notifications.requestPermission(true);
    }
    if (get.hasData("current_user")) {
      await getCurrentUser();
    }
    get.write("id", "1");
    get.write('url', '1');
  } catch (e) {}
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

// setOnesignalUserId(String id){
//   get.write('player_id',id);
// }

// String? getOnesignalUserId()  {

//   if (get.hasData('player_id')) {
//     final str = get.read('player_id');
//     appState.deviceTokenId = str;
//     return str;
//   }
// }

class AppThemes {
  static const int Light = 0;
  static const int Dark = 1;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String locationMessage = "";

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationMessage = "Location services are disabled.";
      });
      return;
    }

    // Check location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = "Location permissions are denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get the current location.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Information'),
          content: const Text(
              'We need your location information to navigate drivers to the exact delivery location even when app is closed or not in use.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // OneSignal.User.pushSubscription.addObserver((stateChanges) {
    //      if (!get.hasData('player_id')) {
    //    final status = stateChanges.current.id;
    //    final String? osUserID = status;
    //    if(osUserID!=null){
    //         debugPrint('----------- set Player ID ------------ ');
    //          appState.deviceTokenId = osUserID.toString();
    //          setOnesignalUserId(osUserID);
    //         // updateToken(appState,getOnesignalUserId().toString());
    //      }
    //     }
    //  });
    OneSignal.Notifications.addPermissionObserver((accepted) async {
      if (accepted == true) {
        OneSignal.consentGiven(true);
      } else {
        OneSignal.Notifications.requestPermission(true);
      }
    });

    OneSignal.Notifications.addClickListener((result) async {
      result.preventDefault();

      /// notification.display() to display after preventing default
      result.notification.display();
      await notificationOpener(result);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration.zero, () {
        showLocationPermissionDialog(navkey.currentState!.context);
      });
    });

    _getCurrentLocation();
  }

  Future<void> notificationOpener(OSNotificationClickEvent result,
      {String? id}) async {
    final blog =
        json.decode(result.notification.rawPayload!['custom'].toString())['a']
            ['order_id'];
    //  final action = result.notification.rawPayload!['actionId'];
    // print(result.notification.additionalData!['order_id']);
    if (get.hasData('url')) {
      Future.delayed(Duration(milliseconds: 2000), () {
        //get.remove('url');
        get.write('url', '2');
        Navigator.of(navkey.currentState!.context)
            .pushNamed(RoutePath.track_order, arguments: blog);
      });
    } else {
      Navigator.of(navkey.currentState!.context)
          .pushNamed(RoutePath.track_order, arguments: blog);
    }
    //  Navigator.push(navkey.currentState!.context,
    //  MaterialPageRoute(builder: (context) =>Loader(
    //   product: Product(id:int.parse(blog.toString())),
    //   action: action)));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (get.hasData("language")) {
        String languageCode = get.read("language");
        LanguageItem _languageItem = setting.value.languages!
            .firstWhere((element) => element.languageCode == languageCode);
        appState.languageItem = _languageItem;
        appState.currentLanguageCode.value = _languageItem.languageCode!;
        await settingRepo
            .getKeysLists(appState.currentLanguageCode.value)
            .then((value) {
          appState.languageKeys = value;
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, SettingData _setting, _) {
          return ValueListenableBuilder(
              valueListenable: appState.currentLanguageCode,
              builder: (context, String _languageCode, _) {
                final botToastBuilder = BotToastInit();
                return ValueListenableBuilder(
                    valueListenable: darkMode,
                    builder: (context, theme, child) {
                      // DynamicTheme.of(context)?.setTheme(AppThemes.Light);
                      SystemChrome.setSystemUIOverlayStyle(theme == false
                          ? SystemUiOverlayStyle.dark
                              .copyWith(statusBarColor: Colors.white12)
                          : SystemUiOverlayStyle.light);
                      return MaterialApp(
                        title: "Mama'S Milk",
                        navigatorKey: navkey,
                        theme: theme == true
                            ? themeData(ThemeData.dark(), 1, context)
                            : themeData(ThemeData.light(), 0, context),
                        debugShowCheckedModeBanner: false,
                        themeMode:
                            theme == false ? ThemeMode.light : ThemeMode.dark,
                        locale: Locale(_languageCode),
                        localizationsDelegates: <LocalizationsDelegate<
                            dynamic>>[
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                          // EasyLocalization.of(context)!.delegate,
                          DefaultCupertinoLocalizations.delegate
                        ],
                        onGenerateRoute: RouteGenerator.generateRoute,
                        initialRoute: "/",
                        navigatorObservers: [BotToastNavigatorObserver()],
                        builder: (context, child) {
                          child = botToastBuilder(context, child);
                          child = Directionality(
                            textDirection: UtilsHelper.rightHandLang
                                    .contains(_languageCode)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: child,
                          ); //do something
                          return child;
                        },
                      );
                    });
              });
        });
  }
}
