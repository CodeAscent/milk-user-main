
class UserModel {
  UserModel({
    this.id,
    this.type,
    this.name,
    this.image,
    this.langCode,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.isVerified,
    this.enableNotificaton,
    this.otp,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.apiToken,
  });

  int? id;
  String? type;
  String? name;
  String? image;
  String? langCode;
  dynamic? email;
  String? phone;
  dynamic? emailVerifiedAt;
  int? isVerified;
  int? enableNotificaton;
  int? otp;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? apiToken;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    image: json["image"],
    langCode: json["lang_code"],
    email: json["email"],
    phone: json["phone"],
    emailVerifiedAt: json["email_verified_at"],
    isVerified: json["is_verified"],
    enableNotificaton: json["enable_notificaton"],
    otp: json["otp"],
    status: json["status"],
    createdAt: json["created_at"]!=null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"]!=null ? DateTime.parse(json["updated_at"]) : null,
    apiToken: json["api_token"]!=null ? json["api_token"] : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "image": image,
    "lang_code": langCode,
    "email": email,
    "phone": phone,
    "email_verified_at": emailVerifiedAt,
    "is_verified": isVerified,
    "enable_notificaton": enableNotificaton,
    "otp": otp,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "api_token": apiToken,
  };
}
