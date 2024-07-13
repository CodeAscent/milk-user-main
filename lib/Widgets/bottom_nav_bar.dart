import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/model/product/product_item.dart';

import '../Utils/helper.dart';

Widget bottomNavBar({required BuildContext context}) {
  var lang = appState.currentLanguageCode.value;

  return Container(
    color: Colors.transparent,
    child: Container(
       height: 86,
       width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 5),
      child: Container(
        margin: EdgeInsets.only(bottom: 15,left: 26,right: 26),
         decoration: BoxDecoration(
          color: MyColor.coreBackgroundColor, //coreBackgroundColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
            color: Color.fromRGBO(0, 4, 18, 0.15),
            blurRadius: 20.0,
            offset: Offset(0, -4),
            spreadRadius: 0
            ),
          ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            GestureDetector(
              onTap: () {
                print('Home pressed');
                if (appState.apiToken.isNotEmpty) {
                  Navigator.of(context)
                      .pushReplacementNamed(RoutePath.home_screen);
                } else {
                  Navigator.of(context).pushNamed(RoutePath.sign_in);
                }
              },
              child: TabWidget(lang: lang),
            ),
           
            Container(
              margin: EdgeInsets.only(right: lang == 'en' ? 0 : 13),
              child: GestureDetector(
                onTap: () {
                  print('offer pressed');
                  if (appState.apiToken.isNotEmpty) {
                    Navigator.of(context).pushNamed(RoutePath.offers);
                  } else {
                    Navigator.of(context).pushNamed(RoutePath.sign_in);
                  }
                },
                child:  TabWidget(lang: lang,icon:  "assets/offers.svg",text:  'offer'),
              ),
            ),
             GestureDetector(
      onTap: () {
        if (appState.carts.value.length > 0) {
          print('cart clicked');
          Navigator.of(context).pushNamed(RoutePath.order_detail);
        } else {
          commonAlertNotification("Error",
              message:
                  UtilsHelper.getString(null, "first_add_product_in_cart"));
        }
      },
      child: Tab(
        icon: Container(
           height: 46,
            width: 46,
          decoration: BoxDecoration(
              color: MyColor.bottomNavBar,
             shape: BoxShape.circle
             ),
          child: Stack(
              children: [
                Container(
                   padding: EdgeInsets.all(8),
            child: 
                Center(
                    child: SvgPicture.asset(
                  "assets/cart.svg",
                  colorFilter: ColorFilter.mode(MyColor.mainColor as Color, BlendMode.srcIn),
                  width: 29,
                  height: 29,
                ))),
                Align(
                  alignment: Alignment.center,
                  // left: lang == 'en' ? 12 : 2,
                  // bottom: 0,
                  child:  ValueListenableBuilder<List<Product>>(
                        valueListenable: appState.carts,
                        builder: (context, cartsProducts, child) {
                       return cartsProducts.length != 0 ? CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: 
                           Text(
                            cartsProducts.length.toString(),
                            style: TextStyle(
                                fontFamily:lang == 'en' ? 'Helvetica' : 'TheSans',
                                color:  MyColor.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 11),
                          )): SizedBox();
                        }),
                  
                ),
              ],
            ),
          
        ),
        iconMargin: EdgeInsets.only(bottom: 0),
      ),
    ),
            GestureDetector(
              onTap: () {
                print('order pressed');
                if (appState.apiToken.isNotEmpty) {
                  Navigator.of(context).pushNamed(RoutePath.your_orders);
                } else {
                  Navigator.of(context).pushNamed(RoutePath.sign_in);
                }
              },
              child: TabWidget(lang: lang,icon:  "assets/bag.svg",text:'order_nav')
            ),
            GestureDetector(
              onTap: () {
                // print('profile pressed');
                // if (appState.apiToken.isNotEmpty) {
                Navigator.of(context).pushNamed(RoutePath.my_account);
                // } else {
                //   Navigator.of(context).pushNamed(RoutePath.sign_in);
                // }
              },
              child: TabWidget(lang: lang,icon:   "assets/profile.svg",text:'profile'),
            ),
           
          ],
        ),
      ),
    ),
  );
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key? key,
    required this.lang,
    this.icon,
    this.text,
  }) : super(key: key);

  final String? lang,icon,text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           SvgPicture.asset(
          icon ?? "assets/store.svg",
          colorFilter: ColorFilter.mode(MyColor.bottomNavBar as Color, BlendMode.srcIn), //bottomNavBar,
        ),
         SizedBox(height: appState.languageItem.languageCode == 'ar' ? 2 : 4),
         Text(
          UtilsHelper.getString(context,text ?? 'home_nav'),
          style: TextStyle(
            fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: MyColor.bottomNavBar, //bottomNavBar,
          ),
        ),
        ]
      ),
    );
  }
}
