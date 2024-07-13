import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';

import 'package:water/Widgets/header.dart';
import 'package:water/repository/setting_repository.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: headerWidget(
              title: UtilsHelper.getString(context, 'about_us'),
              onPress: () {
                Navigator.of(context).pop();
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
                      height: 38,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: setting.value.aboutUs?.length??0,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      itemBuilder: (context, index) {
                        return paragraphWidget(
                            title: setting.value.aboutUs![index].pageTitle??"",
                            description: setting.value.aboutUs![index].description??"",
                            size: size,
                            lang: lang);
                      }
                      ),
//                paragraphWidget(
//                    title: setting.value.aboutUs.,
//                    description: lang == 'en' ? _aboutDome : _aboutDomeAr,
//                    size: size,
//                    lang: lang),
//                SizedBox(
//                  height: 20,
//                ),
//                paragraphWidget(
//                    title: UtilsHelper.getString(context, 'our_vission'),
//                    description: lang == 'en' ? _ourVision : _ourVisionAr,
//                    size: size,
//                    lang: lang),
//                SizedBox(
//                  height: 20,
//                ),
//                paragraphWidget(
//                    title: UtilsHelper.getString(context, 'our_mission'),
//                    description: lang == 'en' ? _ourMission : _ourVisionAr,
//                    size: size,
//                    lang: lang),
//                SizedBox(
//                  height: 50,
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: [
//                    Text(
//                      UtilsHelper.getString(context, "all_right_reserve_text"),
//                      style: TextStyle(
//                        fontSize: 12,
//                        fontWeight: FontWeight.normal,
//                      ),
//                    ),
//                  ],
//                ),
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
                color: MyColor.coreBackgroundColor,
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
                        color: MyColor.textPrimaryColor,
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
            color: MyColor.coreBackgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
          ),
          child: html
//          Text(
//            description,
//            style: Theme.of(context).textTheme.headline4?.copyWith(
//                  fontSize: 12,
//                  color: MyColor.aboutUsDescription,
//                ),
//          ),
        ),
      ],
    );
  }
}
