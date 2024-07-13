import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/display_format.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/Utils/utils.dart';
import 'package:water/View/shimmers/address_list_shimmer.dart';
import 'package:water/Widgets/cache_network_image.dart';

import 'package:water/Widgets/header.dart';
import 'package:water/controllers/order_controller.dart';
import 'package:water/model/order/order.dart';
import 'package:water/model/order/product_order.dart';
import 'package:water/model/settings_model/time_slot.dart';
import 'package:water/repository/setting_repository.dart';

import '../../Utils/rgbo_to_hex.dart';

class TrackOrder extends StatefulWidget {
  final int orderId;
  const TrackOrder({Key? key, required this.orderId}) : super(key: key);

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends StateMVC<TrackOrder> {
  _TrackOrderState() : super(OrderController()) {
    con = controller as OrderController;
  }

  late OrderController con;
  int _orderStatus = 1;
  bool isAnyDeliveryRemaining = false;

  @override
  void initState() {
    con.getOrderDetailApi(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    List _bookedProduct = [
      //Todo: it should be delete
      {
        "title": UtilsHelper.getString(context, 'no_of_items'),
        "size": UtilsHelper.getString(context, 'static_size'),
        "qty": UtilsHelper.getString(context, 'quantity')
      },
      {
        "title": UtilsHelper.getString(context, 'no_of_items'),
        "size": UtilsHelper.getString(context, 'static_size'),
        "qty": UtilsHelper.getString(context, 'quantity')
      },
    ];

    List _orderDetails = [];
    Map<String, List<ProductOrder>> productDateMap =
        Map<String, List<ProductOrder>>();
    if (con.orderListItem != null) {
      _orderDetails = [
        {
          "title": UtilsHelper.getString(context, 'delivery_address'),
          "description":
              con.orderListItem?.deliveryAddress?.getFormattedAddress() ?? "-"
        },
        {
          "title": UtilsHelper.getString(context, 'phone_number'),
          "description": appState.userModel.phone ?? "-"
        },
        {
          "title": UtilsHelper.getString(context, 'delivery_time'),
          "description": setting.value.timeslots!
              .firstWhere(
                  (element) => element.id == con.orderListItem!.timeslotId,
                  orElse: () => Timeslot())
              .getDisplayStr(context)
        },
        {
          "title": UtilsHelper.getString(context, 'payment_method'),
          "description":
              UtilsHelper.getString(context, con.orderListItem!.paymentMethod!)
        },
        {
          "title": UtilsHelper.getString(context, 'order_time'),
          "description": con.orderListItem!.getOrderTime()
        },
      ];
      isAnyDeliveryRemaining = false;
      List<ProductOrder> productOrders = con.orderListItem!.productOrders!;
      productDateMap = Map<String, List<ProductOrder>>();

      ///initialize

      for (int i = 0; i < productOrders.length; i++) {
        for (int j = 0; j < productOrders[i].productDeliverys!.length; j++) {
          ProductDelivery pd = productOrders[i].productDeliverys![j];
          if (productDateMap.containsKey(pd.getDeliveryDateString())) {
            productDateMap[pd.getDeliveryDateString()]!.add(productOrders[i]);
          } else {
            productDateMap[pd.getDeliveryDateString()] = [productOrders[i]];
          }
          if (pd.deliveryDate != null &&
              calculateDifference(pd.deliveryDate!) > 0) {
            isAnyDeliveryRemaining = true;
          }
        }
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: headerWidget(
              title: UtilsHelper.getString(context, 'your_orders'),
              onPress: () {
                Navigator.of(context).pop();
              },
              context: context,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 31,
                          decoration: BoxDecoration(
                            color: MyColor.commonColorSet2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  UtilsHelper.getString(context, 'item'),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontFamily: !UtilsHelper.rightHandLang
                                                  .contains(lang)
                                              ? UtilsHelper
                                                  .wr_default_font_family
                                              : UtilsHelper
                                                  .the_sans_font_family,
                                          fontSize: 12,
                                          color: MyColor.white),
                                ),
                              ),
                              Container(),
                              Container(
                                child: Text(
                                  UtilsHelper.getString(
                                      context, 'types_of_order'),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontFamily: !UtilsHelper.rightHandLang
                                                  .contains(lang)
                                              ? UtilsHelper
                                                  .wr_default_font_family
                                              : UtilsHelper
                                                  .the_sans_font_family,
                                          fontSize: 12,
                                          color: MyColor.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 3),
                                child: Text(
                                  UtilsHelper.getString(context, 'from_to'),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontFamily: !UtilsHelper.rightHandLang
                                                  .contains(lang)
                                              ? UtilsHelper
                                                  .wr_default_font_family
                                              : UtilsHelper
                                                  .the_sans_font_family,
                                          fontSize: 12,
                                          color: MyColor.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        con.orderListItem == null
                            ? AddressListShimmer(separatorHeight: 0)
                            : ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.zero,
                                itemCount:
                                    con.orderListItem?.productOrders?.length ??
                                        0,
                                separatorBuilder: (context, _index) {
                                  return SizedBox(height: 4);
                                },
                                itemBuilder: (context, index) {
                                  ProductOrder productOrder =
                                      con.orderListItem!.productOrders![index];
                                  return Container(
                                    height: 60,
                                    width: size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      textDirection: TextDirection.ltr,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 0,
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    color: MyColor
                                                        .coreBackgroundColor,
                                                    child:
                                                        CacheNetworkImageWidget(
                                                      Urls.getImageUrlFromName(
                                                          productOrder.product
                                                                  ?.image ??
                                                              ""),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  productOrder
                                                                          .product
                                                                          ?.name ??
                                                                      "",
                                                                  maxLines: 3,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                                      fontFamily: !UtilsHelper.rightHandLang.contains(
                                                                              lang)
                                                                          ? UtilsHelper
                                                                              .wr_default_font_family
                                                                          : UtilsHelper
                                                                              .the_sans_font_family,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: MyColor
                                                                          .subTitle),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          UtilsHelper.getString(
                                                                  context,
                                                                  'qty') +
                                                              ": " +
                                                              productOrder
                                                                  .quantity
                                                                  .toString(),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium
                                                              ?.copyWith(
                                                                  fontFamily: !UtilsHelper
                                                                          .rightHandLang
                                                                          .contains(
                                                                              lang)
                                                                      ? UtilsHelper
                                                                          .wr_default_font_family
                                                                      : UtilsHelper
                                                                          .the_sans_font_family,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: MyColor
                                                                      .subTitle),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        Expanded(
                                          child: Text(
                                            productOrder.orderFrequency ==
                                                    "once"
                                                ? UtilsHelper.getString(
                                                    context,
                                                    productOrder
                                                        .orderFrequency!)
                                                : UtilsHelper.getString(
                                                        context,
                                                        productOrder
                                                            .orderFrequency!) +
                                                    getDelivery(productOrder
                                                        .noOfDelivery!
                                                        .toString()),
                                            // maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: MyColor.subTitle),
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Expanded(
                                          // flex: 2,
                                          child: Container(
//                                margin: lang != 'en'
//                                    ? EdgeInsets.only(left: 20)
//                                    : EdgeInsets.zero,
                                            child: Text(
                                              productOrder.orderFrequency ==
                                                      "once"
                                                  ? getDayFormat(
                                                      productOrder.startDate,
                                                      ddMMYYYYFormat)
                                                  : getDayFormat(
                                                          productOrder
                                                              .startDate,
                                                          ddMMYYYYFormat) +
                                                      " - \n" +
                                                      getDayFormat(
                                                          productOrder.endDate,
                                                          ddMMYYYYFormat),
                                              // maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                    fontFamily: !UtilsHelper
                                                            .rightHandLang
                                                            .contains(lang)
                                                        ? UtilsHelper
                                                            .wr_default_font_family
                                                        : UtilsHelper
                                                            .the_sans_font_family,
                                                    fontSize: 12,
                                                    height: 1.6,
                                                    color: MyColor.subTitle,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        SizedBox(
                          height: 8,
                        ),
                        MySeparator(color: Colors.grey),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          UtilsHelper.getString(context, 'delivery_schedule'),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontFamily:
                                      !UtilsHelper.rightHandLang.contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                  fontSize: 17,
                                  color: dark(context)
                                      ? Colors.white
                                      : MyColor.commonColorSet1),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: productDateMap.keys.length,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (c, i) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            List<String> keysList =
                                productDateMap.keys.toList();
                            keysList.sort((a, b) => a.compareTo(b));
                            List<ProductOrder> _productOrderList =
                                productDateMap[keysList[index]]!;
                            String _status = "";
                            return SizedBox.fromSize(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: MyColor.coreBackgroundColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          UtilsHelper.getString(
                                              context, "items"),
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                  fontFamily: !UtilsHelper
                                                          .rightHandLang
                                                          .contains(lang)
                                                      ? UtilsHelper
                                                          .wr_default_font_family
                                                      : UtilsHelper
                                                          .the_sans_font_family,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: MyColor.yourOrder),
                                        ),
                                        Text(
                                          UtilsHelper.getString(
                                              context, "status"),
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                  fontFamily: !UtilsHelper
                                                          .rightHandLang
                                                          .contains(lang)
                                                      ? UtilsHelper
                                                          .wr_default_font_family
                                                      : UtilsHelper
                                                          .the_sans_font_family,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: MyColor.yourOrder),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
//                                        height: 30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: ListView.separated(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    padding: EdgeInsets.zero,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: _productOrderList
                                                        .length,
                                                    separatorBuilder: (c, i) {
                                                      return SizedBox(
                                                          height: 6);
                                                    },
                                                    itemBuilder: (context, _i) {
                                                      ProductOrder
                                                          productOrder =
                                                          _productOrderList[_i];
                                                      if (productOrder
                                                              .productDeliverys!
                                                              .length >
                                                          0) {
                                                        _status = productOrder
                                                            .productDeliverys!
                                                            .first
                                                            .deliveryStatus!
                                                            .status!;
                                                      }
                                                      return productOrder
                                                                  .product !=
                                                              null
                                                          ? Text(
                                                              productOrder
                                                                      .product!
                                                                      .name! +
                                                                  " x " +
                                                                  productOrder
                                                                      .quantity
                                                                      .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineMedium
                                                                  ?.copyWith(
                                                                      fontFamily: !UtilsHelper.rightHandLang.contains(
                                                                              lang)
                                                                          ? UtilsHelper
                                                                              .wr_default_font_family
                                                                          : UtilsHelper
                                                                              .the_sans_font_family,
                                                                      fontSize:
                                                                          13,
                                                                      color: MyColor
                                                                          .yourOrder),
                                                            )
                                                          : SizedBox();
                                                    }),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                UtilsHelper.getString(context,
                                                        'delivery_date') +
                                                    ": " +
                                                    keysList[index],
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                        fontFamily: !UtilsHelper
                                                                .rightHandLang
                                                                .contains(lang)
                                                            ? UtilsHelper
                                                                .wr_default_font_family
                                                            : UtilsHelper
                                                                .the_sans_font_family,
                                                        fontSize: 12,
                                                        color:
                                                            MyColor.yourOrder),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
//                                            _status,
                                                _productOrderList
                                                    .first
                                                    .productDeliverys!
                                                    .first
                                                    .deliveryStatus!
                                                    .status!,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                        fontFamily: !UtilsHelper
                                                                .rightHandLang
                                                                .contains(lang)
                                                            ? UtilsHelper
                                                                .wr_default_font_family
                                                            : UtilsHelper
                                                                .the_sans_font_family,
                                                        fontSize: 12,
                                                        color:
                                                            MyColor.yourOrder),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        orderDetails(orderDetails: _orderDetails, lang: lang),
                        SizedBox(
                          height: 20,
                        ),
                        if (con.orderListItem != null)
                          getRow(
                            key: UtilsHelper.getString(context, 'sub_total'),
                            lang: lang,
                            value: UtilsHelper.getString(
                                context,
                                displayPriceDouble(
                                    con.orderListItem!.subtotal!)),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (con.orderListItem != null)
                          getRow(
                            key: UtilsHelper.getString(context, 'vat'),
                            lang: lang,
                            value: UtilsHelper.getString(context,
                                displayPriceDouble(con.orderListItem!.tax!)),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (con.orderListItem != null)
                          getRow(
                            key: UtilsHelper.getString(context, 'delivery'),
                            lang: lang,
                            value: UtilsHelper.getString(
                                context,
                                displayPriceDouble(
                                    con.orderListItem!.deliveryFee!)),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (con.orderListItem != null)
                          getRow(
                            key: UtilsHelper.getString(
                                context, 'coupon_discount'),
                            lang: lang,
                            suffixWidget: GestureDetector(
                              onTap: () async {},
                              child: Text(
                                displayPriceDouble(
                                    con.orderListItem?.promotionalDisount ??
                                        0.0),
//                          UtilsHelper.getString(context, 'apply_coupon')
//                              .toUpperCase(),
                                textDirection: TextDirection.ltr,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.textPrimaryColor,
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
                            color: MyColor.textPrimaryColor?.withOpacity(0.5)),
                        SizedBox(
                          height: 30,
                        ),
                        if (con.orderListItem != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                UtilsHelper.getString(context, 'total_order'),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.textPrimaryColor,
                                    ),
                              ),
                              Text(
                                UtilsHelper.getString(
                                    context,
                                    displayPriceDouble(
                                        con.orderListItem!.finalAmount!)),
                                textDirection: TextDirection.ltr,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
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
                      ],
                    ),
                  ),
                  if (isAnyDeliveryRemaining)
                    Container(
                      height: 56,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if ((con.orderListItem?.cancelRequest ?? null) ==
                              null) {
                            selectCancelButton(context, onPress: () {
                              if ((con.orderListItem?.cancelRequest ?? null) ==
                                  null) {
                                con.orderCancelRequestApi(
                                    con.orderListItem!.id!);
                              }
                            },
                                title: getStatusTitle(con.orderListItem),
                                // subtitle: UtilsHelper.getString(context,'are_you_sure'),
                                textStyle:
                                    Theme.of(context).textTheme.labelSmall,
                                color: Colors.black);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: TextDirection.ltr,
                          children: [
                            Text(
                              getStatusTitle(con.orderListItem),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        UtilsHelper.the_sans_font_family,
                                    color: MyColor.textPrimaryLightColor,
                                  ),
                            )
                          ],
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => getButtonColor(con.orderListItem)),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget orderDetails({required List orderDetails, required lang}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: MyColor.coreBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            itemCount: orderDetails.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    orderDetails[index]['title'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                              ? UtilsHelper.wr_default_font_family
                              : UtilsHelper.the_sans_font_family,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MyColor.textPrimaryDarkColor,
                        ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    orderDetails[index]['description'],
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                            ? UtilsHelper.wr_default_font_family
                            : UtilsHelper.the_sans_font_family,
                        fontSize: 12,
                        color: MyColor.yourOrder,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  if (index != orderDetails.length - 1)
                    MySeparator(color: Colors.grey),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

//  Widget stepProgressWidget(
//      {required Size size, required BuildContext context, required lang}) {
//    return Row(
//      children: [
//        Stack(
//          alignment: Alignment.center,
//          children: [
//            Container(
//              width: size.width - 100,
//              child: SvgPicture.asset(
//                "assets/dotted_line.svg",
//                fit: BoxFit.fitWidth,
//              ),
//            ),
//            Container(
//              width: size.width - 35,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: [
//                  Column(
//                    children: [
//                      SizedBox(
//                        height: 22,
//                      ),
//                      Container(
//                        height: 47,
//                        width: 47,
//                        padding: EdgeInsets.all(13),
//                        decoration: BoxDecoration(
//                          color: MyColor.commonColorSet1,
//                          borderRadius: BorderRadius.all(
//                            Radius.circular(28),
//                          ),
//                        ),
//                        child: SvgPicture.asset(
//                          "assets/store.svg",
//                          color: MyColor.white,
//                        ),
//                      ),
//                      SizedBox(
//                        height: 13,
//                      ),
//                      Text(
//                        UtilsHelper.getString(context, 'received'),
//                        style: TextStyle(
//                          fontSize: 12,
//                          fontWeight: FontWeight.normal,
//                          color: MyColor.textSecondarySecondLightColor,
//                        ),
//                      ),
//                    ],
//                  ),
//                  Container(),
//                  Column(
//                    children: [
//                      SizedBox(
//                        height: 22,
//                      ),
//                      Container(
//                        height: 47,
//                        width: 47,
//                        padding: EdgeInsets.all(12),
//                        decoration: BoxDecoration(
//                          color: _orderStatus >= 2
//                              ? MyColor.darkBlue
//                              : MyColor.mainColor,
//                          borderRadius: BorderRadius.all(
//                            Radius.circular(28),
//                          ),
//                        ),
//                        child: SvgPicture.asset(
//                          "assets/icon_delivery.svg",
//                          color: _orderStatus >= 2
//                              ? MyColor.white
//                              : MyColor.commonColorSet1,
//                        ),
//                      ),
//                      SizedBox(
//                        height: 13,
//                      ),
//                      Text(
//                        UtilsHelper.getString(context, 'on_the_way'),
//                        style: TextStyle(
//                          fontWeight: FontWeight.normal,
//                          fontSize: 12,
//                          color: MyColor.textSecondarySecondLightColor,
//                        ),
//                      ),
//                    ],
//                  ),
//                  Container(),
//                  Column(
//                    children: [
//                      SizedBox(
//                        height: 22,
//                      ),
//                      Container(
//                        height: 47,
//                        width: 47,
//                        padding: EdgeInsets.all(15),
//                        decoration: BoxDecoration(
//                          color: _orderStatus >= 3
//                              ? MyColor.darkBlue
//                              : MyColor.mainColor,
//                          borderRadius: BorderRadius.all(
//                            Radius.circular(28),
//                          ),
//                        ),
//                        child: SvgPicture.asset(
//                          "assets/done.svg",
//                          color: _orderStatus >= 3
//                              ? MyColor.white
//                              : MyColor.commonColorSet1,
//                        ),
//                      ),
//                      SizedBox(
//                        height: 13,
//                      ),
//                      Text(
//                        UtilsHelper.getString(context, 'delivered'),
//                        style: TextStyle(
//                          fontSize: 12,
//                          fontWeight: FontWeight.normal,
//                          color: MyColor.textSecondarySecondLightColor,
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ],
//    );
//  }

  Widget getRow(
      {String? key, String? value, Widget? suffixWidget, required lang}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key ?? '',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family,
              fontSize: 16,
              color: MyColor.textPrimaryDarkColor),
        ),
        suffixWidget != null
            ? suffixWidget
            : Text(
                value ?? '',
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                        ? UtilsHelper.wr_default_font_family
                        : UtilsHelper.the_sans_font_family,
                    fontSize: 16,
                    color: MyColor.textPrimaryDarkColor),
              ),
      ],
    );
  }

  String getDelivery(String string) {
    return " (" + string + ")";
  }
}

getButtonColor(OrderListItem? orderListItem) {
  if ((orderListItem?.cancelRequest ?? null) == null) {
    return MyColor.commonColorSet2;
  }
  if (orderListItem!.cancelRequest!.status == 0) {
    return Colors.grey;
  } else if (orderListItem.cancelRequest!.status == 2) {
    return Colors.red;
  } else if (orderListItem.cancelRequest!.status == 1 &&
      orderListItem.cancelRequest!.refundStatus == 1) {
    if (orderListItem.paymentMethod == "cash") {
      return Colors.green;
    } else {
      return Colors.green;
    }
  } else if (orderListItem.cancelRequest!.status == 1 &&
      orderListItem.cancelRequest!.refundStatus == 0) {
    if (orderListItem.paymentMethod == "cash") {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  } else {
    return Colors.grey;
  }
}

String getStatusTitle(OrderListItem? orderListItem) {
  if ((orderListItem?.cancelRequest ?? null) == null) {
    return UtilsHelper.getString(null, "cancel_request");
  }
  if (orderListItem!.cancelRequest!.status == 0) {
    return UtilsHelper.getString(null, "cancel_request_already_submitted");
  } else if (orderListItem.cancelRequest!.status == 2) {
    return UtilsHelper.getString(null, "cancel_request_declined_by_admin");
  } else if (orderListItem.cancelRequest!.status == 1 &&
      orderListItem.cancelRequest!.refundStatus == 1) {
    if (orderListItem.paymentMethod == "cash") {
      return UtilsHelper.getString(
          null, "cancel_request_approved_and_refunded");
    } else {
      return UtilsHelper.getString(null, "cancel_request_approved");
    }
  } else if (orderListItem.cancelRequest!.status == 1 &&
      orderListItem.cancelRequest!.refundStatus == 0) {
    if (orderListItem.paymentMethod == "cash") {
      return UtilsHelper.getString(null, "cancel_request_approved");
    } else {
      return UtilsHelper.getString(null, "cancel_request_approved");
    }
  } else {
    return UtilsHelper.getString(null, "cancel_request_approved");
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

Future<dynamic> selectCancelButton(context,
    {String? prefixPath,
    required VoidCallback onPress,
    required String? title,
    String? subtitle,
    Color? borderColor,
    required TextStyle? textStyle,
    required Color? color}) {
  return showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          padding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : MyColor.mainColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // style: textStyle,
                ),
                SizedBox(height: 12),
                Text(
                  subtitle ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 14)),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => MyColor.commonColorSet1 as Color),
                            ),
                            child: Text(UtilsHelper.getString(context, 'no'),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white)))),
                    SizedBox(width: 12),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              onPress.call();
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 14)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => MyColor.commonColorSet2 as Color),
                            ),
                            child: Text(UtilsHelper.getString(context, 'yes'),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white)))),
                  ],
                )
              ],
            ),
          ),
        ));
      });
}
