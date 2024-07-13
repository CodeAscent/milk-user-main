class LanguageItem {
  LanguageItem({
    this.id,
    this.languageName,
    this.languageCode,
    this.createdAt,
    this.updatedAt,
    this.langDir,
  });

  int? id;
  String? languageName;
  String? languageCode;
  String? langDir;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory LanguageItem.fromJson(Map<String, dynamic> json) => LanguageItem(
    id: json["id"],
    languageName: json["language_name"],
    languageCode: json["language_code"],
    langDir : json['language_direction'],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language_name": languageName,
    "language_code": languageCode,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}