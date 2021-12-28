
import 'dart:convert';

class BloodModel {
  BloodModel({
    this.aPos,
    this.oPos,
    this.bPos,
    this.abPos,
    this.aNeg,
    this.oNeg,
    this.bNeg,
    this.abNeg,
  });

  final BloodCan? aPos;
  final BloodCan? oPos;
  final BloodCan? bPos;
  final BloodCan? abPos;
  final BloodCan? aNeg;
  final BloodCan? oNeg;
  final BloodCan? bNeg;
  final BloodCan? abNeg;

  factory BloodModel.fromJson(String str) => BloodModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BloodModel.fromMap(Map<String, dynamic> json) => BloodModel(
    aPos: BloodCan.fromMap(json["A+"]),
    oPos: BloodCan.fromMap(json["O+"]),
    bPos: BloodCan.fromMap(json["B+"]),
    abPos: BloodCan.fromMap(json["AB+"]),
    aNeg: BloodCan.fromMap(json["A-"]),
    oNeg: BloodCan.fromMap(json["O-"]),
    bNeg: BloodCan.fromMap(json["B-"]),
    abNeg: BloodCan.fromMap(json["AB-"]),
  );

  Map<String, dynamic> toMap() => {
    "A+": aPos!.toMap(),
    "O+": oPos!.toMap(),
    "B+": bPos!.toMap(),
    "AB+": abPos!.toMap(),
    "A-": aNeg!.toMap(),
    "O-": oNeg!.toMap(),
    "B-": bNeg!.toMap(),
    "AB-": abNeg!.toMap(),
  };
}

class BloodCan {
  BloodCan({
    this.donateTo,
    this.receiveFrom,
  });

  final List<String>? donateTo;
  final List<String>? receiveFrom;

  factory BloodCan.fromJson(String str) => BloodCan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BloodCan.fromMap(Map<String, dynamic> json) => BloodCan(
    donateTo: List<String>.from(json["donateTo"].map((x) => x)),
    receiveFrom: List<String>.from(json["receiveFrom"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "donateTo": List<dynamic>.from(donateTo!.map((x) => x)),
    "receiveFrom": List<dynamic>.from(receiveFrom!.map((x) => x)),
  };
}
