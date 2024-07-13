class AddressItem {
  AddressItem({
    this.id,
    this.type,
    this.address,
    this.googleAddress,
    this.note,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? type;
  String? address;
  String? googleAddress;
  String? note;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? latitude;
  String? longitude;
  int? isDefault;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AddressItem.fromJson(Map<String, dynamic> json) => AddressItem(
        id: json["id"],
        type: json["type"],
        address: json["address"],
        googleAddress: json["google_address"],
        note: json["note"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        zipcode: json["zipcode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isDefault: json["is_default"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "address": address,
        "google_address": googleAddress,
        "note": note,
        "city": city,
        "state": state,
        "country": country,
        "zipcode": zipcode,
        "latitude": latitude,
        "longitude": longitude,
        "is_default": isDefault,
//    "user_id": userId,
//    "created_at": createdAt?.toIso8601String(),
//    "updated_at": updatedAt?.toIso8601String(),
      };

  getFormattedAddress() {
    List<String> _addressItems = [];
    if (googleAddress?.isNotEmpty ?? false) {
      _addressItems.add(googleAddress!);
    }
    // if (city != null && (city?.isNotEmpty ?? false)) {
    //   _addressItems.add(city!);
    // }
    // if (state != null && (state?.isNotEmpty ?? false)) {
    //   _addressItems.add(state!);
    // }
    // if (country != null && (country?.isNotEmpty ?? false)) {
    //   _addressItems.add(country!);
    // }
    return _addressItems.join(", ");
  }
}
