import '../models/blood_model.dart';
import 'contants/values.dart';

class BloodController {
  BloodController._private();
  static final instance = BloodController._private();



  ///Return List of Blood Groups,
  /// From whom you can be able to receive blood.
  /// Or
  /// Who can be able to donate you blood
  List<String>? receiveFrom(String? recipientBloodType) {
    List<String>? data;
    for (var group = 0; group < bloodMap.keys.length; group++) {
      if (bloodMap.keys.toList()[group] == recipientBloodType!) {
        data = BloodCan.fromMap(bloodMap.values.toList()[group]).receiveFrom;
      }
    }

    return data;
  }

  ///Return List of Blood Groups,
  /// To whom you can be able to donate a blood.

  List<String>? donateTo(String? donorBloodType) {
    List<String>? data;
    for (var group = 0; group < bloodMap.keys.length; group++) {
      if (bloodMap.keys.toList()[group] == donorBloodType!) {
        data = BloodCan.fromMap(bloodMap.values.toList()[group]).donateTo;
      }
    }

    return data;
  }
}