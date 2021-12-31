import 'package:get/get.dart';

class LoadingController extends GetxController{
  var isLoadingSearchButton =false.obs;


  changeLoading(){

    isLoadingSearchButton.value= (!isLoadingSearchButton.value);
  }


}