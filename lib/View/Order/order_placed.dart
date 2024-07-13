import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Widgets/CommonButton.dart';

import '../../Utils/rgbo_to_hex.dart';

class OrderPlaced extends StatefulWidget {
  final String orderNumber;
  const OrderPlaced({Key? key, required this.orderNumber}) : super(key: key);

  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  late Timer timer;
  int sec = 6;

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (sec == 1) {
        setState(() {
          timer.cancel();
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RoutePath.home_screen, (route) => false);
      } else {
        setState(() {
          sec -= 1;
        });
      }
      //  });
    });
    super.initState();
  }

  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<bool> _onBackPressed(didpop) async {
    Navigator.of(context).pushReplacementNamed(RoutePath.home_screen);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 3)).then((value) =>
    //     Navigator.of(context).pushReplacementNamed(RoutePath.home_screen));
    var lang = appState.currentLanguageCode.value;

    return PopScope(
        canPop: false,
        onPopInvoked: _onBackPressed,
        child: Scaffold(
            body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    hexToRgb('#359ed8'),
                    Colors.white,
                    Colors.white,
                    hexToRgb('#359ed8'),
                  ]))),
          Positioned(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 250,
                        width: 250,
                        padding: EdgeInsets.all(32),
                        color: hexToRgb('#AF7AB3').withOpacity(0.2),
                        child: Center(
                            child: SvgPicture.asset(
                          "assets/order-success.svg",
                        )),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      UtilsHelper.getString(context, "order_placed"),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontFamily:
                                  !UtilsHelper.rightHandLang.contains(lang)
                                      ? UtilsHelper.wr_default_font_family
                                      : UtilsHelper.the_sans_font_family,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: MyColor.commonColorSet1),
                    ),
                    SizedBox(height: 10),
                    Text(
                      UtilsHelper.getString(context, "your_order_number_is"),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontFamily:
                                  !UtilsHelper.rightHandLang.contains(lang)
                                      ? UtilsHelper.wr_default_font_family
                                      : UtilsHelper.the_sans_font_family,
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.7)),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      "#${widget.orderNumber}",
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontFamily:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? 'Helvatica'
                                        : 'TheSans',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        UtilsHelper.getString(context,
                            "your_will_be_directed_to_the_home_page_automatically"),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontFamily:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? UtilsHelper.wr_default_font_family
                                        : UtilsHelper.the_sans_font_family,
                                fontSize: 12,
                                color: MyColor.black),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                        "${UtilsHelper.getString(context, 'redirecting_in')} ${sec.toString()} seconds",
                        style: TextStyle(
                          fontFamily: 'Helvatica',
                          fontSize: 16,
                        )),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 27),
                      child: commonButton(
                        onPress: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RoutePath.home_screen, (route) => false);
                        },
                        prefixPath: 'assets/icon_arrow.svg',
                        title: UtilsHelper.getString(context, 'go_to_home'),
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontFamily:
                                      !UtilsHelper.rightHandLang.contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                  color: MyColor.textPrimaryLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                        color: MyColor.commonColorSet2,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ])));
  }
}
