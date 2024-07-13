class CardItem {
  CardItem({
    this.id = 0,
    this.userId,
    this.cardNo,
    this.cardHolderName,
    this.month,
    this.year,
    this.cvv,
    this.setAsDefault = 0,
    this.createdAt,
    this.updatedAt,
  });

  int? id = 0;
  int? userId;
  String? cardNo;
  String? cardHolderName;
  String? month;
  int? year;
  int? cvv;
  int? setAsDefault = 0;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CardItem.fromJson(Map<String, dynamic> json) => CardItem(
        id: json["id"],
        userId: json["user_id"],
        cardNo: json["card_no"],
        cardHolderName: json["card_holder_name"],
        month: json["month"],
        year: json["year"],
        cvv: json["cvv"],
        setAsDefault: json["set_as_default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "card_no": cardNo,
        "card_holder_name": cardHolderName,
        "month": month,
        "year": year,
        "cvv": cvv,
        "set_as_default": setAsDefault,
      };

  Map<String, dynamic> toWalletJson() => {
        "card_no": cardNo,
        "card_holder_name": cardHolderName,
        "month": month,
        "year": year,
        "cvv": cvv,
        "set_as_default": setAsDefault,
      };
}
