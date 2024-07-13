class Urls {
  static String waterUrl =
      "https://stagincite.technofox.co.in/waterapp_1.3_version/";
  // "https://water.fluttertop.com/";

  static String basicUrl = "https://www.mamasmilkfarm.com/api";
  static String imageBaseUrl = "https://www.mamasmilkfarm.com/";
  // 'https://stagincite.technofox.co.in/Waterapp_11_Jan_2024/';
  // static String baseUrl = '${basicUrl}api/';
  // static String baseUrl = "https://gitcsdemoserver.online/mamasmilk/api/";
  static String baseUrl = "https://www.mamasmilkfarm.com/api/";
  static String productImageBaseUrl =
      "${imageBaseUrl}app-assets/images/products/";
  static String bannerImageBaseUrl =
      "${imageBaseUrl}app-assets/images/banners/";
  static String offerImageBaseUrl = "${imageBaseUrl}app-assets/images/coupons/";
  static String settings = baseUrl + 'app-setting';
  static String homeProductList = baseUrl + 'home-product-list';
  static String userLogin = baseUrl + 'user/login';
  static String getSearchedProducts = baseUrl + "search-product";
  static String userVerifyOtp = baseUrl + 'user/verify-otp';
  static String userGetProfile = baseUrl + 'user/get-profile';
  static String userResendOtp = baseUrl + 'user/resend-otp';
  static String userLogout = baseUrl + 'user/logout';
  static String userUpdateNotification = baseUrl + 'user/update-notification';
  static String userUpdateProfile = baseUrl + 'user/update-profile';
  static String offersCouponLists = baseUrl + 'offers/coupon-lists';
  static String offersVerifyCode = baseUrl + 'offers/verify-code';
  static String addressList = baseUrl + 'address/list';
  static String addressAddUpdate = baseUrl + 'address/add-update';
  static String addressDelete = baseUrl + 'address/delete';
  static String cardList = baseUrl + 'card/list';
  static String cardAddUpdate = baseUrl + 'card/add-update';
  static String cardDelete = baseUrl + 'card/delete';
  static String contectUs = baseUrl + 'contect-us';
  static String cartBulkAdd = baseUrl + 'cart/bulk-add';
  static String walletHistory = baseUrl + 'wallet-history';
  static String addWalletAmount = baseUrl + 'add-wallet-amount';
  static String myWalletAmount = baseUrl + 'my-wallet-amount';
  static String orderPlace = baseUrl + 'order/place';
  static String orderLists = baseUrl + 'order/lists';
  static String orderDetail = baseUrl + 'order/detail';
  static String orderCancelRequest = baseUrl + 'order/cancel-request';
  static String keysLists = baseUrl + 'keys-lists';
  static String notification = baseUrl + 'notification';
  static String notificationCount = baseUrl + 'notification/count';
  static String notificationDelete = baseUrl + 'notification/delete';

  static String getImageUrlFromName(String lastName, {bool isBanner = false}) {
    return (isBanner ? bannerImageBaseUrl : productImageBaseUrl) + lastName;
  }

  static String getOfferUrlFromName(String lastName) {
    return offerImageBaseUrl + lastName;
  }
}
