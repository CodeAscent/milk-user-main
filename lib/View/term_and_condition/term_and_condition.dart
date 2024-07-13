import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/repository/setting_repository.dart';

import '../../Utils/rgbo_to_hex.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({Key? key}) : super(key: key);

  @override
  _TermAndConditionState createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: headerWidget(
              title: UtilsHelper.getString(context, 'about_us'),
              onPress: () {
                Navigator.of(context).pop();
              },
              context: context,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: dark(context) ? MyColor.baseDarkColor : Color.fromRGBO(240, 244, 248, 1),
                  borderRadius: BorderRadius.circular(12)
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 38,
                    ),
                    paragraphWidget(
                        title: setting.value.terms?.pageTitle??"",
                        description: setting.value.terms?.description??"",
                        size: size,
                        lang: lang),
                    SizedBox(
                      height: 38,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paragraphWidget(
      {required String title,
      required String description,
      required Size size,
      required lang}) {
    Widget html = Html(
      data: description,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              // width: size.width * 0.38,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                // color: MyColor.mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                        fontSize: 18,
                        color:dark(context) ? Colors.white : MyColor.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 31),
          decoration: BoxDecoration(
            // color: MyColor.mainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
          ),
          child: html
//          Text(
//            lang == 'en' ? description : _termAR,
//            style: Theme.of(context).textTheme.headline4?.copyWith(
//                  fontSize: 12,
//                  color: MyColor.aboutUsDescription,
//                ),
//          ),
        ),
        SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              UtilsHelper.getString(context, "all_right_reserve_text"),
              style: TextStyle(
                fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        )
      ],
    );
  }
}
