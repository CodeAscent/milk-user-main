import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/View/search.dart';

import '../Utils/Router/route_path.dart';
import '../Utils/ThemeData/themeColors.dart';
import '../Utils/local_data/app_state.dart';
import '../Utils/rgbo_to_hex.dart';
import '../Utils/urls.dart';
import '../Utils/utils.dart';
import '../model/product/product_item.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late int selectedQuatity;
  late List<int> quantities;

  late bool isCarted = false;
// 1,2,3,4,5,6,7,8,9,10
  @override
  void initState() {
    selectedQuatity = widget.product.mininumOrderQuantity!.toInt();
    quantities = [
      ...List.generate(
          10,
          (index) => index == 0
              ? index + widget.product.mininumOrderQuantity!.toInt()
              : index + widget.product.mininumOrderQuantity!.toInt())
    ];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(widget.product.toJson());
      var cartProduct = appState.carts.value.firstWhere(
          (element) => element.id == widget.product.id,
          orElse: () => Product(quantity: 0));
      isCarted = cartProduct.quantity > 0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    int productQuantity = 0;
    Product cartProduct;
    cartProduct = appState.carts.value.firstWhere(
        (element) => element.id == product.id,
        orElse: () => Product(quantity: 0));
    productQuantity = cartProduct.quantity;
    // widget.product.quantity = cartProduct.quantity;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Backbutt(),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/search_page');
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Image.asset('assets/search.png',
                            color: dark(context)
                                ? Colors.white
                                : MyColor.commonColorSet1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    // Container(
                    //   width: 120,
                    //   height: 120,
                    //   child: Image.asset('assets/water-drop.png')),
                    Container(
                        width: size.width,
                        height: size.height / 2.5,
                        margin: EdgeInsets.symmetric(horizontal: 26),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          //color: dark(context) ?  MyColor.coreBackgroundColor : MyColor.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: Urls.getImageUrlFromName(
                                  widget.product.image ?? ""),
                            ))),
                    SizedBox(height: 32),
                    Container(
                      width: size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name ?? '',
                              textAlign: TextAlign.left,
                              // maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      fontSize: 16,
                                      color: MyColor
                                          .bottomNavBar, //commonColorSet1
                                      fontWeight: FontWeight.bold,
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(appState
                                                  .currentLanguageCode.value)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      // padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(6),
                      //   border: Border.all(width: 1,color:
                      //   dark(context) ? Colors.white.withOpacity(0.3) : MyColor.commonColorSet1!.withOpacity(0.3))
                      // ),
                      child: Text(
                        widget.product.discountPrice != null
                            ? displayPrice(double.parse(
                                widget.product.discountPrice.toString()))
                            : widget.product.price != null
                                ? displayPrice(double.parse(
                                    widget.product.price.toString()))
                                : "0.00",
                        textDirection: TextDirection.ltr,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: MyColor.textSecondarySecondLightColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Divider(
                          height: 0, thickness: 1, indent: 20, endIndent: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(UtilsHelper.getString(context, 'description'),
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 16),
                          Text(widget.product.description ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 16),
                        ],
                      ),
                    )
                  ]),
            )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: size.width,
          child: Row(children: [
            if (productQuantity == 0)
              Expanded(
                child: Container(
                  height: 50,
                  child: InputDecorator(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        fillColor: dark(context)
                            ? MyColor.coreBackgroundColor
                            : MyColor.lightBackground,
                        filled: true,
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        // hintText: getTranslator("select"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                      // isEmpty: selectedQuatity ==
                      //     1,
                      child: Row(children: [
                        Text(UtilsHelper.getString(context, 'quantity'),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: selectedQuatity,
                              icon: Icon(Icons.keyboard_arrow_down_outlined),
                              items: quantities.isNotEmpty
                                  ? quantities
                                      .map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(
                                          "    $value",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                      );
                                    }).toList()
                                  : [],
                              hint: Text(
                                UtilsHelper.getString(context, "select "),
                              ),
                              onChanged: (value) {
                                //  print('selectedQuatity');
                                // print(selectedQuatity);
                                setState(() {
                                  widget.product.quantity +=
                                      productQuantity + value!;
                                  //  productQuantity += value;
                                  selectedQuatity = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ])),
                ),
              ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: MyColor.commonColorSet2),
                    onPressed: () {
                      if (isCarted == true) {
                        Navigator.of(context)
                            .pushNamed(RoutePath.order_detail)
                            .then((value) {
                          cartProduct = appState.carts.value.firstWhere(
                              (element) => element.id == product.id,
                              orElse: () => Product(quantity: 0));
                          productQuantity = cartProduct.quantity;
                          isCarted = productQuantity > 0;
                          setState(() {});
                        });
                        //      appState.bulkIncreaseProduct(product,widget.product.quantity);
                      } else {
                        appState.addNewProductQuantity(
                            product, selectedQuatity);
                        isCarted = true;
                        setState(() {});
                      }
                    },
                    child: isCarted
                        ? Text(
                            UtilsHelper.getString(context, 'checkout'),
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(UtilsHelper.getString(context, 'add_to_cart'),
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Helvetica'))),
              ),
            ),
            //  SizedBox(width: 12),
          ])),
    );
  }
}
