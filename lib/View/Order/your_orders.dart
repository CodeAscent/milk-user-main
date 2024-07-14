import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/View/shimmers/address_list_shimmer.dart';
import 'package:water/Widgets/empty_order_screen.dart';

import 'package:water/Widgets/header.dart';
import 'package:water/controllers/order_controller.dart';
import 'package:water/model/order/order.dart';

class YourOrders extends StatefulWidget {
  const YourOrders({Key? key}) : super(key: key);

  @override
  _YourOrdersState createState() => _YourOrdersState();
}

class _YourOrdersState extends StateMVC<YourOrders> {
  _YourOrdersState() : super(OrderController()) {
    con = controller as OrderController;
  }

  late OrderController con;

  @override
  void initState() {
    con.getOrderListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = appState.currentLanguageCode.value;
//    List _orders = [
//      {"title": UtilsHelper.getString(context, "order_text") + "#5678"},
//      {"title": UtilsHelper.getString(context, "order_text") + "#5679"},
//      {"title": UtilsHelper.getString(context, "order_text") + "#5680"},
//    ];
    return con.orderListItems != null &&
            ((con.orderListItems?.length ?? 0) == 0)
        ? EmptyOrderScreen(onTap: () {
            Navigator.of(context).pushReplacementNamed(RoutePath.home_screen);
          })
        : Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 27,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          con.orderListItems == null
                              ? AddressListShimmer()
                              : (con.orderListItems!.length == 0
                                  ? Center(
                                      child: Text(
                                        UtilsHelper.getString(
                                            context, 'data_not_available'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontFamily: lang == 'en'
                                                  ? 'Helvetica'
                                                  : 'TheSans',
                                            ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      padding: EdgeInsets.zero,
                                      itemCount: con.orderListItems!.length,
                                      itemBuilder: (context, index) {
                                        OrderListItem orderListItem =
                                            con.orderListItems![index];

                                        return Column(
                                          children: [
                                            orderRow(
                                              orderImage:
                                                  Urls.getImageUrlFromName(
                                                      orderListItem
                                                              .productOrders!
                                                              .first
                                                              .product!
                                                              .image ??
                                                          ""),
                                              orderTitle: "OrderId: " +
                                                  orderListItem.id.toString(),
                                              orderListItem: orderListItem,
                                              orderTotal: orderListItem
                                                  .finalAmount
                                                  .toString(),
                                              orderDate: orderListItem.createdAt
                                                  .toString(),
                                              orderNumber:
                                                  UtilsHelper.getString(context,
                                                          "order_text") +
                                                      " " +
                                                      orderListItem.id
                                                          .toString(),
                                              suffixWidget: Icon(
                                                !UtilsHelper.rightHandLang
                                                        .contains(lang)
                                                    ? Icons.keyboard_arrow_right
                                                    : Icons.keyboard_arrow_left,
                                                color: MyColor.yourOrder,
                                              ),
                                              onPress: () {
                                                print('clicked on order');
                                                Navigator.of(context).pushNamed(
                                                    RoutePath.track_order,
                                                    arguments:
                                                        orderListItem.id);
                                              },
                                              lang: lang,
                                            ),
                                            SizedBox(
                                              height: 17,
                                            )
                                          ],
                                        );
                                      },
                                    )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget orderRow(
      {String? orderTitle,
      String? orderNumber,
      String? orderTotal,
      String? orderDate,
      String? orderImage,
      Widget? suffixWidget,
      onPress,
      required lang,
      required OrderListItem orderListItem}) {
    return GestureDetector(
      onTap: onPress,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          //   height: 60,
          color: MyColor.coreBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.network(orderImage!),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              orderTitle ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    fontFamily:
                                        lang == 'en' ? 'Helvetica' : 'TheSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: MyColor.textPrimaryDarkColor,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Amount: " + orderTotal.toString(),
                              style: TextStyle(
                                color: MyColor.textPrimaryDarkColor,
                              ),
                            ),
                            Text(
                              orderDate == null
                                  ? ''
                                  : DateFormat.yMMMd()
                                      .format(DateTime.parse(orderDate)),
                              style: TextStyle(
                                color: MyColor.textPrimaryDarkColor,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),

                      // Icon(Icons.keyboard_arrow_down),
                      if (suffixWidget != null) suffixWidget,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
