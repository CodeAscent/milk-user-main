import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';

import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/header.dart';

class PickAddress extends StatefulWidget {
  const PickAddress({Key? key}) : super(key: key);

  @override
  _PickAddressState createState() => _PickAddressState();
}

class _PickAddressState extends State<PickAddress> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchTerm = TextEditingController();
  TextEditingController _addressTitle = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  int _selectedAddress = 0;
  bool _isBottomSheetOpen = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    List _addressType = [
      UtilsHelper.getString(context, 'home'),
      UtilsHelper.getString(context, 'office'),
      // UtilsHelper.getString(context, 'mosque'),
      UtilsHelper.getString(context, 'other')
    ];

    List _deliveryInstructions = [
      'Ring the bell',
      'Do not ring the bell',
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: headerWidget(
                  title: UtilsHelper.getString(context, 'pick_address'),
                  onPress: () {
                    Navigator.of(context).pop();
                  },
                  context: context,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (_isBottomSheetOpen == false)
                Container(
                    height: 46,
                    width: size.width * 0.84,
                    padding:
                        EdgeInsets.symmetric(horizontal: lang == 'en' ? 0 : 15),
                    decoration: BoxDecoration(
                      color: MyColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        if (lang != 'en')
                          Row(
                            textDirection: TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 30,
                                child: Icon(Icons.search),
                              ),
                              Container(
                                width: size.width * 0.84 - 90,
                                height: 46,
                                child: TextField(
                                  controller: _searchTerm,
                                  cursorColor: MyColor.textPrimaryColor,
                                  decoration: InputDecoration(
                                    hintText: UtilsHelper.getString(
                                        context, "street_address"),
                                    hintStyle: TextStyle(
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                      fontSize: 15,
                                      color: Color(0xFFA6BCD0),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    focusColor: MyColor.white,
                                    fillColor: MyColor.white,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (lang == 'en')
                          Container(
                            height: 46,
                            child: TextField(
                              controller: _searchTerm,
                              cursorColor: MyColor.textPrimaryColor,
                              decoration: InputDecoration(
                                hintText: UtilsHelper.getString(
                                    context, "street_address"),
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFA6BCD0),
                                  fontWeight: FontWeight.normal,
                                ),
                                focusColor: MyColor.white,
                                fillColor: MyColor.white,
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: MyColor.textPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                commonButton(
                  onPress: () {
                    Future _future = addAddressBottomSheet(
                      deliveryNotes: _deliveryInstructions,
                      addressType: _addressType,
                      size: size,
                      lang: lang,
                    );
                    _future.then((value) => setState(() {
                          _isBottomSheetOpen = false;
                        }));
                  },
                  prefixPath: 'assets/icon_arrow.svg',
                  title: UtilsHelper.getString(context, 'select'),
                  textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                            ? UtilsHelper.wr_default_font_family
                            : UtilsHelper.the_sans_font_family,
                        color: MyColor.textPrimaryLightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                  color: MyColor.darkYellow,
                ),
                SizedBox(
                  height: 85,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> addAddressBottomSheet({
    required List addressType,
    required Size size,
    required lang,
    required List deliveryNotes,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _isBottomSheetOpen = true;
          });
        });
        return SizedBox.fromSize(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 31, right: 31, top: 54),
                      color: MyColor.mainColorWithBlack,
                      //  height: 720,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                UtilsHelper.getString(context, 'type'),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                      color:
                                          MyColor.textSecondarySecondLightColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                height: 38,
                                width: size.width,
                                child: Row(
                                  // shrinkWrap: true,
                                  // scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                    addressType.length,
                                    (index) => Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedAddress = index;
                                          });
                                        },
                                        child: Container(
                                          // width: 87,
                                          margin: EdgeInsets.only(
                                              right: index == 0 ? 0 : 9),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            color: _selectedAddress == index
                                                ? MyColor.commonColorSet2
                                                : MyColor.mainColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              addressType[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontFamily: !UtilsHelper
                                                            .rightHandLang
                                                            .contains(lang)
                                                        ? UtilsHelper
                                                            .wr_default_font_family
                                                        : UtilsHelper
                                                            .the_sans_font_family,
                                                    fontSize: 13,
                                                    color: _selectedAddress ==
                                                            index
                                                        ? MyColor.white
                                                        : MyColor
                                                            .textSecondarySecondLightColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Row(
                            children: [
                              Text(
                                UtilsHelper.getString(context, 'address_title'),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                      color:
                                          MyColor.textSecondarySecondLightColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: MyColor.mainColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: TextField(
                              controller: _addressTitle,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Row(
                            children: [
                              Text(
                                UtilsHelper.getString(context, 'notexxx'),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontFamily: !UtilsHelper.rightHandLang
                                              .contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                      color: MyColor.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          
                          Container(
                            height: 85,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: MyColor.mainColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: TextField(
                              controller: _noteController,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: size.width,
                            child: commonButton(
                              onPress: () {
                                Navigator.of(context)
                                    .pushNamed(RoutePath.checkout_pay);
                              },
                              prefixPath: 'assets/icon_arrow.svg',
                              title: UtilsHelper.getString(
                                  context, 'select_botton'),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontFamily: !UtilsHelper.rightHandLang
                                            .contains(lang)
                                        ? UtilsHelper.wr_default_font_family
                                        : UtilsHelper.the_sans_font_family,
                                    color: MyColor.textPrimaryLightColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                              color: MyColor.darkYellow,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    // height:MediaQuery.of(context).viewInsets.bottom,
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
