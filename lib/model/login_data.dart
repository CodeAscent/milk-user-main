
class LoginData {
  LoginData({
    this.id,
    this.phone,
    this.otp,
    this.isVerified,
  });

  int? id;
  String? phone;
  int? otp;
  int? isVerified;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    id: json["id"],
    phone: json["phone"],
    otp: json["otp"],
    isVerified: json["is_verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "otp": otp,
    "is_verified": isVerified,
  };
}
