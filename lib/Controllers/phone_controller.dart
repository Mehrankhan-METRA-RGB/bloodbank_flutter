import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneNumberController extends GetxController  {
  var phoneNumber=' '.obs;
  var countryDialCode=' '.obs;

  insertPhone(phone){
    phoneNumber.value=phone;
  }
  insertDialCode(phone){
    phoneNumber.value='+$phone';
  }



}