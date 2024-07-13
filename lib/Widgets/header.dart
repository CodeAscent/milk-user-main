import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/View/search.dart';

Widget headerWidget({required String? title, onPress, required BuildContext context}) {
  var lang = appState.currentLanguageCode.value;

  return SafeArea(
    bottom: false,
    child: Container(
      // height: 70,
      margin: EdgeInsets.only(left: 2, right: 2, bottom: 10,top: 20),
      padding: EdgeInsets.only(right: 6,left: 6,top: 6,bottom: 6),
      decoration: BoxDecoration(
        color: MyColor.coreBackgroundColor,
        borderRadius: BorderRadius.circular(
          30
        ),
        boxShadow: [
          BoxShadow(
            color: MyColor.black!.withOpacity(0.1),
            blurRadius: 9,
            spreadRadius: -8,
            offset: Offset(-3, 5),
          ),
          BoxShadow(
            color: MyColor.black!.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: -8,
            offset: Offset(3, 5),
          ),
        ],
      ),
      child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //  Material(
              //   color: Colors.transparent,
              //    child:Padding(
              //      padding: EdgeInsets.symmetric(horizontal : 16,
              //      vertical:lang != 'en' ? 8 : 16),
              //     child: Ink(
              //      child:
              Backbutt(),
              SizedBox(width:lang != 'en' ? 12 : 0),
              Text(
                title ?? '',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                      color:  MyColor.textPrimaryColor,
                      fontWeight:!UtilsHelper.rightHandLang.contains(lang) ? FontWeight.bold : FontWeight.w400,
                      fontSize:lang != 'en' ? 24 : 22,
                    ),
              ),
                SizedBox(width:lang != 'en' ? 40 : 0),
            ],
          ),
    ),
  );
}
