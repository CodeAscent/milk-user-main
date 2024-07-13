import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/Widgets/CommonButton.dart';
import 'package:water/controllers/auth_controller.dart';

import '../../Widgets/drop_down.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends StateMVC<SignIn> {
  _SignInState() : super(AuthController()) {
    con = controller as AuthController;
  }

  late AuthController con;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UtilsHelper.loadLocalization(appState.currentLanguageCode.value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;
    print(lang);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            UtilsHelper.getString(context, 'sign_in'),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                    ? UtilsHelper.wr_default_font_family
                    : UtilsHelper.the_sans_font_family,
                fontSize: 28,
                color: MyColor.textPrimaryColor,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.symmetric(horizontal: 27),
            decoration: BoxDecoration(
              color: MyColor.coreBackgroundColor,
              //     boxShadow: [
              //       BoxShadow(
              //  color: Colors.grey.shade300,
              //  offset: Offset(0, 4), //(x,y)
              //  blurRadius: 9,
              //       ),
              //     ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox.fromSize(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 32,
                      ),
                      // Positioned(
                      //     top: 30,
                      //     right: 0,
                      //     child: SafeArea(
                      //       child: InkWell(
                      //         onTap: () {
                      //           appState.apiToken = "";
                      //           setCurrentUser(
                      //               {"id": -1, "api_token": ""});
                      //           Navigator.of(context)
                      //               .pushNamedAndRemoveUntil(
                      //                   RoutePath.home_screen,
                      //                   (Route<dynamic> route) => false);
                      //         },
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(6),
                      //               bottomLeft: Radius.circular(6)),
                      //           child: Container(
                      //             color: MyColor.commonColorSet1!,
                      //             padding: EdgeInsets.symmetric(
                      //                 horizontal: 15, vertical: 4),
                      //             child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.start,
                      //               textDirection: TextDirection.ltr,
                      //               children: [
                      // Text(
                      //   UtilsHelper.getString(
                      //       context, 'skip'),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .bodyLarge
                      //       ?.copyWith(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: !UtilsHelper
                      //                 .rightHandLang
                      //                 .contains(lang)
                      //             ? UtilsHelper
                      //                 .wr_default_font_family
                      //             : UtilsHelper
                      //                 .the_sans_font_family,
                      //         color: MyColor
                      //             .textPrimaryLightColor,
                      //       ),
                      // )
                      //     ],
                      //   ),
                      // ),
                      //   ),
                      // ),
                      // ))
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 36, right: 36),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            UtilsHelper.getString(
                                context, 'sign_in_description'),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontFamily:
                                      !UtilsHelper.rightHandLang.contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                  fontSize: 16,
                                  height:
                                      !UtilsHelper.rightHandLang.contains(lang)
                                          ? 1.3
                                          : 1,
                                  color: MyColor.descriptionColor,
                                  fontWeight: FontWeight.normal,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                      height: 52,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                              Theme.of(context).brightness != Brightness.light
                                  ? Color.fromRGBO(63, 76, 84, 1)
                                  : Colors.white),
                      child: Column(
                        children: [
                          Row(
                            textDirection: TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                child: Row(children: [
                                  SvgPicture.asset(
                                    "assets/phone.svg",
                                    //  fit: BoxFit.scaleDown,
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                        dark(context)
                                            ? Colors.white
                                            : MyColor.iconColor as Color,
                                        BlendMode.srcIn),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 0, bottom: 0),
                                      child: DropDownCon(),
                                    ),
                                  ),
                                ]),
                              ),
                              Expanded(
                                child: Container(
                                  //  width: size.width * 0.84 - 120,
                                  height: 52,
                                  child: TextFormField(
                                    onTap: () {},
                                    autofocus: true,
                                    maxLength: 10,
                                    controller: con.numberController,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      hintText: UtilsHelper.getString(
                                          context, 'phone_number'),
                                      // prefixText:  ',
                                      prefixIconConstraints:
                                          BoxConstraints(maxWidth: 0),
                                      prefixStyle: TextStyle(
                                          fontSize: 16,
                                          color: MyColor.commonColorSet1),
                                      hintTextDirection: TextDirection.ltr,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 0,
                                          right: 22,
                                          top: 10,
                                          bottom: 6),
                                      hintStyle: TextStyle(
                                        color: dark(context)
                                            ? Colors.white
                                            : MyColor.baseDarkColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: dark(context)
                                            ? Colors.white
                                            : MyColor.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      // Center(
                      //   child: TextFormField(
                      //     onTap: () {},
                      //     controller: _mobilePhone,
                      //     decoration: InputDecoration(
                      //       hintText: '05x  xxx xxxx',
                      //       border: InputBorder.none,
                      //       contentPadding: EdgeInsets.only(top: 16),
                      //       prefixIcon: Container(
                      //         child: SvgPicture.asset(
                      //           "assets/phone.svg",
                      //           fit: BoxFit.scaleDown,
                      //           color: MyColor.iconColor,
                      //         ),
                      //       ),
                      //       hintStyle: TextStyle(
                      //         color: MyColor.baseDarkColor,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.normal,
                      //       ),
                      //     ),
                      //     style: TextStyle(
                      //         fontSize: 16, color: MyColor.black),
                      //   ),
                      // ),
                      ),
                  // wrTextField(
                  //     controller: _mobilePhone,
                  //     placeholder: UtilsHelper.getString(
                  //         context, '05x  xxx xxxx'),
                  //     prefixPath: "assets/phone.svg"),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: commonButton(
                      onPress: () {
                        con.sendOtpApiCall(context);
                      },
                      prefixPath: 'assets/icon_arrow.svg',
                      title: UtilsHelper.getString(context, 'verify'),
                      textStyle:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontFamily:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? UtilsHelper.wr_default_font_family
                                        : UtilsHelper.the_sans_font_family,
                                color: MyColor.textPrimaryLightColor,
                                fontSize: 16,
                                fontWeight:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? FontWeight.w700
                                        : FontWeight.w400,
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
          Spacer(flex: 2)
        ],
      ),
    );
  }
}
