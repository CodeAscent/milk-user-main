import 'package:flutter/material.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/local_data/local_data_storage.dart';
import 'package:water/model/order/order.dart';
import 'package:water/repository/order_repository.dart';

import 'wallet_controller.dart';

class OrderController extends WalletController {
  LocalDataStorage localDataStorage = LocalDataStorage();
//  PayLabPaymentController payLabPaymentController = PayLabPaymentController();
  List<OrderListItem>? orderListItems;
  OrderListItem? orderListItem;

  void orderPlaceApi(BuildContext context, String method, int timeSlot) async {
    showLoader();
    Map<String, dynamic> _map = {
      "payment": {
        "method": method
      },
      "order_status_id": 1, ///it's always 1
      "delivery_address_id": appState.selectedPickupAddress.id,
      "coupon_code": appState.offerItem==null ? "" : appState.offerItem!.couponName,
      "is_coupon_applied": appState.offerItem==null ? 0 : 1,
      "promotional_disount": appState.offerItem==null ? 0.0 : appState.offerItem!.discountPrice, //TODO: discount calculate from coupon
      "subtotal" : appState.subTotal,
      "tax": appState.defaultTax, // Tax %//TODO: improve calculation
      "delivery_fee": appState.shippingCharge,
      "final_amount": appState.finalTotal,// Final Amount == Sub Total + Dliver + Tax - Discount
      "timeslot_id" : timeSlot
    };

   await orderPlace(_map).then((value) {
      if (value.success!) {
        appState.carts.value = [];
        localDataStorage.deleteDataBase();
        commonAlertNotification("Success", message: UtilsHelper.getString(context, "order_place_successfully"));
        Navigator.of(context)
            .pushReplacementNamed(RoutePath.order_placed, arguments: value.data['id'].toString());
      } else {
        commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
      }
    }).catchError((e) {
      hideLoader();
      print(e.toString());
      commonAlertNotification("Error", message: UtilsHelper.getString(context, "something_went_wrong"));
    }).whenComplete(() {
      hideLoader();
    });
  }

  void getOrderListApi() async {
    getOrderList().then((value) {
    if (value.data != null) {
        orderListItems =
      List<OrderListItem>.from(value.data.map((x) => OrderListItem.fromJson(x)));
    }
      setState(() {});
    })
    //     .catchError((e) {
    //   print(e.toString());
    //     commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    // })
        .whenComplete(() {});
  }

  void getOrderDetailApi(int productId, {bool isHideLoader=false}) async {
    getOrderDetail(productId).then((value) {
      orderListItem = OrderListItem.fromJson(value.data);
      setState(() {});
    }).catchError((e) {
        commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      if(isHideLoader) {
        hideLoader();
      }
    });
  }

  void orderCancelRequestApi(int orderId) async {
    showLoader();
    orderCancelRequest(orderId).then((value) {
      // orderListItem = OrderListItem.fromJson(value.data);
      setState(() {});
    }).catchError((e) {
        commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {
      getOrderDetailApi(orderId, isHideLoader: true);
    });
  }

}