import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';

import 'CommonButton.dart';

class EmptyOfferScreen extends StatelessWidget {
  final GestureTapCallback onTap;

  EmptyOfferScreen({required this.onTap});

  @override
  Widget build(BuildContext context) {

    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              child: Center(
                  child: SvgPicture.asset("assets/empty_offers.svg")),
            ),
            SizedBox(height: 60),
            Text(
              UtilsHelper.getString(context, "no_offers"),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color:dark(context) ? MyColor.white : MyColor.commonColorSet1),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                UtilsHelper.getString(context, "please_follow_our_offers_later"),
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                    fontSize: 13,
                    color: MyColor
                        .textSecondarySecondLightColor),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 27),
              child: commonButton(
                onPress: onTap,
                prefixPath: 'assets/icon_arrow.svg',
                title: UtilsHelper.getString(context, 'go_to_home'),
                textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                  color: MyColor.textPrimaryLightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                color: MyColor.darkYellow,
              ),
            )
          ],
        ),
      ),
    );
  }
}
