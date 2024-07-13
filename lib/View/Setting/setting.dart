import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/text_input_formatter.dart';
import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/bottom_nav_bar.dart';
import 'package:water/Widgets/custom_switch.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/Widgets/select_language_button.dart';
import 'package:water/Widgets/textField.dart';
import 'package:water/controllers/auth_controller.dart';
import 'package:water/controllers/setting_controller.dart';
import 'package:water/model/contact_us_item.dart';
import 'package:water/model/settings_model/language_item.dart';
import 'package:water/repository/setting_repository.dart' as settingRepo;
import 'package:water/repository/setting_repository.dart';
import 'package:water/repository/user_repository.dart';

import '../../Utils/rgbo_to_hex.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends StateMVC<Settings> {
  _SettingsState() : super(SettingController()) {
    con = controller as SettingController;
  }

  late SettingController con;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emaiController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    // var lang = Localizations.localeOf(context).languageCode;
    var lang = appState.currentLanguageCode.value;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RoutePath.home_screen);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: headerWidget(
                    title: UtilsHelper.getString(context, 'setting'),
                    onPress: () {
                      Navigator.pop(context);
                    },
                    context: context,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 31,
                          ),
                          settingRow(
                            prefixPath: "assets/icon_orders.svg",
                            title: UtilsHelper.getString(context, 'your_order'),
                            lang: lang,
                            onPress: () {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.your_orders);
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ValueListenableBuilder(
                              valueListenable: darkMode,
                              builder: (context, mode, child) {
                                return settingRow(
                                  prefixPath: "assets/bulb_icon.svg",
                                  title: UtilsHelper.getString(
                                      context, 'dark_mode'),
                                  lang: lang,
                                  suffixWidget: CustomSwitch(
                                    isDark: darkMode.value,
                                  ),
                                  // Switch(
                                  //     value: _isDark,
                                  //     onChanged: (e) {
                                  //       print(e);
                                  //       setState(() {
                                  //         _isDark = e;
                                  //       });
                                  //     }),
                                  onPress: () {},
                                );
                              }),
                          SizedBox(
                            height: 4,
                          ),
                          settingRow(
                            prefixPath: "assets/offers.svg",
                            title: UtilsHelper.getString(context, 'offers'),
                            lang: lang,
                            onPress: () {
                              Navigator.of(context).pushNamed(RoutePath.offers);
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          settingRow(
                            prefixPath: "assets/wallet_icon.svg",
                            title: UtilsHelper.getString(context, 'balance'),
                            lang: lang,
                            onPress: () {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.wallet_screen);
                            },
                          ),
                          SizedBox(
                            height: 58,
                          ),
                          settingRow(
                            prefixPath: "assets/about_icon.svg",
                            title: UtilsHelper.getString(context, 'about_us'),
                            lang: lang,
                            onPress: () {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.about_us);
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          settingRow(
                            prefixPath: "assets/messaging.svg",
                            title: UtilsHelper.getString(context, 'contact_us'),
                            lang: lang,
                            onPress: () {
                              contactUsBottomSheet(lang: lang);
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          settingRow(
                            prefixPath: "assets/terms_icon.svg",
                            title: UtilsHelper.getString(
                                context, 'term_and_condition'),
                            lang: lang,
                            onPress: () {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.term_and_condition);
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          settingRow(
                            prefixPath: "assets/terms_icon.svg",
                            title: UtilsHelper.getString(context, 'Reach Us'),
                            lang: lang,
                            onPress: () {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.reach_us);
                            },
                          ),
                          SizedBox(
                            height: 58,
                          ),
                          settingRow(
                            prefixPath: "assets/internet.svg",
                            title: UtilsHelper.getString(context, 'language'),
                            lang: lang,
                            onPress: () {
                              selectLanguageBottomSheet(lang: lang);
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          settingRow(
                            prefixPath: "assets/sign_out.svg",
                            title: UtilsHelper.getString(context, 'sign_out'),
                            lang: lang,
                            onPress: () {
                              AuthController authController = AuthController();
                              FirebaseAuth.instance.signOut();
                              // logoutLocalUser();
                              authController.userLogoutApiCall(context);
                              //  Navigator.of(context).pushNamedAndRemoveUntil(
                              //    RoutePath.sign_in, (Route<dynamic> route) => false);
                            },
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(bottom: 0, child: bottomNavBar(context: context)),
          ],
        ),
      ),
    );
  }

  Future<dynamic> contactUsBottomSheet({required lang}) {
    _nameController.clear();
    _emaiController.clear();
    _mobileController.clear();
    _noteController.clear();
    return showModalBottomSheet(
      context: context,
      backgroundColor: MyColor.transparent,
      isScrollControlled: true,
      builder: (context) => SizedBox.fromSize(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 26),
              decoration: BoxDecoration(
                color: MyColor.coreBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              // padding: EdgeInsets.only(top: 43),
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        UtilsHelper.getString(context, 'contact_us'),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontFamily:
                                      !UtilsHelper.rightHandLang.contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                  fontSize: 24,
                                  color: MyColor.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  wrTextField(context,
                      controller: _nameController,
                      placeholder: UtilsHelper.getString(context, 'your_name'),
                      prefixPath: "assets/user.svg",
                      lang: lang),
                  SizedBox(
                    height: 15,
                  ),
                  wrTextField(
                    context,
                    controller: _emaiController,
                    keyboardType: TextInputType.emailAddress,
                    placeholder:
                        UtilsHelper.getString(context, 'email_address'),
                    prefixPath: "assets/mail_icon.svg",
                    lang: lang,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  wrTextField(
                    context,
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxxxxxxxx',
                        separator: '',
                      ),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onvalidate: (p0) {
                      if (p0!.isEmpty) {
                        return UtilsHelper.getString(
                            context, 'mobile_number_is_required');
                      } else if (p0.isNotEmpty &&
                          (p0.length < 6 && p0.length > 10)) {
                        return UtilsHelper.getString(
                            context, 'valid_mobile_number_is_required');
                      }
                      return null;
                    },
                    placeholder:
                        UtilsHelper.getString(context, 'mobile_number'),
                    prefixPath: "assets/phone.svg",
                    lang: lang,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: MyColor.white,
                      // dark(context)
                      //     ? Color.fromRGBO(63, 76, 84, 1)
                      //     : MyColor.lightBackground
                    ),
                    child: TextFormField(
                      onTap: () {},
                      controller: _noteController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // prefixIcon: Container(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       SvgPicture.asset(
                        //         "assets/note.svg",
                        //         fit: BoxFit.scaleDown,
                        //         color: MyColor.iconColor,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        hintText: UtilsHelper.getString(context, 'note'),
                        hintStyle: TextStyle(
                          fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                              ? UtilsHelper.wr_default_font_family
                              : UtilsHelper.the_sans_font_family,
                          color: dark(context)
                              ? MyColor.white
                              : MyColor.baseDarkColor,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 50, top: 16),
                        labelStyle: TextStyle(
                          color: MyColor.baseDarkColor,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: TextStyle(fontSize: 16, color: MyColor.black),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: commonButton(
                      onPress: () {
                        if (validateContactForm(context)) {
                          ContactItem contactItem = ContactItem(
                              name: _nameController.text.trim(),
                              email: _emaiController.text.trim(),
                              mobile: _mobileController.text.trim(),
                              message: _noteController.text.trim());
                          con.contactUsApi(context, contactItem);
                        }
                      },
                      prefixPath: 'assets/icon_arrow.svg',
                      title: UtilsHelper.getString(context, 'send'),
                      textStyle:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontFamily:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? UtilsHelper.wr_default_font_family
                                        : UtilsHelper.the_sans_font_family,
                                color: MyColor.textPrimaryLightColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                      color: MyColor.commonColorSet2,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> selectLanguageBottomSheet({required lang}) {
    return showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 26, vertical: 30),
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 24,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : MyColor.mainColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    UtilsHelper.getString(context, "select_language"),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                              ? UtilsHelper.wr_default_font_family
                              : UtilsHelper.the_sans_font_family,
                          color: MyColor.textPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 51,
                  ),
                  if (setting.value.languages != null)
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: setting.value.languages!.length,
                        itemBuilder: (context, index) {
                          LanguageItem languageItem =
                              setting.value.languages![index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              selectLanguageButton(
                                onPress: () async {
                                  print(languageItem.languageName);
                                  appState.languageItem = languageItem;
                                  final get = GetStorage();
                                  get.write(
                                      "language", languageItem.languageCode);
                                  appState.currentLanguageCode.value =
                                      languageItem.languageCode!;
                                  showLoader();
                                  appState.languageKeys =
                                      await settingRepo.getKeysLists(
                                          appState.currentLanguageCode.value);
                                  print(appState.languageKeys);
                                  print("appState.currentLanguageCode.value");
                                  print(appState.currentLanguageCode.value);
                                  hideLoader();
                                  setState(() {});
                                  // EasyLocalization.of(context)?.setLocale(
                                  //     Locale(
                                  //         languageItem.languageCode!,
                                  //         languageItem.languageCode == "ar"
                                  //             ? 'AE'
                                  //             : 'US'));
                                  Navigator.of(context).pop();
                                },
                                prefixPath: 'assets/icon_arrow.svg',
                                title: languageItem.languageName!.toUpperCase(),
                                borderColor:
                                    appState.currentLanguageCode.value ==
                                            languageItem.languageCode
                                        ? MyColor.coreBackgroundColor
                                        : Colors.white38,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          UtilsHelper.the_sans_font_family,
                                      color: MyColor.textPrimaryLightColor,
                                    ),
                                color: appState.currentLanguageCode.value ==
                                        languageItem.languageCode
                                    ? MyColor.commonColorSet1
                                    : MyColor.commonColorSet2,
                              ),
                              SizedBox(
                                height:
                                    index == setting.value.languages!.length - 1
                                        ? 0
                                        : 20,
                              ),
                            ],
                          );
                        }),
                  // selectLanguageButton(
                  //   onPress: () async {
                  //     print('arabic');
                  //     appState.currentLanguageCode.value = "ar";
                  //     appState.languageKeys = await settingRepo.getKeysLists(appState.currentLanguageCode.value);
                  //     setState(() {});
                  //     // EasyLocalization.of(context)
                  //     //     ?.setLocale(Locale('ar', 'AE'));
                  //     // Navigator.of(context).pushNamed(RoutePath.home_screen);
                  //   },
                  //   prefixPath: 'assets/icon_arrow.svg',
                  //   title: 'العربية',
                  //   textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                  //         color: MyColor.textPrimaryLightColor,
                  //       ),
                  //   color: MyColor.commonColorSet1,
                  // ),
                  // SizedBox(
                  //   height: 11,
                  // ),
                  // selectLanguageButton(
                  //   onPress: () async {
                  //     print('english');
                  //     appState.currentLanguageCode.value = "en";
                  //     appState.languageKeys = await settingRepo.getKeysLists(appState.currentLanguageCode.value);
                  //     setState(() {
                  //       // context.setLocale(Locale('en', 'US'));
                  //       // EasyLocalization.of(context)
                  //       //     ?.setLocale(Locale('en', 'US'));
                  //     });
                  //     // Navigator.of(context).pushNamed(RoutePath.home_screen);
                  //   },
                  //   prefixPath: 'assets/icon_arrow.svg',
                  //   title: 'ENGLISH',
                  //   textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                  //         color: MyColor.textPrimaryLightColor,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //   color: MyColor.darkYellow,
                  // ),
                  // SizedBox(
                  //   height: 27,
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget settingRow(
      {String? prefixPath,
      String? title,
      Widget? suffixWidget,
      onPress,
      required lang}) {
    return GestureDetector(
      onTap: onPress,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          // height: 60,
          padding: EdgeInsets.symmetric(vertical: 16),
          color: MyColor.coreBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    right: !UtilsHelper.rightHandLang.contains(lang) ? 6 : 18,
                    left: !UtilsHelper.rightHandLang.contains(lang) ? 18 : 6),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: SvgPicture.asset(
                      prefixPath ?? "",
                      color: Theme.of(context).brightness == Brightness.light
                          ? MyColor.commonColorSet1
                          : MyColor.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title ?? "",
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontFamily:
                                      !UtilsHelper.rightHandLang.contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: dark(context) == false
                                      ? hexToRgb('#5F6D79')
                                      : MyColor.textPrimaryDarkColor
                                          ?.withOpacity(0.8),
                                ),
                      ),
                      // Icon(Icons.keyboard_arrow_down),
                      suffixWidget != null
                          ? suffixWidget
                          : Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: RotatedBox(
                                quarterTurns:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? 2
                                        : 0,
                                child: SvgPicture.asset(
                                  'assets/icon-chevron.svg',
                                  color: MyColor.textPrimaryColor
                                      ?.withOpacity(0.5),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateContactForm(BuildContext context) {
    if (_nameController.text.trim().isEmpty) {
      commonAlertNotification("Error",
          message: UtilsHelper.getString(context, "enter_your_name"));
      return false;
    }
    if (_emaiController.text.trim().isEmpty) {
      commonAlertNotification("Error",
          message: UtilsHelper.getString(context, "enter_your_email"));
      return false;
    }
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_emaiController.text)) {
      commonAlertNotification("Error",
          message: UtilsHelper.getString(context, "enter_valid_email"));
      return false;
    }
    if (_mobileController.text.trim().length < 10) {
      commonAlertNotification("Error",
          message: UtilsHelper.getString(context, "enter_your_mobile"));
      return false;
    }
    return true;
  }
}
