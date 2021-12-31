// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class PhoneModel {
  PhoneModel({
    this.name,
    this.flag,
    this.code,
    this.dialCode,
    this.maxLength,
  });

  final String? name;
  final String? flag;
  final String? code;
  final int? dialCode;
  final int? maxLength;

  PhoneModel copyWith({
    String? name,
    String? flag,
    String? code,
    int? dialCode,
    int? maxLength,
  }) =>
      PhoneModel(
        name: name ?? this.name,
        flag: flag ?? this.flag,
        code: code ?? this.code,
        dialCode: dialCode ?? this.dialCode,
        maxLength: maxLength ?? this.maxLength,
      );

  factory PhoneModel.fromJson(String str) => PhoneModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PhoneModel.fromMap(Map<String, dynamic> json) => PhoneModel(
    name: json["name"],
    flag: json["flag"],
    code: json["code"],
    dialCode: json["dial_code"],
    maxLength: json["max_length"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "flag": flag,
    "code": code,
    "dial_code": dialCode,
    "max_length": maxLength,
  };
}
