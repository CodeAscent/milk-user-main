class VerifyOTPData {
  VerifyOTPData({
    this.userId,
    this.apiToken,
    this.deviceToken,
    this.deviceType,
    this.createdAt,
  });

  int? userId;
  String? apiToken;
  String? deviceToken;
  String? deviceType;
  String? createdAt;

  factory VerifyOTPData.fromJson(Map<String, dynamic> json) => VerifyOTPData(
    userId: json["user_id"],
    apiToken: json["api_token"],
    deviceToken: json["player_id"],
    deviceType: json["device_type"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "api_token": apiToken,
    "device_token": deviceToken,
    "device_type": deviceType,
    "created_at": createdAt,
  };
}
