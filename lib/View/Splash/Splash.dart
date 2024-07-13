import 'package:flutter/material.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/local_data/local_data_storage.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/controllers/auth_controller.dart';
import 'package:water/main.dart';
import 'package:water/model/settings_model/setting_model.dart';
import 'package:water/repository/setting_repository.dart' as settingRepo;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = AuthController();
  LocalDataStorage? localDataStorage;

  @override
  void initState() {
    super.initState();
    localDataStorage = LocalDataStorage();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print("Splash Screen");
      print(get.hasData('url').toString());
      print(get.read('url').toString());
      // Future.delayed(const Duration(milliseconds: 2000), () async {
      await settingRepo.initSettings().then((value) async {
        if (get.hasData("language")) {
          String languageCode = get.read("language");
          LanguageItem _languageItem = value.languages!
              .firstWhere((element) => element.languageCode == languageCode);
          appState.languageItem = _languageItem;
          appState.currentLanguageCode.value = _languageItem.languageCode!;
          appState.languageKeys = await settingRepo
              .getKeysLists(appState.currentLanguageCode.value);
          setState(() {});
          // EasyLocalization.of(context)?.setLocale(
          //   Locale(
          //       _languageItem.languageCode!,
          //       _languageItem.languageCode == "ar" ? 'AE' : 'US'));
        }

        if (appState.userModel.id != null) {
          //await getCurrentUser();
          localDataStorage!.retrieveProduct();
          if (get.hasData('url') && get.read('url') != '2') {
            Navigator.of(context).pushNamedAndRemoveUntil(
                RoutePath.home_screen, (Route<dynamic> route) => false);
          }
        } else {
          print("I am Here");
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutePath.selectLanguage, (Route<dynamic> route) => false);
        }
      });
      // });
    });
  }

  @override
  void dispose() {
    authController.notificationInit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyColor.loadColor(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    hexToRgb('#EDC7F0'),
                    Colors.white,
                    Colors.white,
                    hexToRgb('#EDC8F0'),
                  ]))),
          Positioned(
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icon/appicon.jpg",
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 90),
                // Text('مياه نقية طبيعية',
                //     style: TextStyle(
                //         fontFamily: 'TheSans',
                //         fontSize: 24,
                //         fontWeight: FontWeight.w400,
                //         color: MyColor.commonColorSet2)),
                Text("Mama's Milk",
                    style: TextStyle(
                        fontFamily: 'TheSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: MyColor.commonColorSet1))
              ],
            )),
          ),
        ],
      ),
    );
    //   SafeArea(
    //   child: Scaffold(
    //     backgroundColor: MyColor.coreBackgroundColor,
    //     body: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Center(
    //           child: SvgPicture.asset("assets/logo.svg"),
    //         ),
    //         SizedBox(
    //           height: 112,
    //         ),
    //         Center(
    //           child: RichText(
    //             textAlign: TextAlign.center,
    //             text: TextSpan(
    //               children: [
    //                 TextSpan(
    //                   text: "مياه نقية طبيعية",
    //                   style: Theme.of(context).textTheme.bodyText1?.copyWith(
    //                         fontFamily: 'GEDinarOne',
    //                         fontSize: 23,
    //                         color: MyColor.commonColorSet2,
    //                         height: 1.8,
    //                       ),
    //                 ),
    //                 TextSpan(
    //                   text: "\nNATURAL PURE WATER",
    //                   style: Theme.of(context).textTheme.bodyText1?.copyWith(
    //                         fontFamily: "DINNextLTArabic",
    //                         fontSize: 21,
    //                         color: MyColor.commonColorSet1,
    //                       ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
