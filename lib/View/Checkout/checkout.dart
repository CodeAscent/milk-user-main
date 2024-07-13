import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/project_keys.dart';
import 'package:water/Utils/utils.dart';
import 'package:water/View/shimmers/address_list_shimmer.dart';

import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/controllers/address_controller.dart';
import 'package:water/model/address_item.dart';

import '../../Utils/Router/route_path.dart';
import '../../Utils/rgbo_to_hex.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends StateMVC<Checkout> {
  _CheckoutState() : super(AddressController()) {
    con = controller as AddressController;
  }
  late AddressController con;

  TextEditingController _addressTitle = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  bool pickLocationEnable = true;
  int selectedLocationId = -1;
  int _selectedAddress = 0;
  List<String> addressTypeList = ['home', 'office', 'other'];
  List? _addressType;

  List _deliveryInstructions = [
    'Ring the bell',
    'Do not ring the bell',
  ];

  late Razorpay _razorpay;

  @override
  void initState() {
    con.getAddressListApi();
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_JIaCZn9j1rka2r',
      'amount': appState.finalTotal * 100,
      'name': appState.userModel.name ?? 'User',
      'description': 'Payment',
      'prefill': {
        'contact': appState.userModel.phone,
        'email': 'test@razorpay.com'
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'amazonpay']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(null, "Payment done successfully"));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(null, 'Payment Cancelled'));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(
            null, "EXTERNAL_WALLET: " + response.walletName.toString()));
  }

  static Future<bool> requestLocationPermission(BuildContext context) async {
    // Request location permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, prompt the user to enable it
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Service'),
          content:
              Text('Please enable location services to access this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return false;
    }

    // Check if permission is granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Permission is denied, request permission
      permission = await Geolocator.requestPermission();
    }

    // Return whether permission is granted or not
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  void _showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Please allow the location permission to Add Address'),
      duration: Duration(seconds: 2), // Duration for which snackbar is visible
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Perform an action when the user presses the action button
          // For example, you can undo the operation that triggered the snackbar
        },
      ),
    );

    // Show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var lang = appState.currentLanguageCode.value;
    _addressType = [
      UtilsHelper.getString(context, addressTypeList[0]),
      UtilsHelper.getString(context, addressTypeList[1]),
      UtilsHelper.getString(context, addressTypeList[2]),
    ];

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: headerWidget(
              title: UtilsHelper.getString(context, 'checkout'),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 31,
                          ),
                          GestureDetector(
                            onTap: () async {
                              bool permissionGranted =
                                  await requestLocationPermission(context);
                              if (permissionGranted) {
                                print("Permisssion Granted");
                                print("add address pressed");
                                _addressTitle.clear();
                                _noteController.clear();
                                _selectedAddress = 0;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                      selectInitialPosition: true,
                                      pinBuilder: (context, state) {
                                        return Icon(Icons.location_pin,
                                            color: MyColor.commonColorSet2,
                                            size: 40);
                                      },
                                      apiKey: ProjectKeys.googlePlacePickerKey,
                                      selectedPlaceWidgetBuilder: (context,
                                          PickResult? result,
                                          state,
                                          isSearchBarFocused) {
                                        return selectPlaceWidgetBuild(
                                            context,
                                            result,
                                            state,
                                            isSearchBarFocused,
                                            _addressType!,
                                            lang,
                                            size,
                                            null);
                                      }, // Put YOUR OWN KEY here.
                                      onPlacePicked: (result) {},
                                      initialPosition: LatLng(
                                          37.42796133580664, -122.085749655962),
                                      useCurrentLocation: true,
                                    ),
                                  ),
                                );
                              } else {
                                print("Permisssion Not Granted");
                                _showSnackbar(context);
                              }
                            },
                            child: Container(
                              height: 50,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? MyColor.commonColorSet1
                                    : MyColor.coreBackgroundColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: MyColor.commonColorSet2,
                                      child: Center(
                                        child: RotatedBox(
                                          quarterTurns: 2,
                                          child: SvgPicture.asset(
                                            "assets/location.svg",
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              UtilsHelper.getString(
                                                  context, 'add_address'),
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
                                                    color: dark(context)
                                                        ? Colors.white
                                                        : MyColor
                                                            .textPrimaryColor,
                                                  ),
                                            ),
                                            Container(
                                              height: 31,
                                              width: 31,
                                              decoration: BoxDecoration(
                                                color: MyColor.commonColorSet2,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(22),
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                            // if (pickLocationEnable == true)
                                            //   Container(
                                            //     height: 5,
                                            //     child: RotatedBox(
                                            //       quarterTurns: 1,
                                            //       child: SvgPicture.asset(
                                            //       "assets/icon-chevron.svg",
                                            //       fit: BoxFit.fitHeight,
                                            //       colorFilter:ColorFilter.mode( Color(0xff748A9D),BlendMode.srcIn),
                                            //     ),
                                            //   )),
                                            // if (pickLocationEnable == false)
                                            //   Container(
                                            //     height: 10,
                                            //     child: RotatedBox(
                                            //       quarterTurns: 3,
                                            //       child: SvgPicture.asset(
                                            //         "assets/icon-chevron.svg",
                                            //         fit: BoxFit.fitHeight,
                                            //         colorFilter:ColorFilter.mode( Color(0xff748A9D), BlendMode.srcIn),
                                            //       ),
                                            //     ),
                                            //   ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          if (con.pickupAddressList == null)
                            AddressListShimmer()
                          else
                            ValueListenableBuilder<List<AddressItem>>(
                                valueListenable: appState.pickupAddressList,
                                builder: (context, _pickupAddressList, child) {
                                  return ListView.builder(
                                    itemCount: _pickupAddressList.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      AddressItem _addressItem =
                                          _pickupAddressList[index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: addressPanel(
                                            size: size,
                                            title: _addressItem.type,
                                            description: _addressItem
                                                .getFormattedAddress(),
                                            selected: selectedLocationId,
                                            isDefault: _addressItem.isDefault,
                                            addressItem: _addressItem,
                                            index: index,
                                            lang: lang),
                                      );
                                    },
                                  );
                                }),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: commonButton(
                      onPress: () {
                        if (selectedLocationId >= 0) {
                          appState.selectedPickupAddress = appState
                              .pickupAddressList.value[selectedLocationId];
                          Navigator.of(context)
                              .pushNamed(RoutePath.checkout_pay);
                          // openCheckout();
                        } else {
                          commonAlertNotification("Error",
                              message: UtilsHelper.getString(
                                  context, "select_pickup_address"));
                        }
                      },
                      prefixPath: 'assets/icon_arrow.svg',
                      title: UtilsHelper.getString(context, 'next'),
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                              fontFamily:
                                  !UtilsHelper.rightHandLang.contains(lang)
                                      ? UtilsHelper.wr_default_font_family
                                      : UtilsHelper.the_sans_font_family,
                              color: dark(context)
                                  ? Colors.white
                                  : MyColor.textPrimaryLightColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
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
        ],
      ),
    );
  }

  Widget addressPanel(
      {size,
      String? title,
      String? description,
      int? index,
      int? isDefault,
      AddressItem? addressItem,
      required int selected,
      required lang}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedLocationId = index!;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          child: Container(
            height: 60,
            width: size.width,
            decoration: BoxDecoration(
              color: MyColor.coreBackgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Container(
                  child: Center(
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? (selected != index
                                  ? MyColor.coreBackgroundColor
                                  : MyColor.commonColorSet2!.withOpacity(0.2))
                              : (selected == index
                                  ? MyColor.white
                                  : MyColor.mainColor),
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          color: selected != index
                              ? Colors.black.withOpacity(0.1)
                              : MyColor.commonColorSet2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UtilsHelper.getString(context, (title ?? '')),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontFamily:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? UtilsHelper.wr_default_font_family
                                        : UtilsHelper.the_sans_font_family,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: MyColor.textPrimaryColor,
                              ),
                        ),
                        Container(
//                      width: size.width - 200,
                          child: Text(
                            description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontFamily: !UtilsHelper.rightHandLang
                                            .contains(lang)
                                        ? UtilsHelper.wr_default_font_family
                                        : UtilsHelper.the_sans_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: MyColor.textPrimaryDarkColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlacePicker(
                          apiKey: ProjectKeys.googlePlacePickerKey,
                          pinBuilder: (context, state) {
                            return Icon(Icons.location_pin,
                                color: MyColor.commonColorSet2, size: 40);
                          },
                          selectInitialPosition: true,
                          selectedPlaceWidgetBuilder: (context,
                              PickResult? result, state, isSearchBarFocused) {
                            return selectPlaceWidgetBuild(
                                context,
                                result,
                                state,
                                isSearchBarFocused,
                                _addressType!,
                                lang,
                                size,
                                addressItem);
                          }, // Put YOUR OWN KEY here.
                          onPlacePicked: (result) {},
                          initialPosition: LatLng(
                              double.parse(addressItem!.latitude!),
                              double.parse(addressItem.longitude!)),
                          useCurrentLocation: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 45,
                    color: hexToRgb('#748A9D'),
                    child: Center(
                      child: Container(
                        height: 23,
                        child: SvgPicture.asset(
                          "assets/edit_icon.svg",
                          height: 23,
                          fit: BoxFit.fitHeight,
                          colorFilter:
                              ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    color: MyColor.commonColorSet1,
                    width: 1,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: 1,
                      color: Colors.transparent,
                    )),
                if (isDefault != 1)
                  InkWell(
                    onTap: () {
                      con.addressDeleteApi(context, addressItem!);
                    },
                    child: Container(
                      width: 45,
                      color: hexToRgb('#748A9D'),
                      child: Center(
                        child: Container(
                          height: 23,
                          child: SvgPicture.asset(
                            "assets/edit_delete.svg",
                            height: 23,
                            fit: BoxFit.fitHeight,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Future<dynamic> addAddressBottomSheet({
    required List addressType,
    required Size size,
    required lang,
    PickResult? pickResult,
    AddressItem? addressItem,
    required List deliveryNotes,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox.fromSize(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: dark(context)
                        ? MyColor.commonColorSet1
                        : hexToRgb('#F0F4F8'),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 26, vertical: 30),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 24, right: 24, top: 30),
                        // color: MyColor.mainColorWithBlack,
                        // height: 520,
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
                                        color: dark(context)
                                            ? Colors.white
                                            : MyColor.commonColorSet1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
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
                                  child: Center(
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
                                              margin: EdgeInsets.only(right: 9),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                color: _selectedAddress == index
                                                    ? MyColor.baseDarkColor
                                                    : dark(context)
                                                        ? MyColor.baseDarkColor!
                                                            .withOpacity(0.3)
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
                                                            : dark(context)
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.3)
                                                                : MyColor
                                                                    .commonColorSet1,
                                                      ),
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
                                  UtilsHelper.getString(
                                      context, 'address_title'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontFamily: !UtilsHelper.rightHandLang
                                                .contains(lang)
                                            ? UtilsHelper.wr_default_font_family
                                            : UtilsHelper.the_sans_font_family,
                                        color: dark(context)
                                            ? Colors.white
                                            : MyColor.commonColorSet1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
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
                                color: dark(context)
                                    ? Color.fromRGBO(63, 76, 84, 1)
                                    : MyColor.mainColor,
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
                                  UtilsHelper.getString(context, 'note'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontFamily: !UtilsHelper.rightHandLang
                                                .contains(lang)
                                            ? UtilsHelper.wr_default_font_family
                                            : UtilsHelper.the_sans_font_family,
                                        color: dark(context)
                                            ? Colors.white
                                            : MyColor.commonColorSet1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
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
                                color: dark(context)
                                    ? Color.fromRGBO(63, 76, 84, 1)
                                    : MyColor.mainColor,
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
                              height: 7,
                            ),
                            Row(
                              children: [
                                Text(
                                  UtilsHelper.getString(
                                      context, 'Delivery Instructions'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontFamily: !UtilsHelper.rightHandLang
                                                .contains(lang)
                                            ? UtilsHelper.wr_default_font_family
                                            : UtilsHelper.the_sans_font_family,
                                        color: MyColor
                                            .textSecondarySecondLightColor,
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
                                      deliveryNotes.length,
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
                                                deliveryNotes[index],
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
                                                      fontSize: 10,
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
                              height: 7,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: size.width,
                              child: commonButton(
                                onPress: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_addressTitle.text.trim().isNotEmpty) {
                                    Placemark placemark =
                                        await getAddressFromLatLong(
                                            pickResult!.geometry!.location.lat,
                                            pickResult.geometry!.location.lng);
                                    print(placemark);
                                    AddressItem _addressItem = AddressItem(
                                      id: addressItem == null
                                          ? 0
                                          : addressItem.id,

                                      /// for add it's 0 & for update it's 1.
                                      type: addressTypeList[_selectedAddress],
                                      address: _addressTitle.text.trim(),
                                      googleAddress:
                                          pickResult.formattedAddress,
                                      // googleAddress: placemark.street,
                                      note: _noteController.text.trim(),
                                      city: placemark.subAdministrativeArea,
                                      state: placemark.locality,
                                      country: placemark.country,
                                      zipcode: placemark.postalCode,
                                      latitude: pickResult
                                          .geometry!.location.lat
                                          .toString(),
                                      longitude: pickResult
                                          .geometry!.location.lng
                                          .toString(),
                                      isDefault: 0, // TODO: for default value
                                    );
                                    con.addressAddUpdateApi(
                                        context, _addressItem);
                                  } else {
                                    commonAlertNotification("Error",
                                        message: UtilsHelper.getString(
                                            context, "enter_address_title"));
                                  }
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
                                color: MyColor.commonColorSet2,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget selectPlaceWidgetBuild(
      BuildContext context,
      PickResult? result,
      SearchingState state,
      bool isSearchBarFocused,
      List _addType,
      String lang,
      Size size,
      AddressItem? addressItem) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.05,
      leftPosition: MediaQuery.of(context).size.width * 0.025,
      rightPosition: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.9,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching
          ? Container(
              height: 48,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    result!.formattedAddress!,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  commonButton(
                    onPress: () {
                      if (addressItem != null) {
                        _addressTitle.text = addressItem.address!;
                        _noteController.text = addressItem.note!;
                        _selectedAddress =
                            addressTypeList.indexOf(addressItem.type!);
                      }
                      Future _future = addAddressBottomSheet(
                          deliveryNotes: _deliveryInstructions,
                          addressType: _addType,
                          size: size,
                          lang: lang,
                          pickResult: result,
                          addressItem: addressItem);
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
                    color: MyColor.commonColorSet2,
                  ),
                ],
              ),
            ),
    );
  }
}
