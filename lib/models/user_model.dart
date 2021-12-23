import 'dart:convert';

class UserModel {
  UserModel({
    this.id,
    this.bio,
    this.name,
    this.country,
    this.city,
    this.group,
    this.type,
    this.rate,
  });

  final int? id;
  final String? bio;
  final String? name;
  final String? country;
  final String? city;
  final String? group;
  final String? type;
  final String? rate;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    bio: json["bio"],
    name: json["name"],
    country: json["country"],
    city: json["city"],
    group: json["group"],
    type: json["type"],
    rate: json["rate"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "bio": bio,
    "name": name,
    "country": country,
    "city": city,
    "group": group,
    "type": type,
    "rate": rate,
  };
}
