import 'package:flutter/material.dart';
import 'package:water/model/address_item.dart';
import 'package:water/model/card_item.dart';
import 'package:water/model/offer_item.dart';
import 'package:water/model/product/product.dart';
import 'package:water/model/settings_model/language_item.dart';
import 'package:water/model/user_model.dart';
import 'package:water/model/wallet_history_item.dart';

import 'local_data_storage.dart';

AppState appState = AppState();

class AppState {
  static final AppState _singleton = AppState._internal();

  factory AppState() {
    return _singleton;
  }

  AppState._internal();

  LocalDataStorage localDataStorage = LocalDataStorage();

  late LanguageItem languageItem = LanguageItem(languageCode: 'en',languageName: 'English');
  late String defaultCurrency;
  late String defaultCurrencyCode;
  late int defaultCurrencyDecimalDigits;
  late String currencyRight;
  double defaultTax = 0;
  double minimumOrderValue = 0;
  double shippingCharge = 0;
  late String deviceTokenId="";
  late String apiToken= "";
  late UserModel userModel = UserModel();
  late AddressItem selectedPickupAddress;
  ValueNotifier<double> myWalletBalance = ValueNotifier(0.0);
  ValueNotifier<List<WalletHistoryItem>> walletHistoryItemList = ValueNotifier([]);
  ValueNotifier<List<Product>> carts = ValueNotifier([]);
  ValueNotifier<List<AddressItem>> pickupAddressList = ValueNotifier([]);
  ValueNotifier<List<CardItem>> cardList = ValueNotifier([]);
  ValueNotifier<String> currentLanguageCode = ValueNotifier("en");
  Map<String, dynamic> languageKeys = Map<String, dynamic>();

  double subTotal = 0;
  double finalTotal = 0;
  double vat = 0;
  double delivery = 0;
  OfferItem? offerItem;

  void addNewProductQuantity(Product product,int selectedQuatity) {
    product.quantity=selectedQuatity;
    carts.value.add(product);
    localDataStorage.insertProduct(product);
    carts.notifyListeners();
  }

  void decreaseProduct(Product product) {
    carts.value.forEach((element) {
      if(element.id==product.id) {
        element.quantity=element.quantity-1;
      }
    });
    carts.notifyListeners();
    localDataStorage.updateProduct(product, product.id!);
    print(carts.value);
  }

 void bulkIncreaseProduct(Product product,int qty) {
    carts.value.forEach((element) {
      if(element.id==product.id) {
        element.quantity=qty;
      }
    });
    carts.notifyListeners();
    localDataStorage.updateProduct(product, product.id!);
    print(carts.value);
  }

  void increaseProduct(Product product) {
    carts.value.forEach((element) {
      if(element.id==product.id) {
        element.quantity=element.quantity+1;
      }
    });
    carts.notifyListeners();
    localDataStorage.updateProduct(product, product.id!);
    print(carts.value);
  }

  void removeProductFromCart(Product product, {int? selectedQuatity}) {
    print("Cart Length before Delete ${carts.value.length}");
    carts.value.remove(product);
    print("Cart Length after Delete ${carts.value.length}");

    carts.notifyListeners();
    localDataStorage.deleteProduct(product.id!);
  }
}