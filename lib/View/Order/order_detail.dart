import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/utils.dart';
import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/apply_coupon_content.dart';
import 'package:water/Widgets/cart_product_widget.dart';
import 'package:water/Widgets/empty_cart_screen.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/controllers/cart_controller.dart';
import 'package:water/model/product/product.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends StateMVC<OrderDetail> {
  _OrderDetailState() : super(CartController()) {
    con = controller as CartController;
  }

  late CartController con;

  int selectedIndex = 0;
  DateTime? fromDate;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    appState.subTotal = 0;
    appState.finalTotal = 0;
    appState.vat = 0;
    appState.delivery = 0;
    appState.offerItem = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColor.mainColor,
      body: ValueListenableBuilder<List<Product>>(
          valueListenable: appState.carts,
          builder: (context, cartsProducts, child) {
            appState.subTotal = 0;
            double? singlePrice = 0;
            for (int i = 0; i < cartsProducts.length; i++) {
              singlePrice = 0;
              Product _product = cartsProducts[i];
              double price = (_product.discountPrice != null &&
                      _product.discountPrice! > 0)
                  ? _product.discountPrice! 
                  : (_product.price ?? 0);
              singlePrice = price * _product.quantity;
              appState.subTotal += singlePrice * _product.getFrequencyCount();
            }
            appState.finalTotal = appState.subTotal;
            appState.finalTotal += appState.defaultTax;
            appState.finalTotal += appState.shippingCharge;
    
            if ((appState.offerItem) != null) {
              if (appState.finalTotal <
                  (appState.offerItem?.minimumOrderValue ?? 0)) {
                appState.offerItem = null;
                commonAlertNotification("Error",
                    message: UtilsHelper.getString(
                        context, "this_coupon_code_does_not_apply"));
              } else {
                DateTime now = DateTime.now();
                if (appState.offerItem!.startDate!.isBefore(now) &&
                    appState.offerItem!.endDate!.isAfter(now)) {
                  double _amount = appState.subTotal +
                      appState.defaultTax +
                      appState.shippingCharge;
                  if (appState.offerItem?.type == "Fixed") {
                    appState.offerItem!.discountPrice =
                        appState.offerItem!.value!.toDouble();
                    appState.finalTotal =
                        _amount - appState.offerItem!.value!.toDouble();
                  } else if (appState.offerItem?.type == "Percent") {
                    appState.offerItem!.discountPrice =
                        (_amount * appState.offerItem!.value!) / 100;
                    appState.finalTotal =
                        _amount - appState.offerItem!.discountPrice!;
                  }
                } else {
                  appState.offerItem = null;
                  commonAlertNotification("Error",
                      message: UtilsHelper.getString(
                          context, "this_coupon_code_does_not_valid_now"));
                }
              }
            }
    
            return appState.carts.value.length > 0
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: headerWidget(
                          title:
                              UtilsHelper.getString(context, 'order_details'),
                          onPress: () {
                            Navigator.of(context).pop();
                          },
                          context: context,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 27, vertical: 15),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: appState.carts.value.length,
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      Product product =
                                          appState.carts.value[index];
                                      return CartProductWidget(
                                        index: index,
                                        product: product,
                                        isSelected: selectedIndex == index,
                                        close: () {
                                          selectedIndex = -1;
                                          setState(() {});
                                        },
                                        open: () {
                                          selectedIndex = index;
                                          setState(() {});
                                        },
                                      );
                                    }),
                                SizedBox(
                                  height: 30,
                                ),
                                getRow(
                                  key: UtilsHelper.getString(
                                      context, 'sub_total'),
                                  lang: lang,
                                  value: UtilsHelper.getString(context,
                                      displayPriceDouble(appState.subTotal)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                getRow(
                                  key: UtilsHelper.getString(context, 'vat'),
                                  lang: lang,
                                  value: UtilsHelper.getString(context,
                                      displayPriceDouble(appState.defaultTax)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                getRow(
                                  key: UtilsHelper.getString(
                                      context, 'delivery'),
                                  lang: lang,
                                  value: UtilsHelper.getString(
                                      context,
                                      displayPriceDouble(
                                          appState.shippingCharge)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                getRow(
                                  key: UtilsHelper.getString(
                                      context, 'coupon_discount'),
                                  lang: lang,
                                  suffixWidget: GestureDetector(
                                    onTap: () async {
                                      dynamic offerItem = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          contentPadding: EdgeInsets.zero,
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          content: ApplyCouponContent(),
                                        ),
                                      );
                                      if (offerItem != null &&
                                          offerItem.id != -1) {
    //                            TODO: perform calculation of applying coupon
                                        appState.offerItem = offerItem;
                                        if (appState.finalTotal <
                                            (appState.offerItem
                                                    ?.minimumOrderValue ??
                                                0)) {
                                          commonAlertNotification("Error",
                                              message: UtilsHelper.getString(
                                                  context,
                                                  "this_coupon_code_does_not_apply"));
                                        } else {
                                          DateTime now = DateTime.now();
                                          if (appState.offerItem!.startDate!
                                                  .isBefore(now) &&
                                              appState.offerItem!.endDate!
                                                  .isAfter(now)) {
                                            double _amount = appState.subTotal +
                                                appState.defaultTax +
                                                appState.shippingCharge;
                                            if (appState.offerItem?.type ==
                                                "Fixed") {
                                              appState.offerItem!
                                                      .discountPrice =
                                                  appState.offerItem!.value!
                                                      .toDouble();
                                              appState.finalTotal = _amount -
                                                  appState.offerItem!.value!
                                                      .toDouble();
                                            } else if (appState
                                                    .offerItem?.type ==
                                                "Percent") {
                                              appState.offerItem!
                                                  .discountPrice = (_amount *
                                                      appState
                                                          .offerItem!.value!) /
                                                  100;
                                              appState.finalTotal = _amount -
                                                  appState.offerItem!
                                                      .discountPrice!;
                                            }
                                            setState(() {});
                                          } else {
                                            appState.offerItem = null;
                                            commonAlertNotification("Error",
                                                message: UtilsHelper.getString(
                                                    context,
                                                    "this_coupon_code_does_not_valid_now"));
                                          }
                                        }
                                        print(offerItem);
                                      }
                                    },
                                    child: Text(
                                      appState.offerItem != null &&
                                              (appState.offerItem!
                                                      .discountPrice!) >
                                                  0
                                          ? "- ${displayPriceDouble(appState
                                              .offerItem!.discountPrice!)}"
                                          : UtilsHelper.getString(
                                                  context, 'apply_coupon')
                                              .toUpperCase(),
                                      textDirection: TextDirection.ltr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontFamily: !UtilsHelper
                                                    .rightHandLang
                                                    .contains(lang)
                                                ? UtilsHelper
                                                    .wr_default_font_family
                                                : UtilsHelper
                                                    .the_sans_font_family,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color:  appState.offerItem != null &&
                                              (appState.offerItem!
                                                      .discountPrice!) >
                                                  0 ? Colors.green : MyColor.textPrimaryColor,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    height: 1,
                                    width: size.width,
                                    color: MyColor.textPrimaryColor
                                        ?.withOpacity(0.5)),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      UtilsHelper.getString(
                                          context, 'total_order'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontFamily: !UtilsHelper
                                                    .rightHandLang
                                                    .contains(lang)
                                                ? UtilsHelper
                                                    .wr_default_font_family
                                                : UtilsHelper
                                                    .the_sans_font_family,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: MyColor.textPrimaryColor,
                                          ),
                                    ),
                                    Text(
                                      UtilsHelper.getString(
                                          context,
                                          displayPriceDouble(
                                              decimalValueWithPlaces(
                                                  appState.finalTotal, 2))),
                                      textDirection: TextDirection.ltr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontFamily: !UtilsHelper
                                                    .rightHandLang
                                                    .contains(lang)
                                                ? UtilsHelper
                                                    .wr_default_font_family
                                                : UtilsHelper
                                                    .the_sans_font_family,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: MyColor.textPrimaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: commonButton(
                                    onPress: () {
                                      if (appState.apiToken.isNotEmpty) {
                                        if (appState.carts.value.isNotEmpty) {
                                          if (validateCartItems(
                                              context, cartsProducts)) {
                                            con.cartBulkAddApi(context);
                                          }
                                        } else {
                                          commonAlertNotification("Error",
                                              message: UtilsHelper.getString(
                                                  context,
                                                  "add_some_products"));
                                        }
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed(RoutePath.sign_in);
                                      }
                                    },
                                    prefixPath: 'assets/icon_arrow.svg',
                                    title: UtilsHelper.getString(
                                      context,
                                      UtilsHelper.getString(context, 'next'),
                                    ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontFamily: !UtilsHelper.rightHandLang
                                                  .contains(lang)
                                              ? UtilsHelper
                                                  .wr_default_font_family
                                              : UtilsHelper
                                                  .the_sans_font_family,
                                          color: MyColor.textPrimaryLightColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
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
                    ],
                  )
                : EmptyCartScreen(onTap: () {
                    Navigator.pop(context);
                  });
          }),
    );
  }

  Widget getRow(
      {String? key, String? value, Widget? suffixWidget, required lang}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key ?? '',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
              fontSize: 16,
              color: MyColor.textPrimaryDarkColor),
        ),
        suffixWidget != null
            ? suffixWidget
            : Text(
                value ?? '',
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                    fontSize: 16,
                    color: MyColor.textPrimaryDarkColor),
              ),
      ],
    );
  }

  bool validateCartItems(BuildContext context, List<Product> cartsProducts) {
    for (int i = 0; i < cartsProducts.length; i++) {
      Product _product = cartsProducts[i];
      if (_product.getSelectedDates().isEmpty) {
        selectedIndex = i;
        setState(() {});
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
        commonAlertNotification("Error",
            message: UtilsHelper.getString(context, "select_date_properly"));
        return false;
      }
      if (_product.startDate != null &&
          _pureDate(_product.startDate!)
                  .difference(_pureDate(DateTime.now()))
                  .inHours <
              0) {
        selectedIndex = i;
        setState(() {});
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
        commonAlertNotification("Error",
            message:
                UtilsHelper.getString(context, "you_can_not_select_past_date"));
        return false;
      }
    }
    return true;
  }

  DateTime _pureDate(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}
