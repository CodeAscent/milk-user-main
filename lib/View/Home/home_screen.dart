import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/View/search.dart';
import 'package:water/View/shimmers/banner_shimmer.dart';
import 'package:water/View/shimmers/product_grid_shimmer.dart';
import 'package:water/Widgets/bottom_nav_bar.dart';
import 'package:water/controllers/home_controller.dart';
import 'package:water/model/banner/banner.dart';
import 'package:water/model/product/product.dart';
import 'package:water/repository/notification_repository.dart';
import 'package:water/repository/setting_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends StateMVC<HomeScreen> {
  int load = 0;

  _HomeScreenState() : super(HomeController()) {
    con = controller as HomeController;
  }

  late HomeController con;
  CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  TextEditingController scontroller = TextEditingController();

//  List _productList = [
//    {
//      "id": "1",
//      "size": "600ml x24",
//      "image": "assets/image.png",
//      "sar": "19.5 SAR",
//      "qty": 0
//    },
//    {
//      "id": "2",
//      "size": "600ml x25",
//      "image": "assets/image.png",
//      "sar": "19.6 SAR",
//      "qty": 0
//    },
//    {
//      "id": "3",
//      "size": "600ml x26",
//      "image": "assets/image.png",
//      "sar": "19.7 SAR",
//      "qty": 0
//    },
//    {
//      "id": "4",
//      "size": "600ml x24",
//      "image": "assets/image.png",
//      "sar": "19.5 SAR",
//      "qty": 0
//    },
//    {
//      "id": "5",
//      "size": "600ml x25",
//      "image": "assets/image.png",
//      "sar": "19.6 SAR",
//      "qty": 0
//    },
//    {
//      "id": "6",
//      "size": "600ml x26",
//      "image": "assets/image.png",
//      "sar": "19.7 SAR",
//      "qty": 0
//    }
//  ];

  @override
  void initState() {
    UtilsHelper.loadLocalization(appState.currentLanguageCode.value);
    con.getHomeBannersApi();
    getNotificationCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;
    //  print(con.products!.data);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            left: false,
            right: false,
            child: Column(
              children: [
                Container(
                  // height: 147,
                  width: size.width,
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColor.coreBackgroundColor, //mainColor
                        borderRadius: BorderRadius.circular(50)),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('notification clicked');
                            if (appState.apiToken.isNotEmpty) {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.notification);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.sign_in);
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/notification.svg",
                                  colorFilter: ColorFilter.mode(
                                      MyColor.bottomNavBar as Color,
                                      BlendMode.srcATop), //commonColorSet1
                                ),
                                Positioned(
                                  top: 2,
                                  right: 3,
                                  child: ValueListenableBuilder<int>(
                                      valueListenable: notificationCount,
                                      builder:
                                          (context, _notificationCount, child) {
                                        return _notificationCount > 0
                                            ? Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  color:
                                                      MyColor.commonColorSet2,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _notificationCount
                                                        .toString(),
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: MyColor.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox();
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/search_page');
                            },
                            child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: dark(context)
                                        ? MyColor.coreBackgroundColor
                                        : MyColor.white,
                                    border: Border.all(
                                        width: 1,
                                        color: dark(context)
                                            ? Colors.white30
                                            : Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(100)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('assets/search.png',
                                          color: dark(context)
                                              ? Colors.grey.shade300
                                              : Colors.grey.shade400),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                        UtilsHelper.getString(
                                            context, 'search'),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w400))
                                  ],
                                )),
                          ),
                        ),
                        SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            if (appState.apiToken.isNotEmpty) {
                              Navigator.of(context).pushNamed(
                                RoutePath.setting,
                              );
                            } else {
                              Navigator.of(context)
                                  .pushNamed(RoutePath.sign_in);
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/settings.svg",
                            colorFilter: ColorFilter.mode(
                                MyColor.bottomNavBar as Color,
                                BlendMode.srcIn), //commonColorSet1
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      con.getHomeBannersApi();
                      getNotificationCount();
                      load = 0;
                      await getKeysLists(appState.currentLanguageCode.value)
                          .then((value) {
                        appState.languageKeys = value;
                      });
                      initSettings();
                      setState(() {
                        Future.delayed(Duration(milliseconds: 3000));
                      });
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (load == 0 &&
                            scrollInfo.metrics.pixels >=
                                (scrollInfo.metrics.maxScrollExtent * 0.5) &&
                            products!.nextPageUrl != null) {
                          load++;
                          setState(() {});
                        }
                        if (load == 1 &&
                            scrollInfo.metrics.pixels >=
                                (scrollInfo.metrics.maxScrollExtent * 0.5) &&
                            products!.nextPageUrl != null) {
                          // Future.delayed(Duration(seconds: 2),() {
                          load++;
                          setState(() {});

                          con
                              .getPaginatedProducts(products!.nextPageUrl ?? "")
                              .whenComplete(() {
                            //  products!.nextPageUrl = null;
                            load = 2;
                            if (products!.nextPageUrl != null) {
                              load = 0;
                            }
                            print('object');
                            setState(() {});
                          });
                          // });
                        }
                        return false;
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          banners == null
                              ? BannerShimmer()
                              : banners != null && banners!.length > 0
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 200,
                                      child: CarouselSlider(
                                        carouselController: _carouselController,
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          viewportFraction: 1,
                                          enlargeCenterPage: false,
                                          // height: 179.0,
                                          aspectRatio: 15 / 9,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentIndex = index;
                                            });
                                          },
                                        ),
                                        items: banners!.map((i) {
                                          BannerItem bannerItem = i;
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                child: Container(
                                                  height: 230,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    // color: Colors.red,
                                                  ),
                                                  child: Image(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      Urls.getImageUrlFromName(
                                                          bannerItem.image!,
                                                          isBanner: true),
                                                    ),
                                                    fit: BoxFit.contain,
                                                    height: 230,
                                                    width: size.width * 0.89,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                          if (banners != null && banners!.length > 0)
                            Container(
                              height: 10,
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListView.builder(
                                      itemCount: banners!.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _currentIndex = index;
                                            });
                                            _carouselController.animateToPage(
                                                index,
                                                duration: Duration(
                                                    microseconds: 1000),
                                                curve: Curves.easeInBack);
                                          },
                                          child: Container(
                                            height: 6,
                                            width: 6,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                                color: index == _currentIndex
                                                    ? MyColor.commonColorSet2
                                                    : dark(context)
                                                        ? Colors.white60
                                                        : MyColor
                                                            .commonColorSet1, //commonColorSet1
                                                shape: BoxShape.circle),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          SizedBox(height: 17),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  UtilsHelper.getString(context, 'product'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontFamily: lang == 'en'
                                            ? 'Helvetica'
                                            : 'TheSans',
                                        fontSize: 18,
                                        color: dark(context)
                                            ? Colors.white
                                            : MyColor
                                                .commonColorSet1, //commonColorSet1
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 17),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26),
                            child: Column(
                              children: [
                                products == null
                                    ? ProductGridShimmer()
                                    : ValueListenableBuilder<List<Product>>(
                                        valueListenable: appState.carts,
                                        builder:
                                            (context, cartsProducts, child) {
                                          return GridView.custom(
                                            padding: EdgeInsets.all(0),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 16,
                                              mainAxisExtent: 200,
                                              childAspectRatio: 0.7,
                                            ),
                                            shrinkWrap: true,
                                            primary: false,
                                            scrollDirection: Axis.vertical,
                                            childrenDelegate:
                                                SliverChildListDelegate(
                                              products!.data!.map(
                                                (data) {
                                                  Product product = data;
                                                  int productQuantity = 0;
                                                  Product cartProduct;
                                                  cartProduct =
                                                      cartsProducts.firstWhere(
                                                          (element) =>
                                                              element.id ==
                                                              product.id,
                                                          orElse: () => Product(
                                                              quantity: 0));
                                                  productQuantity =
                                                      cartProduct.quantity;
                                                  // print(appState.carts.value[0].id);
                                                  // print(product.id);
                                                  return ProductGridWidget(
                                                      key: ValueKey(product.id),
                                                      product: product,
                                                      productQuantity:
                                                          productQuantity);
                                                },
                                              ).toList(),
                                            ),
                                          );
                                        }),
                                if (load == 1)
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                              ],
                            ),
                          ),
                          SizedBox(height: 100)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: bottomNavBar(context: context),
          )
        ],
      ),
    );
  }
}
