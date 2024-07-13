import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/link_launcher.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/repository/setting_repository.dart';

import '../../Utils/rgbo_to_hex.dart';

class ReachUs extends StatefulWidget {
  const ReachUs({Key? key}) : super(key: key);

  @override
  _ReachUsState createState() => _ReachUsState();
}

class _ReachUsState extends State<ReachUs> {
  final LinkLauncher _linkLauncher = LinkLauncher();
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
              title: UtilsHelper.getString(context, 'Reach Us'),
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
                    color: dark(context)
                        ? MyColor.baseDarkColor
                        : Color.fromRGBO(240, 244, 248, 1),
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 38,
                    ),
                    paragraphWidget(
                        title: "Reach Us",
                        description:
                            "Reach Us\n+91 96193 47250\n\nhelp@mamasmilkfarm.com\n\nMon - Sun 09:00 - 18:00\n\n(except public holidays)\n\nMama's Milk Farm, Plot no. 64/4 & 61/3 Usroli Bhiwandi, Near Shangrila Resort, Thane, Maharashtra, 421302",
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
                        fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                            ? UtilsHelper.wr_default_font_family
                            : UtilsHelper.the_sans_font_family,
                        fontSize: 18,
                        color: dark(context)
                            ? Colors.white
                            : MyColor.textPrimaryColor,
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
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.call,
                    color: MyColor.commonColorSet2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Reach Us\n+91 96193 47250",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 16,
                          color: MyColor.aboutUsDescription,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.email,
                    color: MyColor.commonColorSet2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "help@mamasmilkfarm.com",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 16,
                          color: MyColor.aboutUsDescription,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.timer,
                    color: MyColor.commonColorSet2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Mon - Sun 09:00 - 18:00\n(except public holidays)",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 16,
                          color: MyColor.aboutUsDescription,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: MyColor.commonColorSet2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Mama's Milk Farm,\nPlot no. 64/4 & 61/3 Usroli \nBhiwandi,\nNear Shangrila Resort,\nThane, Maharashtra, 421302",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 16,
                          color: MyColor.aboutUsDescription,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _linkLauncher
                          .launchURL('https://www.facebook.com/mamasmilkfarm/');
                    },
                    child: Image.asset(
                      "assets/icon/facebook.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _linkLauncher.launchURL(
                          'https://www.instagram.com/mamasmilkfarm/');
                    },
                    child: Image.asset(
                      "assets/icon/instagram.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _linkLauncher.launchURL(
                          'https://www.linkedin.com/company/mama-s-milk-farm/');
                    },
                    child: Image.asset(
                      "assets/icon/linkedIn.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _linkLauncher.launchURL('https://wa.me/919619347250');
                    },
                    child: Image.asset(
                      "assets/icon/WhatsApp.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 60,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       UtilsHelper.getString(context, "all_right_reserve_text"),
        //       style: TextStyle(
        //         fontFamily: !UtilsHelper.rightHandLang.contains(lang)
        //             ? UtilsHelper.wr_default_font_family
        //             : UtilsHelper.the_sans_font_family,
        //         fontSize: 12,
        //         fontWeight: FontWeight.normal,
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }
}
