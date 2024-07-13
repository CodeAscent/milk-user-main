import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Widgets/shimmer.dart';
import 'package:water/controllers/setting_controller.dart';

import '../Utils/ThemeData/themeColors.dart';
import '../Utils/UtilHelper.dart';
import '../Utils/local_data/app_state.dart';
import '../Utils/urls.dart';
import '../Utils/utils.dart';
import '../model/product/product_item.dart';
class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends StateMVC<MySearchPage> {

  _MySearchPageState() : super(SettingController()) {
    con = controller as SettingController;
  }

  late SettingController con;

  TextEditingController scontroller = TextEditingController();
  
  int isSearch=-1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
               width: size.width,
               decoration: BoxDecoration(
              color: MyColor.coreBackgroundColor, //mainColor
              borderRadius: BorderRadius.circular(50)
            ),
            margin: EdgeInsets.only(top: 12,left: 16,right: 16,bottom: 24),
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
              child: Row(
                children: [
                        Backbutt(),
                        Expanded(
                        child: TextFormField(
                        onTap: () {},
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        controller: scontroller,
                        onFieldSubmitted: (value)async {
                          if (value.isEmpty) {
                            isSearch = -1;
                          }
                          isSearch = 1;
                          setState(() { });
                                      await con.searchApi(context,value,onChanged: (value) {
                            isSearch = 0;
                            setState(() { });
                         });
                         
                        },
                        onChanged: (value) {
                          setState(() { });
                        },
                        textDirection: !UtilsHelper.rightHandLang.contains(appState.currentLanguageCode.value) ? TextDirection.ltr : TextDirection.rtl,
                        decoration: InputDecoration(
                        hintText: UtilsHelper.getString(context, 'search'),
                        suffixIcon:scontroller.text.isNotEmpty ?
                         Material(
                          color: Colors.transparent,
                          child: InkResponse(
                            onTap: () {
                              scontroller.clear();
                              con.searchList = [];
                              isSearch = -1;
                              setState(() { });
                              // Navigator.pop(context);
                            },
                            child: Ink(
                              padding: EdgeInsets.all(4),
                              child: Container(
                                margin: EdgeInsets.only(left:  !UtilsHelper.rightHandLang.contains(appState.currentLanguageCode.value) ? 00 :0),
                                child: Icon(
                                Icons.close_rounded,
                                color: dark(context) ? Colors.white : MyColor.iconColor,
                              ),
                              ),
                            ),
                          ),
                        ) : SizedBox(),
                        
                        hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: dark(context) ? Colors.white70 : Color.fromRGBO(166, 188, 208, 1)),
                        prefixIconConstraints:BoxConstraints(maxWidth: 0),
                        prefixStyle: TextStyle(fontSize: 16,color: MyColor.commonColorSet1),
                        hintTextDirection: TextDirection.ltr,
                        border:InputBorder.none,
                        contentPadding:EdgeInsets.only(left: 4,right: 0,top: 10,bottom: 10),),
                        style: TextStyle(fontSize: 16, color:dark(context) ?Colors.white :  MyColor.black),
                      ),
                    ),
                  ],
              ),
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: isSearch == 1 ? [
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    height: size.height/1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimateWidget(
                          width: 60,
                          height:60,
                         child: Icon(Icons.search,color: dark(context) 
                         ? Colors.white : Colors.black,
                         weight: 400,size: 36,)
                       ),
                       SizedBox(height: 16),
                       Text( UtilsHelper.getString(context, 'getting_search_result')),
                      ],
                    ))
                 ] : isSearch == 0 && con.searchList.isEmpty ? [
                     Container(
                      alignment: Alignment.center,
                      height: size.height/1.5,
                      child: Text(( UtilsHelper.getString(context, 'no_result_found'))),
                     )
                 ] : [
                         ValueListenableBuilder<List<Product>>(
                                  valueListenable: appState.carts,
                                  builder: (context, cartsProducts, child) {
                                    return GridView.custom(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        mainAxisExtent : 200,
                                        childAspectRatio: 0.7,
                                      ),
                                      shrinkWrap: true,
                                      primary: false,
                                      scrollDirection: Axis.vertical,
                                      childrenDelegate: SliverChildListDelegate(
                                        con.searchList.map(
                                          (data) {
                                            Product product = data;
                                            int productQuantity = 0;
                                            Product cartProduct;
                                            cartProduct = appState.carts.value
                                                .firstWhere(
                                                    (element) =>element.id == product.id,
                                                    orElse: () =>
                                                        Product(quantity: 0));
                                            productQuantity =
                                                cartProduct.quantity;
                                            return ProductGridWidget(
                                              product: product,
                                              productQuantity: productQuantity);
                            },
                          ).toList(),
                        ),
                      );
                    }),
                  SizedBox(height: 16)
                ]),
             ))
           ],
        ),
      ),
    );
  }
}

