import 'setting_model.dart';

class SettingResponse {
  SettingResponse({
    this.success,
    this.settingData,
    this.message,
  });

  bool? success;
  SettingData? settingData;
  String? message;

  factory SettingResponse.fromJson(Map<String, dynamic> json) => SettingResponse(
    success: json["success"],
    settingData: SettingData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": settingData!.toJson(),
    "message": message,
  };
}




