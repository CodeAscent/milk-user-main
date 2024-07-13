
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/model/checkout.dart';
import 'package:water/repository/setting_repository.dart';


Map? paymentIntent;

class StripeService {

static Future<dynamic> makePayment(
  BuildContext context,
  CheckOut productItems,{
   required dynamic Function() onRedirect,
   required dynamic Function() success,
   required dynamic Function(Object) failure,
   required dynamic Function() cancel
  }) async {
    try {
      //STEP 1: Create Payment Intent
     var sessionId = await createPaymentIntent(productItems);
      
      await redirectToCheckout(
         context: context,
         sessionId: sessionId.toString(), 
         publishableKey: setting.value.setting!['stripe_key'],
         successUrl: "https://checkout.stripe.dev/success",
         canceledUrl: "https://checkout.stripe.dev/cancel",
        ).then((value) {
          value.when(
            redirected:onRedirect, 
            success: success, 
            canceled: cancel, 
            error: failure);
        });

    } catch (err) {
      throw Exception(err);
    }
  }


//  Future<dynamic> displayPaymentSheet(BuildContext context) async {
//     try {
    //   await Stripe.presentPaymentSheet().then((value) {
    //     showDialog(
    //         context: context,
    //         builder: (_) => AlertDialog(
    //               content: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: const [
    //                    Icon(
    //                     Icons.check_circle,
    //                     color: Colors.green,
    //                     size: 100.0,
    //                   ),
    //                   SizedBox(height: 10.0),
    //                   Text("Payment Successful!"),
    //                 ],
    //               ),
    //             ));

    //     paymentIntent = null;
    //   }).onError((error, stackTrace) {
    //     throw Exception(error);
    //   });
    // } on Exception catch (e) {
    //   print('Error is:---> $e');
    //   AlertDialog(
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           children: const [
    //             Icon(
    //               Icons.cancel,
    //               color: Colors.red,
    //             ),
    //             Text("Payment Failed"),
    //           ],
    //         ),
    //       ],
    //     ),
    //   );
    // } catch (e) {
    //   print('$e');
    // }
  // }
  

  static presentPaymentSheet() {
     launchUrl(Uri.parse('https://buy.stripe.com/test_28o1861Vlfc5gpi5kk'));
  }
  
  // createPaymentIntent(String s, String t) {
 static Future<String?> createPaymentIntent(CheckOut payments) async {
    try {
      
      String items ="";
      int index=0;

      items += "&line_items[$index][price_data][product_data][name]=${payments.fname.toString()}";
      items += "&line_items[$index][price_data][unit_amount]=${(payments.finalAmount! * 100).round().toString()}";
      items += "&line_items[$index][price_data][currency]=${appState.defaultCurrencyCode}";
      items += "&line_items[$index][quantity]=1";
    
      //Make post request to Stripe

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/checkout/sessions'),
        headers: {
          'Authorization': 'Bearer ${setting.value.setting!['stripe_secret_key']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "success_url=https://checkout.stripe.dev/success&mode=payment$items"
        // "custom_text=address['shipping_address']",
      );
      print(response.body);
      return json.decode(response.body)['id'];
    } catch (err) {
      print(err);
      throw Exception(err.toString());
    }
  }
  
  calculateAmount(String amount) {
    return double.parse(amount)  * 100;
  }

}
