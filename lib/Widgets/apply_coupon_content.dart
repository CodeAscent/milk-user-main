import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/View/shimmers/offer_list_shimmer.dart';
import 'package:water/Widgets/textField.dart';
import 'package:water/controllers/offer_controller.dart';
import 'package:water/model/offer_item.dart';

class ApplyCouponContent extends StatefulWidget {
  @override
  _ApplyCouponContentState createState() => _ApplyCouponContentState();
}

class _ApplyCouponContentState extends StateMVC<ApplyCouponContent> {
  _ApplyCouponContentState() : super(OfferController()) {
    con = controller as OfferController;
  }

  late OfferController con;

  TextEditingController _couponCode = TextEditingController();

  @override
  void initState() {
    con.getOffersCouponListsApi();
    super.initState();
  }

//  OfferItem getSelectedCoupon() {
  ///Local Search Coupon
//    OfferItem offerItem= OfferItem(id: -1);
//    con.offerList!.forEach((element) {
//      if(element.couponName==_couponCode.text.trim()) {
//        offerItem = element;
//      }
//    });
//    return offerItem;
//  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(9)),
      child: Stack(
        children: [
          Container(
            color: MyColor.coreBackgroundColor,
            width: double.infinity,
            height: 0.67 * size.height,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 41,
                        bottom: 34,
                      ),
                      child: Text(
                        UtilsHelper.getString(context, 'apply_coupon'),
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontFamily:
                                      lang == 'en' ? 'Helvetica' : 'TheSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: dark(context)
                                      ? Colors.white
                                      : MyColor.commonColorSet1,
                                ),
                      ),
                    )
                  ],
                ),
                Stack(
                  children: [
                    wrTextField(
                      context,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      controller: _couponCode,
                      placeholder:
                          UtilsHelper.getString(context, "enter_coupon_code"),
                      lang: lang,
                    ),
                    Positioned(
                      right: lang == 'en' ? 32 : null,
                      left: lang != 'en' ? 32 : null,
                      top: 16,
                      child: GestureDetector(
                        onTap: () async {
                          print('Check pressed');
                          FocusScope.of(context).unfocus();
                          if (_couponCode.text.trim().isNotEmpty) {
                            await con
                                .offersVerifyCodeApi(_couponCode.text.trim());
                            if (con.appliedOfferItem != null) {
                              commonAlertNotification("Success",
                                  message: UtilsHelper.getString(
                                      context, "coupon_apply_successfully"));
                              Navigator.pop(context, con.appliedOfferItem);
                            } else {
                              commonAlertNotification("Error",
                                  message: UtilsHelper.getString(
                                      context, "coupon_not_exist"));
                            }
                          } else {
                            commonAlertNotification("Error",
                                message: UtilsHelper.getString(
                                    context, "enter_coupon_code"));
                          }
                        },
                        child: con.isChecking!
                            ? Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      MyColor.commonColorSet1),
                                ))
                            : Text(
                                UtilsHelper.getString(context, "check"),
                                style: TextStyle(
                                  fontFamily:
                                      lang == 'en' ? 'Helvetica' : 'TheSans',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: dark(context)
                                      ? MyColor.white
                                      : MyColor.commonColorSet1,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      color: dark(context)
                          ? Colors.transparent
                          : MyColor.lightBackground,
                      child: con.offerList == null
                          ? OfferAlertListShimmer()
                          : Column(
                              children:
                                  List.generate(con.offerList!.length, (index) {
                                OfferItem offerItem = con.offerList![index];
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: index == con.offerList!.length - 1
                                          ? 0
                                          : 11),
                                  child: getCouponRow(
                                    code: offerItem.couponName,
                                    sar: '\n' +
                                        UtilsHelper.getString(context, "save") +
                                        " " +
                                        offerItem.getSaveString(
                                            stringAsFixed: 0),
                                    lang: lang,
                                    description: UtilsHelper.getString(
                                            context, "expire_on") +
                                        " " +
                                        offerItem.expireDateTimeDescription(),
                                    onPress: () {
                                      commonAlertNotification("Success",
                                          message: UtilsHelper.getString(
                                              context,
                                              "coupon_apply_successfully"));
                                      Navigator.pop(context, offerItem);
                                    },
                                    size: size,
                                  ),
                                );
                              }),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 23,
                color: MyColor.commonTitleColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getCouponRow(
      {String? code,
      String? sar,
      String? description,
      onPress,
      required Size size,
      required lang}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: dark(context) ? Color.fromRGBO(63, 76, 84, 1) : MyColor.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 95,
              height: 45,
              color: MyColor.commonColorSet2,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: code,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontFamily:
                                  lang == 'en' ? 'Helvetica' : 'TheSans',
                              fontSize: 10,
                              color: dark(context)
                                  ? Colors.white
                                  : MyColor.textPrimaryLightColor,
                              height: 1.8,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                      TextSpan(
                        text: sar,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontFamily:
                                  lang == 'en' ? 'Helvetica' : 'TheSans',
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: dark(context)
                                  ? Colors.white
                                  : MyColor.textPrimaryLightColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: size.width - 255,
              child: Text(
                description ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                    fontSize: 9,
                    color:
                        dark(context) ? Colors.white : MyColor.baseDarkColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            GestureDetector(
              onTap: onPress,
              child: Container(
                width: 75,
                color: MyColor.commonColorSet1,
                child: Center(
                  child: Text(
                    UtilsHelper.getString(context, "apply_coupon_title"),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                          fontSize: 11,
                          color: MyColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
