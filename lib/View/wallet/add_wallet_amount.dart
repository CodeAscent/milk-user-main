import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/View/Checkout/checkout_and_pay.dart';
import 'package:water/View/payments/paypal/paypal_payment.dart';
import 'package:water/View/payments/stripe/stripe_payment.dart';
import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/controllers/wallet_controller.dart';
import 'package:water/model/card_item.dart';
import 'package:water/model/checkout.dart';
import 'package:water/repository/setting_repository.dart';


class AddWalletAmount extends StatefulWidget {

  AddWalletAmount({
     super.key,
     this.finalAmount,
  });

 final double? finalAmount;
  
  @override
  _AddWalletAmountState createState() => _AddWalletAmountState();
}

class _AddWalletAmountState extends StateMVC<AddWalletAmount> {
  int _selectedPaymentMethod=0;

  _AddWalletAmountState() : super(WalletController()) {
    con = controller as WalletController;
  }

  late WalletController con;
  CardItem? selectedCardItem;

  late TextEditingController topUpAmount;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
     topUpAmount = TextEditingController(text: widget.finalAmount != null ? widget.finalAmount.toString() : '');
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }




  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    con.addWalletAmountApi(context, topUpAmount.text.trim());
    commonAlertNotification("Error",message: UtilsHelper.getString(null, "Payment done successfully"));
   
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


  Future openCheckout(double? amount) async {
    var options = {
      'key': setting.value.setting!['razorpay_key'],
      'amount': amount != null ? amount * 100 : appState.finalTotal * 100,
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

  @override
  Widget build(BuildContext context) {
    var lang = appState.currentLanguageCode.value;
    
    List _availablePaymentMethods = [
      if(setting.value.setting!['enable_razorpay'] == "1")
      {
         'id':0,
        "title": UtilsHelper.getString(context, 'Razorpay'), "desc": ""},
      // {"title": UtilsHelper.getString(context, 'Stripe'), "desc": ""},
       if(isPaypal == '1') {
         'id':1,
        "title": UtilsHelper.getString(context, 'paypal'),
         "desc": ""
        } ,
        if(setting.value.setting!['enable_stripe'] == "1")
        {
           'id':2,
          "title" : UtilsHelper.getString(context, 'stripe'),
        },
      // {"title": UtilsHelper.getString(context, 'paylabs'), "desc": ""},
      // {"title": UtilsHelper.getString(context, 'credit_card'), "desc": ""},
    ];
    
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Row(
                      children: [
                        Text(
                          UtilsHelper.getString(context, 'top_up_amount'),
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                                color: MyColor.textSecondarySecondLightColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 27),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:MyColor.coreBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: TextFormField(
                      controller: topUpAmount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       UtilsHelper.getString(context, 'payment_methods'),
                  //       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  //             fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                  //             fontSize: 22,
                  //             color: MyColor.textPrimaryDarkColor,
                  //           ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Container(
                  //   height: 260,
                  //   child: AddCard(
                  //         callBack: (int _selectedCardIndex) {
                  //           selectedCardItem = appState.cardList.value[_selectedCardIndex];
                  //         }
                  //       ),
                  // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Text(
                       UtilsHelper.getString(context, 'payment_method'),
                          style:Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontFamily:lang == 'en' ? 'Helvetica' : 'TheSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness ==
                                    Brightness.light
                                ? MyColor.commonColorSet1
                                : Colors.white,
                          ),
                        ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.symmetric(horizontal: 27),
                        itemCount: _availablePaymentMethods.length,
                        itemBuilder: (context, index) {
                          return  _availablePaymentMethods[index]['title'] == null ?
                           null
                          : Column(
                            children: [
                               ValueListenableBuilder<double>(
                                      valueListenable: appState.myWalletBalance,
                                      builder:
                                          (context, _myWalletBalance, child) {
                                        return 
                                        CheckoutTile(
                                      title: _availablePaymentMethods[index]
                                          ['title'],
                                      desc: _availablePaymentMethods[index]
                                          ['desc'],
                                      isActive: _selectedPaymentMethod == _availablePaymentMethods[index]['id']
                                          ? true
                                          : false,
                                      onPress: () {
                                        setState(() {
                                          _selectedPaymentMethod =  _availablePaymentMethods[index]['id'];
                                          print(_selectedPaymentMethod);
                                          // if (_availablePaymentMethods[index]
                                          //         ['title'] ==
                                          //     UtilsHelper.getString(context, 'credit_card')) {
                                          //   // isCreditCard = !isCreditCard;
                                          // }
                                        });
                                      },
                                      lang: lang,
                                    ); 
                                    })
                              // SizedBox(
                              //   height: 10,
                              // ),
                            ],
                          );
                        },
                      ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:27),
                    child: commonButton(
                      onPress: () async {

                        if(topUpAmount.text.trim().isEmpty) {
                          commonAlertNotification("Error", message: UtilsHelper.getString(context, "enter_amount"));
                          return;
                        } else {
                          
                          String payMethod = getPaymentMethodName(_selectedPaymentMethod);
                          if (payMethod == 'Razorpay') {
                            openCheckout(double.parse(topUpAmount.text.trim())).then((value) {
                              _handlePaymentSuccess(value);
                            
                            }).onError((error, stackTrace) {
                              // _handlePaymentError();
                              print(error.toString());
                            });
                          } else if(payMethod.toString() == 'Stripe'){
                            await StripeService.makePayment(context,
                              CheckOut(
                                finalAmount: appState.finalTotal,
                                subtotal: appState.subTotal,
                                fname: appState.userModel.name,
                                lname: "",
                                phone: appState.userModel.phone,
                              ),
                             onRedirect :(){
                               
                             },
                             success :(){
                               con.addWalletAmountApi(context,
                                topUpAmount.text.trim(),
                                method:payMethod);
                             },
                             failure :(e){
                                commonAlertNotification("Error!",message: e.toString());
                             },
                             cancel :(){
                                commonAlertNotification("Error!",message: "Payment Cancelled");
                             }
                             );
                          }
                          else if(payMethod.toString().toLowerCase() == 'Paypal'){
                            if(appState.defaultCurrency == "USD"){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => PaypalPayment(
                                    onFinish: (number) async {
                                      print('order id: ' + number);
                                      con.addWalletAmountApi(context, topUpAmount.text.trim());
                                    },
                                    checkOut: CheckOut(
                                        finalAmount: appState.finalTotal,
                                        subtotal: appState.subTotal,
                                        fname: appState.userModel.name,
                                        lname: "",
                                        city:  appState.selectedPickupAddress.city ?? "surat",
                                        landmark: appState.selectedPickupAddress.note ?? "mota vara",
                                        pincode: appState.selectedPickupAddress.zipcode ?? '394101',
                                        phone: appState.userModel.phone,
                                      ), // TODO: pass dynamic data
                                  ),
                                ),
                              ) .then((value) {
                                  if (value != null) {
                      //            con.checkOut.paypalId = value[0];
                      //            con.checkOut.payerId = value[1];
                      //            con.checkOut.payment = Payment(method: 'PayPal');
                                    con.addWalletAmountApi(context, topUpAmount.text.trim());
                                  }
                                });
                              
                            } else {
                                commonAlertNotification("Sorry",message:'PayPal not supported ${appState.defaultCurrency} currency');
                            }
                          } 
                        }
                        },
                      prefixPath: 'assets/icon_arrow.svg',
                      title: UtilsHelper.getString(context, 'add_balance'),
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: !UtilsHelper.rightHandLang.contains(lang) ? UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                            color: MyColor.textPrimaryLightColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                      color: MyColor.commonColorSet2,
                    ),
                  ),
                  SizedBox(
                    height: 27,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  String getPaymentMethodName(int selectedPaymentMethod) {
    switch (selectedPaymentMethod) {
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
