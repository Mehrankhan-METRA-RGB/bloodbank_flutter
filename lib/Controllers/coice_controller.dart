import 'package:bloodbank/Controllers/blood_controller.dart';
import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/models/blood_model.dart';
import 'package:get/get.dart';

class ChoiceBloodController extends GetxController{
  final  choiceData=" ".obs;
final choiceDonors=[].obs;
final choiceReceivers=[].obs;


val(val){
return  choiceData.value=val;
}
  donors(val){

    choiceDonors.value=(BloodController.instance.donateTo(val))!;
  }

  receivers(val){
    choiceReceivers.value=(BloodController.instance.receiveFrom(val))!;
  }

}

class ChoiceTypeController extends GetxController{
  final  choiceData=" ".obs;



  val(val){
    return  choiceData.value=val;
  }


}