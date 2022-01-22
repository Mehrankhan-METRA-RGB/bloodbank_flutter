import 'package:bloodbank/models/phone_number_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:url_launcher/url_launcher.dart';

class Methods{
Methods._private();
static final Methods instance =
Methods._private();







  sendMail(String? mail) async {
    var url = 'mailto:$mail';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sendSMSTo(String? phoneNo) async {
    var url = "sms:$phoneNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  makeCall(String? phoneNo) async {
    var url = "tel://+$phoneNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _sendSMSToAll({bloodGroups,userBloodGroup,userCity,users, String? msg}) async {
    List<PhoneModel> _phone =
    countries.map((map) => PhoneModel.fromMap(map)).toList();

    List<String>? donorsNumbers = [];
    String message =msg??
        'Urgent need $bloodGroups for $userBloodGroup in $userCity';
    for (var element in users) {
      PhoneModel filteredPhone =
      _phone.singleWhere((filter) => filter.name == element?.country);
      String? code = '+${filteredPhone.dialCode}';

      donorsNumbers.add('$code${element!.phone!}');
    }

    String _result = await sendSMS(message: message, recipients: donorsNumbers)
        .catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
    if (kDebugMode) {
      print(_result);
    }
  }
}