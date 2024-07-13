
class CheckOut {
  String? apiToken;
  //
  double? subtotal;
  int? isCouponApplied;
  int? orderStatusId;
  int? deliveryAddressId;
  String? couponCode;
  int? promotionalDisount;
  //
  int? deliveryFee;
  String? recipientName;
  String? recipientPhone;
  int? callBeforeDelivery;
  String? deliveryInstruction;
  String? stripeNumber;
  String? stripeExpMonth;
  String? stripeExpYear;
  String? stripeCvc;
  String? hint;
  int? tax;
  int? cardId;
  //
  double? finalAmount;
  Payment? payment;
  List<PaymentProducts>? products;

  // address
  String? city;
  String? pincode;
  String? address;
  String? fname;
  String? lname;
  String? landmark;
  String? phone;
//  EGHLpayment eghLpaymentl;
  String? paypalId;
  String? payerId;
  String? razorPayPaymentId;

  CheckOut(
      {this.apiToken,
        this.subtotal=0.0,
        this.isCouponApplied,
        this.orderStatusId,
        this.deliveryAddressId,
        this.couponCode,
        this.promotionalDisount,
        this.deliveryFee,
        this.recipientName,
        this.recipientPhone,
        this.callBeforeDelivery,
        this.deliveryInstruction,
        this.stripeNumber,
        this.stripeExpMonth,
        this.stripeExpYear,
        this.stripeCvc,
        this.hint,
        this.tax,
        this.cardId,
        this.finalAmount,
        this.payment,
        this.paypalId,
        this.products=const [],
        this.razorPayPaymentId,
        this.city,
        this.pincode,
        this.address,
        this.fname,
        this.lname,
        this.landmark,
        this.phone});

  CheckOut.fromJson(Map<String, dynamic> json) {
    apiToken = json['api_token'];
    subtotal = json['subtotal'];
    isCouponApplied = json['is_coupon_applied'];
    orderStatusId = json['order_status_id'];
    deliveryAddressId = json['delivery_address_id'];
    couponCode = json['coupon_code'];
    promotionalDisount = json['promotional_disount'];
    deliveryFee = json['delivery_fee'];
    recipientName = json['recipient_name'];
    recipientPhone = json['recipient_phone'];
    callBeforeDelivery = json['call_before_delivery'];
    deliveryInstruction = json['delivery_instruction'];
    stripeNumber = json['stripe_number'];
    stripeExpMonth = json['stripe_exp_month'];
    stripeExpYear = json['stripe_exp_year'];
    stripeCvc = json['stripe_cvc'];
    hint = json['hint'];
    tax = json['tax'];
    cardId = json['card_id'];
    finalAmount = json['final_amount'];
//    if (json['eghl_reponse'] != null) {
//      eghLpaymentl = EGHLpayment.fromJson(json['eghl_reponse']);
//    }
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    if (json['products'] != null) {
      products = <PaymentProducts>[];
      json['products'].forEach((v) {
        products!.add(new PaymentProducts.fromJson(v));
      });
    }
    paypalId = json['payment_Id'];
    payerId = json['payer_id'];
    razorPayPaymentId = json['razor_pay_payment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_token'] = apiToken;
    data['subtotal'] = subtotal;
    data['is_coupon_applied'] = isCouponApplied;
    data['order_status_id'] = orderStatusId;
    data['delivery_address_id'] = deliveryAddressId;
    data['coupon_code'] = couponCode;
    data['promotional_disount'] = promotionalDisount;
    data['delivery_fee'] = deliveryFee;
    data['recipient_name'] = recipientName;
    data['recipient_phone'] = recipientPhone;
    data['call_before_delivery'] = callBeforeDelivery;
    data['delivery_instruction'] = deliveryInstruction;
    data['stripe_number'] = stripeNumber;
    data['stripe_exp_month'] = stripeExpMonth;
    data['stripe_exp_year'] = stripeExpYear;
    data['stripe_cvc'] = stripeCvc;
    data['hint'] = hint;
    data['tax'] = tax;
    data['card_id'] = cardId;
    data['final_amount'] = finalAmount;
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['phone'] = this.recipientPhone;
    data['landmark'] = this.landmark;
    data['paypal_id'] = this.paypalId;
    data['payer_id'] = this.payerId;
    /*if (this.eghLpaymentl != null) {
      data['eghl_reponse'] = this.eghLpaymentl.toJson();
    }*/
    data['razor_pay_payment_id'] = this.razorPayPaymentId;
    return data;
  }
}

class Payment {
  String? method;

  Payment({this.method});

  Payment.fromJson(Map<String, dynamic> json) {
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    return data;
  }
}

class PaymentProducts {
  int? productId;
  int? quantity;
  double? price;
  String? name;

  PaymentProducts({this.productId, this.quantity, this.price, this.name});

  PaymentProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['name'] = this.name;
    return data;
  }
}

