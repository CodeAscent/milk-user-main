import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/View/shimmers/offer_list_shimmer.dart';
import 'package:water/Widgets/cache_network_image.dart';
import 'package:water/Widgets/empty_offer_screen.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/controllers/offer_controller.dart';
import 'package:water/model/offer_item.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends StateMVC<Offers> {
  _OffersState() : super(OfferController()) {
    con = controller as OfferController;
  }

  late OfferController con;

//  List _availableOffers = [
//    {"path": "assets/water_banner.png"},
//    {"path": "assets/water_banner.png"},
//    {"path": "assets/water_banner.png"},
//    {"path": "assets/water_banner.png"},
//  ];

  @override
  void initState() {
    con.getOffersCouponListsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: con.offerList != null && (con.offerList?.length ?? 0) == 0
          ? EmptyOfferScreen(onTap: () {
              Navigator.of(context).pushReplacementNamed(RoutePath.home_screen);
            })
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: headerWidget(
                    title: UtilsHelper.getString(context, 'offers'),
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
                            height: 20,
                          ),
                          con.offerList == null
                              ? OfferListShimmer()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: EdgeInsets.zero,
                                  itemCount: con.offerList!.length,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 15);
                                  },
                                  itemBuilder: (context, index) {
                                    OfferItem offerItem = con.offerList![index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: CacheNetworkImageWidget(
                                        Urls.getOfferUrlFromName(
                                            offerItem.image ?? ""),
                                      ),
                                    );
                                  },
                                ),
                          SizedBox(
                            height: 31,
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
