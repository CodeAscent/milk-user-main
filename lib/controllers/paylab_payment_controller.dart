// import 'dart:io';

// import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
// import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
// import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
// import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:water/Utils/local_data/app_state.dart';
// import 'package:water/Utils/project_keys.dart';

// class PayLabPaymentController {
//   PaymentSdkConfigurationDetails _generateConfig(
//       {required String name,
//       required String email,
//       required String phone,
//       required String addressLine,
//       required String country,
//       required String city,
//       required String state,
//       required String zipCode,
//       required double amount,
//       required String currencyCode}) {
//     var billingDetails = new BillingDetails(
//         name, email, phone, addressLine, country, city, state, zipCode);
//     var shippingDetails = new ShippingDetails(
//         name, email, phone, addressLine, country, city, state, zipCode);

//     List<PaymentSdkAPms> apms = [];
//     apms.add(PaymentSdkAPms.STC_PAY);

//     var configuration = PaymentSdkConfigurationDetails(
//       profileId: ProjectKeys.payTabsProfileId,
//       serverKey: ProjectKeys.payTabsServerKey,
//       clientKey: ProjectKeys.payTabsClientKey,
//       cartId: "1234",
//       cartDescription: "water",
//       merchantName: ProjectKeys.payTabsMerchantName,
//       screentTitle: ProjectKeys.payTabsScreenTitle,
//       billingDetails: billingDetails,
//       shippingDetails: shippingDetails,
//       amount: amount,
//       currencyCode: currencyCode, //i.e SAR
//       alternativePaymentMethods: apms,
//       merchantCountryCode: ProjectKeys.payTabsMerchantCountryCode,
//     );
//     if (Platform.isIOS) {
//       // Set up here your custom theme
//       // var theme = IOSThemeConfigurations();
//       // configuration.iOSThemeConfigurations = theme;
//     }
//     return configuration;
//   }

//   Future<void> payPressed(
//       {required String name,
//       required String email,
//       required String phone,
//       required String addressLine,
//       required String country,
//       required String city,
//       required String state,
//       required String zipCode,
//       required double amount,
//       required String currencyCode,
//       required void eventsCallBack(dynamic)}) async {
//     FlutterPaytabsBridge.startCardPayment(
//         _generateConfig(
//             name: name,
//             email: email,
//             phone: phone,
//             addressLine: addressLine,
//             country: country,
//             city: city,
//             state: state,
//             zipCode: zipCode,
//             amount: amount,
//             currencyCode: currencyCode), eventsCallBack);
//   }
// }