class ProductGridWidget extends StatelessWidget {
  const ProductGridWidget({
    super.key,
    required this.product,
    required this.productQuantity,
  });

  final Product product;
  final int productQuantity;

  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product_detail',arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(20)),
          color:  MyColor.coreBackgroundColor, //coreBackgroundColor
        
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              Container(
                alignment:Alignment.center,                                        
                child: ClipRRect(
                  borderRadius:BorderRadius.circular(15) ,
                  child: Container(
                    height: 100,
                    width: size.width,
                    color: Colors.white,
                    child: Image(
                    //  fit: BoxFit.fitWidth,
                      image:CachedNetworkImageProvider(
                        Urls.getImageUrlFromName(product.image ??""),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(
                // height: 8,
              ),
           
                Expanded(
                flex: 5,
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              // if (productQuantity > 0)
                               Spacer(),
                              Text(
                                product.name!,
                                maxLines: productQuantity == 0 ? 1 : 2,
                               overflow:TextOverflow.ellipsis,
                                style: Theme.of(
                                        context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                        fontSize:12,
                                        color: MyColor.bottomNavBar, //commonColorSet1
                                        fontWeight: FontWeight.w600,
                                        fontFamily: !UtilsHelper.rightHandLang.contains(appState.currentLanguageCode.value)
                                            ? UtilsHelper.wr_default_font_family
                                            : UtilsHelper.the_sans_font_family),
                              ),
                              // if (productQuantity == 0)
                              Spacer(
                                //  height: 6,
                              ),
                              if (productQuantity == 0)
                              Expanded(
                                flex:4,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      (product.discountPrice !=
                                                  null &&
                                              product.discountPrice! >
                                                  0)
                                          ? displayPrice(
                                              product.discountPrice)
                                          : displayPrice(
                                              product.price),
                                      textDirection:
                                          TextDirection
                                              .ltr,
                                      style: Theme.of(
                                              context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(fontSize:14,
                                        color:MyColor.textSecondarySecondLightColor),
                                    ),
                                    Spacer(),
                              GestureDetector(
                              onTap: () {
                                print('add tapped');
                                appState.addNewProductQuantity(product,product.mininumOrderQuantity ?? 0);
                                 },
                            child: Container(
                              height: 27,
                              width: 27,
                              decoration:BoxDecoration(// color: Color(//     0xFFB3874B),
                              color: MyColor.commonColorSet2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 17,
                                color: Colors
                                    .white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
        if (productQuantity > 0)
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                            .brightness !=
                        Brightness.light
                    ? MyColor.mainColor
                    : MyColor
                        .coreBackgroundColor,
                borderRadius:
                    BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (productQuantity == product.mininumOrderQuantity) {
                              appState.removeProductFromCart(product, selectedQuatity:product.mininumOrderQuantity);
                            } else if (productQuantity > product.mininumOrderQuantity!.toInt()) {
                              appState.decreaseProduct(product);
                            }
                          },
                          child: Container(
                            height: 27,
                            width: 27,
                            decoration:
                            BoxDecoration(color:MyColor.white,
                                borderRadius:BorderRadius.all(Radius.circular(20),
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 14,
                          ),
                        ),
                      ),
                    Text(
                      productQuantity.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:FontWeight.bold,
                        color: MyColor.bottomNavBar,
                      ),
                    ),
                      GestureDetector(
                        onTap: () {
                          appState
                              .increaseProduct(
                                  product);
                        },
                        child: Container(
                          height: 27,
                          width: 27,
                          decoration: BoxDecoration(
                                color : MyColor.white,
                                borderRadius:BorderRadius.all(Radius.circular(20)),
                              ),
                                child: Icon(
                                  Icons.add,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                        ),
                      ),
                ),
                  // if (productQuantity > 0)
                  // SizedBox(height: 6),
                ],
              ),
            ),
          ),
        );
  }
}

class Backbutt extends StatelessWidget {
  const Backbutt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100)
      ),
      color: Colors.transparent,
      child:  InkResponse(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100)
      ),
      onTap: () {
        Navigator.pop(context);
      },
      child:Ink(
      padding: EdgeInsets.all(14),
      child:  SvgPicture.asset('assets/icon-arrow.svg',
      colorFilter: ColorFilter.mode( dark(context)
      ? Colors.white : Colors.black,BlendMode.srcIn))),
    ));
  }
}