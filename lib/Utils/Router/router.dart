import 'package:flutter/material.dart';
import 'package:water/Utils/loader.dart';
import 'package:water/View/Checkout/checkout.dart';
import 'package:water/View/Checkout/checkout_and_pay.dart';
import 'package:water/View/Home/home_screen.dart';
import 'package:water/View/Map/pick_address.dart';
import 'package:water/View/Offers/offers.dart';
import 'package:water/View/Order/order_placed.dart';
import 'package:water/View/Order/track_order.dart';
import 'package:water/View/Order/your_orders.dart';
import 'package:water/View/Setting/Reach_us.dart';
import 'package:water/View/Setting/setting.dart';
import 'package:water/View/SignIn_SignUp/enter_otp.dart';
import 'package:water/View/SignIn_SignUp/sign_in.dart';
import 'package:water/View/SignIn_SignUp/sign_up.dart';
import 'package:water/View/Splash/Splash.dart';
import 'package:water/View/User/acount.dart';
import 'package:water/View/about/about_us.dart';
import 'package:water/View/notification.dart';
import 'package:water/View/order/order_detail.dart';
import 'package:water/View/product_detail.dart';
import 'package:water/View/search.dart';
import 'package:water/View/select_language.dart';
import 'package:water/View/term_and_condition/term_and_condition.dart';
import 'package:water/View/wallet/add_wallet_amount.dart';
import 'package:water/View/wallet/wallet_screen.dart';
import 'package:water/model/product/product.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic args = settings.arguments;

    switch (settings.name) {
      case '/splash_screen':
        return MaterialPageRoute(
          builder: (context) {
            return SplashScreen();
          },
        );
      case '/select_language':
        return MaterialPageRoute(
          builder: (context) {
            return SelectLanguage();
          },
        );
      case '/sign_in':
        return MaterialPageRoute(
          builder: (context) {
            return SignIn();
          },
        );
      case '/enter_otp':
        return MaterialPageRoute(
          builder: (context) {
            return EnterOtp(
              phone:args.length == 2 ? args[1] : args[0],
              verificationId: args.length == 2 ? args[0] : null,
            );
          },
        );
      case '/sign_up':
        return MaterialPageRoute(
          builder: (context) {
            return SignUp();
          },
        );
      case '/home_screen':
        return MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        );
      case '/order_detail':
        return MaterialPageRoute(
          builder: (context) {
            return OrderDetail();
          },
        );
      case '/checkout':
        return MaterialPageRoute(
          builder: (context) {
            return Checkout();
          },
        );
      case '/pick_address':
        return MaterialPageRoute(
          builder: (context) {
            return PickAddress();
          },
        );
      case '/checkout_pay':
        return MaterialPageRoute(
          builder: (context) {
            return CheckoutAndPay();
          },
        );
      case '/setting':
        return MaterialPageRoute(
          builder: (context) {
            return Settings();
          },
        );
      case '/about_us':
        return MaterialPageRoute(
          builder: (context) {
            return AboutUs();
          },
        );
      case '/offers':
        return MaterialPageRoute(
          builder: (context) {
            return Offers();
          },
        );
      case '/your_orders':
        return MaterialPageRoute(
          builder: (context) {
            return YourOrders();
          },
        );
      case '/my_account':
        return MaterialPageRoute(
          builder: (context) {
            return MyAccount();
          },
        );
      case '/track_order':
        return MaterialPageRoute(
          builder: (context) {
            return TrackOrder(orderId: args);
          },
        );
      case '/order_placed':
        return MaterialPageRoute(
          builder: (context) {
            return OrderPlaced(orderNumber: args);
          },
        );
      case '/term_and_condition':
        return MaterialPageRoute(
          builder: (context) {
            return TermAndCondition();
          },
        );
        case '/reach_us':
        return MaterialPageRoute(
          builder: (context) {
            return ReachUs();
          },
        );
      case '/wallet_screen':
        return MaterialPageRoute(
          builder: (context) {
            return WalletScreen();
          },
        );
       case '/product_detail':
        return MaterialPageRoute(
          builder: (context) {
            return ProductDetail(product: args as Product);
          },
        );
       case '/search_page':
        return MaterialPageRoute(
          builder: (context) {
            return MySearchPage();
          },
        );
      case '/add_wallet_amount':
        return MaterialPageRoute(
          builder: (context) {
            return AddWalletAmount(finalAmount: args);
          },
        );
      case '/notification':
        return MaterialPageRoute(
          builder: (context) {
            return NotificationScreen();
          },
        );
      default: {

        if(settings.name != null && (settings.name!.contains('/product/'))){
      
        var id  = int.parse(settings.name!.split('/').last);

        return MaterialPageRoute(
          builder: (context) {
           return Loader(product: Product(id: int.parse(id.toString())));});
     
       } else {

         return MaterialPageRoute(
          builder: (context) {
           return const SplashScreen();
        });
       
       }
      }
     
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('Error'),
          ),
        );
      },
    );
  }
}
