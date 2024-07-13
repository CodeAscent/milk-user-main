import 'dart:core';
import 'package:flutter/material.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/View/payments/paypal/paypal_services.dart';
import 'package:water/model/checkout.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaypalPayment extends StatefulWidget {
  final Function? onFinish;
  final CheckOut? checkOut;
  PaypalPayment({this.onFinish, this.checkOut});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> dCurrency = {
    "symbol":appState.defaultCurrencyCode,
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": appState.defaultCurrency
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    print(
        "---------------------defaultCurrencyName defaultCurrency --------------------");
    Future.delayed(Duration.zero, () async {
      // try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res = await services.createPaypalPayment(transactions, accessToken);
        print(res);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      // } catch (e) {
      //   print('exception: ' + e.toString());
      //   final snackBar = SnackBar(
      //     content: Text(e.toString()),
      //     duration: Duration(seconds: 10),
      //     action: SnackBarAction(
      //       label: 'Close',
      //       onPressed: () {
      //         // Some code to undo the change.
      //       },
      //     ),
      //   );
      //   _scaffoldKey.currentState.showSnackBar(snackBar);
      // }
    });
     // #docregion platform_features
  }

  Map<String, dynamic> getOrderParams() {
    List items = [
      ...widget.checkOut!.products
          !.map((e) => {
        "name": e.name,
        "quantity": e.quantity,
        "price": e.price,
        "currency": dCurrency["currency"]
      })
          .toList()
    ];

    // checkout invoice details
    String totalAmount = widget.checkOut?.finalAmount?.toString()??"0.0";
    // String shippingCost = ((widget?.checkOut?.finalAmount??0.0) - (widget?.checkOut?.subtotal??0.0)).toString();
    String shippingCost = "0.0";
    int shippingDiscountCost = 0; //widget.checkOut.finalAmount - widget.checkOut.subtotal;
    String userFirstName = widget.checkOut!.fname ?? '';
    String userLastName = widget.checkOut!.lname ?? '';
    String addressCity = widget.checkOut!.city!;
    String addressStreet = widget.checkOut!.landmark!;
    String addressZipCode = widget.checkOut!.pincode!;
    String addressCountry = "";
    String addressState = '';
    String addressPhoneNumber = widget.checkOut!.recipientPhone!;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": dCurrency["currency"],
            "details": {
              "subtotal": totalAmount,
              "shipping": shippingCost,
              "shipping_discount": shippingDiscountCost.toString()
              // "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  // String itemName = 'iPhone X';
  // String itemPrice = '1.99';
  // int quantity = 1;
  // Map<dynamic,dynamic> defaultCurrency = {"symbol": "USD ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "USD"};
  // Map<String, dynamic> getOrderParams() {
  //   List items = [
  //     {
  //       "name": itemName,
  //       "quantity": quantity,
  //       "price": itemPrice,
  //       "currency": defaultCurrency["currency"]
  //     }
  //   ];
  //
  //
  //   // checkout invoice details
  //   String totalAmount = '1.99';
  //   String subTotalAmount = '1.99';
  //   String shippingCost = '0';
  //   int shippingDiscountCost = 0;
  //   String userFirstName = 'Gulshan';
  //   String userLastName = 'Yadav';
  //   String addressCity = 'Delhi';
  //   String addressStreet = 'Mathura Road';
  //   String addressZipCode = '110014';
  //   String addressCountry = 'India';
  //   String addressState = 'Delhi';
  //   String addressPhoneNumber = '+919990119091';
  //
  //   Map<String, dynamic> temp = {
  //     "intent": "sale",
  //     "payer": {"payment_method": "paypal"},
  //     "transactions": [
  //       {
  //         "amount": {
  //           "total": totalAmount,
  //           "currency": defaultCurrency["currency"],
  //           "details": {
  //             "subtotal": subTotalAmount,
  //             "shipping": shippingCost,
  //             "shipping_discount":
  //             ((-1.0) * shippingDiscountCost).toString()
  //           }
  //         },
  //         "description": "The payment transaction description.",
  //         "payment_options": {
  //           "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
  //         },
  //         "item_list": {
  //           "items": items,
  //           if (isEnableShipping &&
  //               isEnableAddress)
  //             "shipping_address": {
  //               "recipient_name": userFirstName +
  //                   " " +
  //                   userLastName,
  //               "line1": addressStreet,
  //               "line2": "",
  //               "city": addressCity,
  //               "country_code": addressCountry,
  //               "postal_code": addressZipCode,
  //               "phone": addressPhoneNumber,
  //               "state": addressState
  //             },
  //         }
  //       }
  //     ],
  //     "note_to_payer": "Contact us for any questions on your order.",
  //     "redirect_urls": {
  //       "return_url": returnURL,
  //       "cancel_url": cancelURL
  //     }
  //   };
  //   return temp;
  // }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
           initialUrl: checkoutUrl.toString(),
           javascriptChannels: {
            JavascriptChannel(name: 'Toaster',
            onMessageReceived:   (JavascriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
            })
           },
           backgroundColor: const Color(0x00000000),
          navigationDelegate:  (request) async {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                await services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish!(id);
                  Navigator.of(context).pop([id, payerID]);
                  return;
                });
              } else {
                print("2 Pop");

                Navigator.of(context).pop();
              }
              print("3 Pop");

              // Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              print("4 Pop");

              Navigator.of(context).pop();
            }
            print("5 Pop");
            return NavigationDecision.navigate;
          
        }
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
