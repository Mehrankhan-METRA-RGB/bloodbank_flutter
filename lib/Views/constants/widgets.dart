import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:smart_select/smart_select.dart';

class App {
  App._private();
  static final instance = App._private();

  ///Application SnackBar
Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>   snackBar(BuildContext context,
          {String? text, Color? bgColor, TextStyle? textStyle}) async {
    return Scaffold.of(context).showSnackBar( SnackBar(
        content: Text(
            text!,
            style: textStyle ?? Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        duration: const Duration(seconds: 2),

        backgroundColor:
            bgColor ?? Theme.of(context).snackBarTheme.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: Theme.of(context).snackBarTheme.shape,
      ));
  }

  snakBar({required String? text,String? title, Color? bgColor, TextStyle? textStyle}){
   Get.snackbar(
    title??"Application",
    text!,
    icon: const Icon(Icons.person, color: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    duration: const Duration(seconds: 2),
    isDismissible: true,
    // dismissDirection: SnackDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.easeOutBack,
    backgroundColor:
    bgColor ?? Get.theme.snackBarTheme.backgroundColor,
    // snackStyle: sna,

    // shape: Get.theme.snackBarTheme.shape,

  );
  }


///Application Button
   button(BuildContext context,{
    required Widget child,
    required void Function()? onPressed,
    Color? color,
  })=>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 1),
    child: CupertinoButton(child: Row(mainAxisAlignment: MainAxisAlignment.center,

      children: [
        child,
      ],
    ),padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10), onPressed: onPressed,color: color??Colors.redAccent,),
  );


  dropDown(
      {required List<String>? values,
        required List<String>? titles,
        String heading = "title",
       String  placeholder='select',
        double? paddingVert=25,

        dynamic controller}) {
    // simple usage
    if (values!.length != titles!.length) {
      throw "The length of values and titles must be same";
    }

    List<S2Choice<String>> options = [
      for (var i = 0; i < values.length; i++)
        S2Choice<String>(value: values[i], title: titles[i]),
    ];

    return Padding(
      padding:  EdgeInsets.symmetric(vertical: paddingVert!),
      child: SmartSelect<String>.single(
placeholder: placeholder,
          title: heading,
          value: controller?.choiceData.value??'not selected',
          choiceItems: options,
          onChange: (state) { controller.val(state.value);

          },
          modalValidation: (val) {
            if (val.isEmpty) {

              return "Please $heading";
            } else {
              return null;
            }
          }),
    );
  }

}
