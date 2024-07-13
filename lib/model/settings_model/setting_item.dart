
class SettingItem {
  SettingItem({
    this.id,
    this.key,
    this.value,
  });

  int? id;
  String? key;
  String? value;

  factory SettingItem.fromJson(Map<String, dynamic> json) => SettingItem(
    id: json["id"],
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "value": value,
  };
}