import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/Widgets/select_language_button.dart';
import 'package:water/repository/setting_repository.dart' as settingRepo;
import 'package:water/repository/setting_repository.dart';

import '../main.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.dependOnInheritedWidgetOfExactType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      backgroundColor: MyColor.coreBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Spacer(),
            Container(
              decoration: BoxDecoration(
                  color:
                      dark(context) ? Colors.grey.shade700 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.only(top: 48, bottom: 32),
              // height: size.height / 2.25,
              child: Center(
                child: Image(
                  image: AssetImage('assets/icon/appicon.jpg'),
                  width: size.width / 3,
                ),
              ),
            ),
            Spacer(),
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: dark(context) ? Colors.white : MyColor.commonColorSet1,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Container(
                height: size.height / 2,
                child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            setting.value.languages!.length <= 2 ? 1 : 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 16,
                        childAspectRatio: setting.value.languages!.length <= 2
                            ? 60 / 12
                            : 21 / 9),
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      if (setting.value.languages != null)
                        ...setting.value.languages!.asMap().entries.map((e) {
                          return selectLanguageButton(
                              width: size.width,
                              onPress: () async {
                                appState.languageItem = e.value;
                                get.write("language",
                                    e.value.languageCode.toString());

                                appState.currentLanguageCode.value =
                                    e.value.languageCode!;
                                setState(() {});
                                BotToast.showLoading();

                                await settingRepo
                                    .getKeysLists(
                                        appState.currentLanguageCode.value)
                                    .then((value) {
                                  appState.languageKeys = value;

                                  print("this is value $value");
                                  BotToast.closeAllLoading();
                                  setState(() {});
                                  Navigator.of(context)
                                      .pushNamed(RoutePath.sign_in);
                                });
                                // EasyLocalization.of(context)?.setLocale(
                                //     Locale(
                                //         languageItem.languageCode!,
                                //         languageItem.languageCode == "ar"
                                //             ? 'AE'
                                //             : 'US'));
                                // TODO : Need to add country code in language object in setting api
                              },
                              prefixPath: 'assets/icon_arrow.svg',
                              title: e.value.languageCode == "ar"
                                  ? 'العربية'
                                  : e.value.languageName!.toUpperCase(),
                              // TODO : Need to make dynamic data
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        UtilsHelper.the_sans_font_family,
                                    color: MyColor.textPrimaryLightColor,
                                  ),
                              color: e.key % 2 == 0
                                  ? MyColor.commonColorSet1
                                  : MyColor.commonColorSet2

                              // SizedBox(
                              //   height: 11,
                              // ),

                              );
                        }),
                    ])),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
