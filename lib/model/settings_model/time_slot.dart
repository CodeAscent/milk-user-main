import 'package:flutter/material.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/display_format.dart';

class Timeslot {
  Timeslot({
    this.id,
    this.name,
    this.fromTime,
    this.toTime,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? fromTime;
  String? toTime;
  int? status;
  DateTime? createdAt;
  dynamic updatedAt;

  factory Timeslot.fromJson(Map<String, dynamic> json) => Timeslot(
    id: json["id"],
    name: json["name"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "from_time": fromTime,
    "to_time": toTime,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt,
  };

  getDisplayStr(BuildContext context) {
    if(this.fromTime==null||this.toTime==null) {
      return "-";
    }
    List<String> fromTimeStr = this.fromTime!.split(":");
    TimeOfDay fromTime = TimeOfDay(hour: int.parse(fromTimeStr[0]), minute: int.parse(fromTimeStr[1]));

    List<String> toTimeStr = this.toTime!.split(":");
    TimeOfDay toTime = TimeOfDay(hour: int.parse(toTimeStr[0]), minute: int.parse(toTimeStr[1]));

    return UtilsHelper.getString(context, name!) + " (" + fromTime.format(context) + "-" + toTime.format(context) + ")";
  }
}