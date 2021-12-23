import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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
    this.geo,
    this.timestamp,
  });

  final String? id;
  final String? bio;
  final String? name;
  final String? country;
  final String? city;
  final String? group;
  final String? type;
  final String? rate;
  final GeoPoint? geo;
  final Timestamp? timestamp;

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
    geo: json["geo"],
    timestamp: json["timestamp"],
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
    "geo": geo,
    "timestamp": timestamp,
  };
}
