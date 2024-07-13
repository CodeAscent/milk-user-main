import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/utils.dart';
import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/Widgets/wallet_history_tile.dart';
import 'package:water/controllers/wallet_controller.dart';
import 'package:water/model/wallet_history_item.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends StateMVC<WalletScreen> {
  _WalletScreenState() : super(WalletController()) {
    con = controller as WalletController;
  }

  late WalletController con;

  @override
  void initState() {
    con.getMyWalletAmountApi(context);
    con.getWalletHistoryApi();
    super.initState();
  }

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
              title: UtilsHelper.getString(context, 'balance'),
              onPress: () {
                Navigator.of(context).pop();
              },
              context: context,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      UtilsHelper.getString(context, 'available_balance'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                            fontSize: 18,
                            color: MyColor.aboutUsDescription,
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: MyColor.coreBackgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: ValueListenableBuilder<double>(
                            valueListenable: appState.myWalletBalance,
                            builder: (context, _myWalletBalance, child) {
                              return Text(
                                displayPriceDouble(_myWalletBalance),
                                textDirection: TextDirection.ltr,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontFamily:
                                          lang == 'en' ? 'Helvetica' : 'TheSans',
                                      fontSize: 28,
                                      color: MyColor.textPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            UtilsHelper.getString(
                                context, 'wallet_usage_instruction'),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontFamily:
                                      lang == 'en' ? 'Helvetica' : 'TheSans',
                                  fontSize: 14,
                                  color: MyColor.aboutUsDescription,
                                ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: commonButton(
                        onPress: () async {
                          await Navigator.of(context)
                              .pushNamed(RoutePath.add_wallet_amount);
                          con.getMyWalletAmountApi(context);
                          con.getWalletHistoryApi();
                        },
                        prefixPath: 'assets/icon_arrow.svg',
                        title: UtilsHelper.getString(context, 'add_amount'),
                        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                              color: MyColor.textPrimaryLightColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                        color: MyColor.commonColorSet2,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            UtilsHelper.getString(context, 'history'),
                            style:
                                Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontFamily:
                                          lang == 'en' ? 'Helvetica' : 'TheSans',
                                      fontSize: 18,
                                      color: MyColor.textPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    
                    Container(
                        width: size.width,
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                        child: ValueListenableBuilder<List<WalletHistoryItem>>(
                            valueListenable: appState.walletHistoryItemList,
                            builder: (context, _walletHistoryItemList, child) {
                              return _walletHistoryItemList.length>0 ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: _walletHistoryItemList.length,
                                  separatorBuilder: (c, i) {
                                    return Container(
                                      //color: Theme.of(context).disabledColor,
                                      height: 12,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    WalletHistoryItem _walletHistoryItem =
                                        _walletHistoryItemList[index];
                                    return WalletHistoryTile(
                                        _walletHistoryItem.description,
                                        _walletHistoryItem.getAmount(),
                                        _walletHistoryItem.isCredit());
                                  }) : Container(
                                    height: 220,
                                    margin: EdgeInsets.only(top: 24),
                                    decoration: BoxDecoration(
                                      color: MyColor.coreBackgroundColor,
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SvgPicture.asset(
                                                 "assets/wallet_icon.svg",
                                                color: Theme.of(context).brightness == Brightness.light
                                                    ? MyColor.commonColorSet1
                                                    : MyColor.white,
                                                ),
                                              ),
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              child: Container(
                                               decoration: BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 color:MyColor.coreBackgroundColor,
                                                 border: Border.all(width: 1,
                                                 color: Theme.of(context).brightness == Brightness.light
                                                    ? MyColor.commonColorSet1 as Color
                                                    : MyColor.white as Color,)
                                               ),
                                                width: 16,
                                                height: 16,
                                                child: Icon(Icons.close,
                                                size: 12,
                                                color: Theme.of(context).brightness == Brightness.light
                                                    ? MyColor.commonColorSet1 as Color
                                                    : MyColor.white as Color,
                                                ),
                                              ))
                                          ]),
                                          SizedBox(height:16),
                                          Text(
                                          UtilsHelper.getString(context, 'data_not_available'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                                                                              //                  color: MyColor.textPrimaryLightColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                            })),
                    SizedBox(
                      height: 30,
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
}
