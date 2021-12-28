
import 'dart:convert';

class Credentials {
  Credentials({
    this.id,
    this.photoUrl,
    this.name,
    this.email,
    this.serverAuthCode,
    this.authentication,
    this.authHeader,
  });

  final String? id;
  final String? photoUrl;
  final String? name;
  final String? email;
  final String? serverAuthCode;
  final String? authentication;
  final String? authHeader;

  factory Credentials.fromJson(String str) => Credentials.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Credentials.fromMap(Map<String, dynamic> json) => Credentials(
    id: json["id"],
    photoUrl: json["photoUrl"],
    name: json["name"],
    email: json["email"],
    serverAuthCode: json["serverAuthCode"],
    authentication: json["authentication"],
    authHeader: json["authHeader"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "photoUrl": photoUrl,
    "name": name,
    "email": email,
    "serverAuthCode": serverAuthCode,
    "authentication": authentication,
    "authHeader": authHeader,
  };
}
