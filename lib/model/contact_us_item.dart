class ContactItem {
  ContactItem({
    this.name,
    this.email,
    this.mobile,
    this.message,
  });

  String? name;
  String? email;
  String? mobile;
  String? message;

  factory ContactItem.fromJson(Map<String, dynamic> json) => ContactItem(
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "mobile": mobile,
    "message": message,
  };
}
