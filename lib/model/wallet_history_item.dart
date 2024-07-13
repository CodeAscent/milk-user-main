class WalletHistoryItem {
  WalletHistoryItem({
    this.id,
    this.userId,
    this.type,
    this.amount,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? type;
  String? amount;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory WalletHistoryItem.fromJson(Map<String, dynamic> json) =>
      WalletHistoryItem(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        amount: json["amount"].toString(),
        description: json["description"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "amount": amount,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  double getAmount() {
    return double.parse(amount!);
  }

  bool isCredit() {
    return "credit"==type;
  }
}
