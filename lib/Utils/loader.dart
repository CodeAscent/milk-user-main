
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/View/Home/home_screen.dart';
import 'package:water/View/SignIn_SignUp/sign_in.dart';
import 'package:water/main.dart';
import "package:http/http.dart" as http;
import 'package:water/model/order/order_list_item.dart';

import '../model/product/product_item.dart';


enum ProductAction{ share }

class Loader extends StatefulWidget {
  const Loader({super.key, this.product,this.action,this.type,this.order});
  final String? action;
  final Product? product;
  final OrderListItem? order;
  final String? type;
  

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {

late Product product;
  
@override
 void initState(){
  product = widget.product as Product;

   WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
   // print(product.id.toString());
    //var provider = Provider.of<AppProvider>(context,listen:false);
     if (!get.hasData("current_user")) { 
         
         Navigator.push(context, 
         MaterialPageRoute(builder: (context) => const SignIn()));

    } else { 
      
      if (widget.type == 'order') {
      
       if (get.hasData('id')) {
        if (appState.userModel.id==null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
          const SignIn()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
          const HomeScreen()));
        }
      } 

    } else {
     
      await productDetail(widget.product!.id.toString()).then((value) async {

      if (get.hasData('id')) {
         get.remove('id');
        // if (appState.userModel.id==null) {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => 
        //   const SignIn()));
        // } else {
          Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => const HomeScreen()));

          await activeState(value);
     //   }
       } else{
          print(value.toJson());
         await inActiveState(value);
       }

     });
    }
    }
 });
 super.initState();
 }

Future activeState(Product value) async {
  if (widget.type == "order") {
     Navigator.of(context).pushNamed(RoutePath.track_order,arguments: widget.order!.id);
  } else {
    Navigator.pushNamed(context, '/product_detail',arguments: product);
  }
}

Future inActiveState(Product value) async {
  if (widget.type == "order") {
     Navigator.of(context).pushNamed(RoutePath.track_order,arguments: widget.order!.id);
  } else {
    Navigator.pushReplacementNamed(context, '/product_detail',arguments: value);
  }
}


  @override
  Widget build(BuildContext context) {
    return  Opacity(
       opacity: 0.7,
       child: Material(
        surfaceTintColor: Colors.transparent,
        color: dark(context) ? Colors.transparent :Colors.white54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            ClipRRect(borderRadius: BorderRadius.circular(12),
              child: Container(
                color: dark(context) ?Colors.transparent :Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                child: Image.asset("assets/appicon.jpg",width: 120,height: 120)),
            ),
            SizedBox(height:24),
            CircularProgressIndicator(
              color: !dark(context) ? MyColor.darkYellow :MyColor.white,
            )
          ]
        )
       ),
    );
  }
}

  Future<Product> productDetail(String id)async {

    var url = "${Urls.baseUrl}product-details/$id";
    var result = await http.get(
      Uri.parse(url),
    );
    Map data = await json.decode(result.body);
    final list = Product.fromJson(data['data']);
  
    return list;
    
  }