import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/utils.dart';
import 'package:water/View/payments/paypal/paypal_payment.dart';
import 'package:water/View/payments/stripe/stripe_payment.dart';
import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/controllers/order_controller.dart';
import 'package:water/model/checkout.dart';
import 'package:water/model/settings_model/time_slot.dart';
import 'package:water/repository/setting_repository.dart';

import '../../Utils/rgbo_to_hex.dart';

class CheckoutAndPay extends StatefulWidget {
  const CheckoutAndPay({Key? key}) : super(key: key);

  @override
  _CheckoutAndPayState createState() => _CheckoutAndPayState();
}

class _CheckoutAndPayState extends StateMVC<CheckoutAndPay> {
  // String? payMethod;

  _CheckoutAndPayState() : super(OrderController()) {
    con = controller as OrderController;
  }

  late OrderController con;

  int _selectedTimeSlot = 0;
  int _selectedPaymentMethod = 0;
  bool isPaymentMethod = true;
  bool isTimeOfDelivery = true;
  bool isCreditCard = false;

  late Razorpay _razorpay;

  @override
  void initState() {
    con.getMyWalletAmountApi(context);
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

  Future openCheckout() async {
    var options = {
      'key': setting.value.setting!['razorpay_key'],
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
    con.orderPlaceApi(
        context, 'Razorpay', setting.value.timeslots![_selectedTimeSlot].id!);
    commonAlertNotification("Error",
        message: UtilsHelper.getString(null, "Payment done successfully"));
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     RoutePath.home_screen, (Route<dynamic> route) => false);
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

  @override
  Widget build(BuildContext context) {
    var lang = appState.currentLanguageCode.value;
    final size = MediaQuery.of(context).size;

    List _availablePaymentMethods = [
      if (setting.value.setting!['enable_cod'] == '1')
        {
          "id": 23,
          "title": UtilsHelper.getString(context, 'cash_on_delivery'),
          "desc": ""
        },
      if (setting.value.setting!['enable_wallet'] == '1')
        {
          "id": 24,
          "title": UtilsHelper.getString(context, 'wallet'),
          "desc": UtilsHelper.getString(context, "balance")
        },
      if (setting.value.setting!['enable_razorpay'] == '1')
        {
          "id": 0,
          "title": UtilsHelper.getString(context, 'Razorpay'),
          "desc": ""
        },
      // {"title": UtilsHelper.getString(context, 'Stripe'), "desc": ""},
      if (isPaypal == '1')
        {
          "id": 1,
          "title": UtilsHelper.getString(context, 'paypal'),
          "desc": ""
        },
      if (setting.value.setting!['enable_stripe'] == '1')
        {
          "id": 2,
          "title": UtilsHelper.getString(context, 'stripe'),
        },
      // {"title": UtilsHelper.getString(context, 'paylabs'), "desc": ""},
      // {"title": UtilsHelper.getString(context, 'credit_card'), "desc": ""},
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: headerWidget(
              title: UtilsHelper.getString(context, 'checkout'),
              onPress: () {
                Navigator.pop(context);
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
                      height: 30,
                    ),
                    dropDownRow(
                        prefixPath: "assets/Clock.svg",
                        title:
                            UtilsHelper.getString(context, 'time_of_delivery'),
                        onPress: () {
                          setState(() {
                            isTimeOfDelivery = !isTimeOfDelivery;
                          });
                        },
                        isOpen: isTimeOfDelivery,
                        lang: lang),
                    SizedBox(
                      height: 15,
                    ),
                    if (isTimeOfDelivery == true)
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: setting.value.timeslots!.length,
                        itemBuilder: (context, index) {
                          Timeslot timeSlot = setting.value.timeslots![index];
                          List<String> fromTimeStr =
                              timeSlot.fromTime!.split(":");
                          TimeOfDay fromTime = TimeOfDay(
                              hour: int.parse(fromTimeStr[0]),
                              minute: int.parse(fromTimeStr[1]));

                          List<String> toTimeStr = timeSlot.toTime!.split(":");
                          TimeOfDay toTime = TimeOfDay(
                              hour: int.parse(toTimeStr[0]),
                              minute: int.parse(toTimeStr[1]));

                          return Column(
                            children: [
                              CheckoutTile(
                                  isCreditCard: isCreditCard,
                                  title: UtilsHelper.getString(
                                      context, timeSlot.name!),
                                  desc: fromTime.format(context) +
                                      " - " +
                                      toTime.format(context),
                                  isActive:
                                      _selectedTimeSlot == index ? true : false,
                                  onPress: () {
                                    setState(() {
                                      _selectedTimeSlot = index;
                                    });
                                  },
                                  lang: lang),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    if (isTimeOfDelivery == true)
                      SizedBox(
                        height: 15,
                      ),
                    dropDownRow(
                        prefixPath: "assets/card.svg",
                        title: UtilsHelper.getString(context, 'payment_method'),
                        onPress: () {
                          setState(() {
                            isPaymentMethod = !isPaymentMethod;
                          });
                        },
                        isOpen: isPaymentMethod,
                        lang: lang),
                    SizedBox(
                      height: 15,
                    ),
                    if (isPaymentMethod)
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: _availablePaymentMethods.length,
                        itemBuilder: (context, index) {
                          return _availablePaymentMethods[index]['title'] ==
                                  null
                              ? null
                              : Column(
                                  children: [
                                    (_availablePaymentMethods[index]['title'] ==
                                            UtilsHelper.getString(
                                                context, 'wallet'))
                                        ? ValueListenableBuilder<double>(
                                            valueListenable:
                                                appState.myWalletBalance,
                                            builder: (context, _myWalletBalance,
                                                child) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CheckoutTile(
                                                      isCreditCard:
                                                          isCreditCard,
                                                      title:
                                                          _availablePaymentMethods[
                                                              index]['title'],
                                                      desc: UtilsHelper
                                                              .getString(
                                                                  context,
                                                                  'balance') +
                                                          " | " +
                                                          displayPriceDouble(
                                                              _myWalletBalance),
                                                      isActive:
                                                          _selectedPaymentMethod ==
                                                                  _availablePaymentMethods[
                                                                          index]
                                                                      ['id']
                                                              ? true
                                                              : false,
                                                      onPress: () {
                                                        setState(() {
                                                          _selectedPaymentMethod =
                                                              _availablePaymentMethods[
                                                                  index]['id'];

                                                          // payMethod =_availablePaymentMethods[index]['title'];
                                                        });
                                                      },
                                                      lang: lang),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.mainColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          print(
                                                              "add balance pressed");
                                                          await Navigator.of(
                                                                  context)
                                                              .pushNamed(
                                                                  RoutePath
                                                                      .add_wallet_amount,
                                                                  arguments:
                                                                      appState
                                                                          .finalTotal);
                                                          con.getMyWalletAmountApi(
                                                              context);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: lang ==
                                                                  'en'
                                                              ? MainAxisAlignment
                                                                  .spaceBetween
                                                              : MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 31,
                                                              width: 31,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: MyColor
                                                                    .commonColorSet2,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          22),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: lang == 'en'
                                                                  ? EdgeInsets
                                                                      .zero
                                                                  : EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              13),
                                                              child: Text(
                                                                UtilsHelper
                                                                    .getString(
                                                                        context,
                                                                        'add_balance'),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displaySmall
                                                                    ?.copyWith(
                                                                      fontFamily: lang ==
                                                                              'en'
                                                                          ? 'Helvetica'
                                                                          : 'TheSans',
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: dark(
                                                                              context)
                                                                          ? Colors
                                                                              .white
                                                                          : MyColor
                                                                              .textPrimaryColor,
                                                                    ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            })
                                        : CheckoutTile(
                                            isCreditCard: isCreditCard,
                                            title:
                                                _availablePaymentMethods[index]
                                                    ['title'],
                                            desc:
                                                _availablePaymentMethods[index]
                                                    ['desc'],
                                            isActive: _selectedPaymentMethod ==
                                                    _availablePaymentMethods[
                                                        index]['id']
                                                ? true
                                                : false,
                                            onPress: () {
                                              setState(() {
                                                // _selectedPaymentMethod = index;
                                                _selectedPaymentMethod =
                                                    _availablePaymentMethods[
                                                        index]['id'];
                                                if (_availablePaymentMethods[
                                                        index]['title'] ==
                                                    UtilsHelper.getString(
                                                        context,
                                                        'credit_card')) {
                                                  isCreditCard = !isCreditCard;
                                                }
                                              });
                                            },
                                            lang: lang),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                  ],
                                );
                        },
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    // if (isCreditCard == false)
                    //   Container(
                    //     height: 270,
                    //     child: AddCard(
                    //          isPaying : true,
                    //       callBack: (int selectedCardIndex) {}),
                    //   ),
                    SizedBox(
                      height: 27,
                    ),
                    Container(
                      width: double.infinity,
                      child: commonButton(
                        onPress: () async {
                          String payMethod =
                              getPaymentMethodName(_selectedPaymentMethod);

                          if (payMethod == 'wallet' &&
                              appState.finalTotal >=
                                  appState.myWalletBalance.value) {
                            commonAlertNotification("Error",
                                message: UtilsHelper.getString(context,
                                    "add_amount_in_wallet_instruction"));
                            return;
                          }
                          if (payMethod == 'Razorpay') {
                            openCheckout().then((value) {
                              _handlePaymentSuccess(value);
                            }).onError((error, stackTrace) {
                              // _handlePaymentError();
                              print(error.toString());
                            });
                          } else if (payMethod == 'Stripe') {
                            await StripeService.makePayment(
                                context,
                                CheckOut(
                                  finalAmount: appState.finalTotal,
                                  subtotal: appState.subTotal,
                                  fname: appState.userModel.name,
                                  lname: "",
                                  city: appState.selectedPickupAddress.city ??
                                      "surat",
                                  landmark:
                                      appState.selectedPickupAddress.note ??
                                          "mota vara",
                                  pincode:
                                      appState.selectedPickupAddress.zipcode ??
                                          '394101',
                                  phone: appState.userModel.phone,
                                ),
                                onRedirect: () {}, success: () {
                              con.orderPlaceApi(
                                  context,
                                  payMethod,
                                  setting
                                      .value.timeslots![_selectedTimeSlot].id!);
                            }, failure: (e) {
                              commonAlertNotification("Error!",
                                  message: e.toString());
                            }, cancel: () {
                              commonAlertNotification("Error!",
                                  message: "Payment Cancelled");
                            });
                          } else if (payMethod.toString().toLowerCase() ==
                              'paypal') {
                            if (appState.defaultCurrency == "USD") {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PaypalPayment(
                                    onFinish: (number) async {
                                      print('order id: ' + number);
                                      con.orderPlaceApi(
                                          context,
                                          'Paypal',
                                          setting
                                              .value
                                              .timeslots![_selectedTimeSlot]
                                              .id!);
                                    },
                                    checkOut: CheckOut(
                                      finalAmount: appState.finalTotal,
                                      subtotal: appState.subTotal,
                                      fname: appState.userModel.name,
                                      lname: "",
                                      city:
                                          appState.selectedPickupAddress.city ??
                                              "surat",
                                      landmark:
                                          appState.selectedPickupAddress.note ??
                                              "mota vara",
                                      pincode: appState
                                              .selectedPickupAddress.zipcode ??
                                          '394101',
                                      phone: appState.userModel.phone,
                                    ), // TODO: pass dynamic data
                                  ),
                                ),
                              )
                                  .then((value) {
                                if (value != null) {
                                  //            con.checkOut.paypalId = value[0];
                                  //            con.checkOut.payerId = value[1];
                                  //            con.checkOut.payment = Payment(method: 'PayPal');
                                }
                              });
                            } else {
                              commonAlertNotification("Sorry",
                                  message:
                                      'PayPal not supported ${appState.defaultCurrency} currency');
                            }
                          }
                          // con.payLabPaymentController.payPressed(
                          //     name: appState.userModel.name ?? "",
                          //     email:
                          //         "email@domain.com", // TODO: We need to make it dynamic
                          //     phone: appState.userModel.phone ?? "",
                          //     addressLine:
                          //         appState.selectedPickupAddress.address ??
                          //             "",
                          //     country:
                          //         "US", // TODO: We need to make it dynamic
                          //     // appState.selectedPickupAddress.country ?? "",
                          //     city: appState.selectedPickupAddress.city ?? "",
                          //     state:
                          //         appState.selectedPickupAddress.state ?? "",
                          //     zipCode:
                          //         appState.selectedPickupAddress.zipcode ??
                          //             "",
                          //     amount: decimalValueWithPlaces(
                          //         appState.finalTotal, 2),
                          //     currencyCode: appState.defaultCurrencyCode,
                          //     eventsCallBack: (event) {
                          //       commonAlertNotification("Error",
                          //           message: UtilsHelper.getString(
                          //               context, event['message']));
                          //       if (event["status"] == "success") {
                          //         var transactionDetails = event["data"];
                          //         print(transactionDetails);
                          //       } else if (event["status"] == "error") {
                          //         print(event);
                          //       } else if (event["status"] == "event") {
                          //         print(event);
                          //       }
                          //     });
                          // }
                          else {
                            con.orderPlaceApi(
                                context,
                                payMethod,
                                setting
                                    .value.timeslots![_selectedTimeSlot].id!);
                          }
                        },
                        prefixPath: 'assets/icon_arrow.svg',
                        title: UtilsHelper.getString(context, 'place_order'),
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontFamily:
                                      lang == 'en' ? 'Helvetica' : 'TheSans',
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
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownRow(
      {required String? prefixPath,
      required String? title,
      onPress,
      required isOpen,
      required lang}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      child: GestureDetector(
        // onTap: onPress,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: MyColor.coreBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          //  margin: const EdgeInsets.symmetric(horizontal: 27 ),s
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                decoration: BoxDecoration(
                  color: MyColor.commonColorSet2,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: SvgPicture.asset(
                      prefixPath ?? "",
                      width: 24,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.light
                              ? MyColor.white as Color
                              : MyColor.white as Color,
                          BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title ?? "",
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontFamily:
                                      lang == 'en' ? 'Helvetica' : 'TheSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? MyColor.commonColorSet1
                                      : Colors.white,
                                ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 6),
                      //   child:RotatedBox(
                      //     quarterTurns:isOpen == true ? 1 : 3,
                      //     child:  SvgPicture.asset("assets/icon-chevron.svg",
                      //        width: 14,
                      //         height: 14,
                      //       colorFilter: ColorFilter.mode(
                      //         dark(context) ? Colors.white :MyColor.commonColorSet1 as Color, BlendMode.srcIn)),
                      // )),
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

  String getPaymentMethodName(int selectedPaymentMethod) {
    switch (selectedPaymentMethod) {
      case 23:
        return "cash";
      case 24:
        return "wallet";

      case 0:
        return "Razorpay";
      case 1:
        return "Paypal";
      case 2:
        return "Stripe";
      default:
        return "";
    }
  }
}

class CheckoutTile extends StatelessWidget {
  const CheckoutTile({
    super.key,
    this.isCreditCard = false,
    this.title,
    this.desc,
    this.isActive,
    this.onPress,
    this.lang,
  });

  final bool isCreditCard;
  final String? title;
  final String? desc;
  final bool? isActive;
  final VoidCallback? onPress;
  final String? lang;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 56,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          border: Theme.of(context).brightness == Brightness.light
              ? Border()
              : Border.all(
                  width: 1,
                  color:
                      isActive == false ? Colors.white12 : Colors.transparent),
          color: MyColor.coreBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? (isActive != true
                              ? MyColor.coreBackgroundColor
                              : MyColor.commonColorSet2!.withOpacity(0.2))
                          : (isActive == true
                              ? MyColor.commonColorSet2!.withOpacity(0.2)
                              : MyColor.mainColor),
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: isActive != true
                          ? Colors.black.withOpacity(0.1)
                          : MyColor.commonColorSet2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(title ?? "",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? MyColor.commonColorSet1
                            : MyColor.white)),
              ],
            ),
            if (isCreditCard == true &&
                title == UtilsHelper.getString(context, 'credit_card'))
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                child: SvgPicture.asset(
                  "assets/arrow_down.svg",
                  colorFilter: ColorFilter.mode(
                      isActive == true
                          ? MyColor.white as Color
                          : MyColor.textPrimaryColor as Color,
                      BlendMode.srcIn),
                ),
              ),
            if (isCreditCard == false &&
                title == UtilsHelper.getString(context, 'credit_card'))
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: SvgPicture.asset(
                    "assets/arrow_down.svg",
                  ),
                ),
              ),
            if (title != UtilsHelper.getString(context, 'credit_card'))
              Text(
                desc ?? "",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.light
                          ? MyColor.commonColorSet1
                          : MyColor.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
