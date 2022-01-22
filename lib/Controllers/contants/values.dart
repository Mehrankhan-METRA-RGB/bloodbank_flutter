
import 'dart:math';

import 'package:bloodbank/models/phone_number_model.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/countries.dart';
var random=Random();
const String firebaseCollection = "BloodBank_Users";
const String firebaseSubCollection = "BloodBank_User_room";
const String authBox = "AuthBox";
const String authBoxCredentialsKey = "user";
const String authBoxDataKey = "data";
const String yourDonorsKey = "YourDonorsKey";
const String yourDonorsBox = "yourdonorsbox";
const String mapsAPIKey = "AIzaSyB0KUzlF95tXVWyVvIU8nalWK35W7rIh34";
const List<String>? bloodGroups = [
  "A+",
  "O+",
  "B+",
  "AB+",
  "A-",
  "O-",
  "B-",
  "AB-"
];
UserModel? get currentUserModel=>UserModel.fromJson(Hive.box(authBox).get(authBoxDataKey));
const Map<String, dynamic> bloodMap = {
  "A+": {
    "donateTo": ["A+", "AB+"],
    "receiveFrom": ["A+", "A-", "O+", "O-"]
  },
  "O+": {
    "donateTo": ["O+", "A+", "B+", "AB+"],
    "receiveFrom": ["O+", "O-"]
  },
  "B+": {
    "donateTo": ["B+", "AB+"],
    "receiveFrom": ["B+", "B-", "O+", "O-"]
  },
  "AB+": {
    "donateTo": ["AB+"],
    "receiveFrom": ["A+", "O+", "B+", "AB+", "A-", "O-", "B-", "AB-"]
  },
  "A-": {
    "donateTo": ["A+", "AB+", "A-", "AB-"],
    "receiveFrom": ["A-", "O-"]
  },
  "O-": {
    "donateTo": ["A+", "O+", "B+", "AB+", "A-", "O-", "B-", "AB-"],
    "receiveFrom": ["O-"]
  },
  "B-": {
    "donateTo": ["B+", "AB+", "B-", "AB-"],
    "receiveFrom": ["b-", "O-"]
  },
  "AB-": {
    "donateTo": ["AB-", "AB+"],
    "receiveFrom": ["B-", "A-", "AB-", "O-"]
  }
};
const List<String>? accountTypes = ["Donor", "Recipient"];
String get generateRoomId=> '${random.nextInt(100000)}_${currentUserModel!.id}_room';


String phoneWithDialCode(String country,String phoneNo){
  // UserModel? snap = users[index];

  List<PhoneModel> _phone =
  countries.map((map) => PhoneModel.fromMap(map)).toList();
  PhoneModel filteredPhone = _phone
      .singleWhere((element) => element.name == country);
  String? code = '+${filteredPhone.dialCode}';
return '$code$phoneNo';
}