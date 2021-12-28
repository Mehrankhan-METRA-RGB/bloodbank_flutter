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
    this.price,
    this.geo,
    this.timestamp,
    this.isAvailableForDonation,
    this.lastTimeDonated,
    this.nextDonation,
    this.rating,
    this.totalDonations,
    this.url,
    this.phone,
    this.email,

  });

  final String? id;
  final String? bio;
  final String? name;
  final String? country;
  final String? city;
  final String? group;
  final String? type;
  final String? price;
  final String? url;
  final String? phone;
  final String? email;
  final Timestamp? lastTimeDonated;
  final Timestamp? nextDonation;
  final bool? isAvailableForDonation;
  final double? rating;
  final List? geo;
  final Timestamp? timestamp;
  final int? totalDonations;

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
    price: json["price"],
    geo: json["geo"],
    timestamp: json["timestamp"],
    isAvailableForDonation: json["isAvailableForDonation"],
    rating: json["rating"],
    nextDonation: json["nextDonation"],
    lastTimeDonated: json["lastTimeDonated"],
    totalDonations:json["totalDonations"],
    url:json["url"],
    phone:json["phone"],
    email:json["email"],

  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "bio": bio,
    "name": name,
    "country": country,
    "city": city,
    "group": group,
    "type": type,
    "price": price,
    "geo": geo,
    "timestamp": timestamp,
    "isAvailableForDonation": isAvailableForDonation,
    "rating": rating,
    "nextDonation": nextDonation,
    "lastTimeDonated": lastTimeDonated,
    "totalDonations": totalDonations,
    "url": url,
    "phone": phone,
    "email": email,

  };
}
