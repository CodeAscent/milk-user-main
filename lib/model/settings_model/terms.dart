class Terms {
  Terms({
    this.id,
    this.pageName,
    this.pageTitle,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? pageName;
  String? pageTitle;
  String? description;
  dynamic createdAt;
  DateTime? updatedAt;

  factory Terms.fromJson(Map<String, dynamic> json) => Terms(
    id: json["id"],
    pageName: json["page_name"],
    pageTitle: json["page_title"],
    description: json["description"],
    createdAt: json["created_at"],
  //  updatedAt:json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "page_name": pageName,
    "page_title": pageTitle,
    "description": description,
    "created_at": createdAt,
   // "updated_at": updatedAt!.toIso8601String(),
  };
}