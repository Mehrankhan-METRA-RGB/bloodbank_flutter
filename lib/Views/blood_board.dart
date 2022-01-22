import 'package:bloodbank/Controllers/coice_controller.dart';
import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/widgets.dart';

class BloodBoard extends StatelessWidget {
   BloodBoard({Key? key}) : super(key: key);
final ChoiceBloodController controller=Get.put(ChoiceBloodController());
double? width;
double? height;
  @override
  Widget build(BuildContext context) {
width=MediaQuery.of(context).size.width;
height=MediaQuery.of(context).size.height;

    return  Center(
      child: Obx((){
        controller.choiceData.value;
        controller.donors(controller.choiceData.value);
        controller.receivers(controller.choiceData.value);
      return  Scaffold(
        appBar: AppBar(elevation: 0,backgroundColor: Colors.red,bottom: PreferredSize(preferredSize: Size(width!,50),
        child: App.instance.dropDown(values: bloodGroups, titles: bloodGroups,controller: controller,
            placeholder:controller.choiceData.value,paddingVert: 2,
            heading: 'Blood Group'),),),
        body: SingleChildScrollView(
          child: Column(
            children: [
           // Card(child: App.instance.dropDown(values: bloodGroups, titles: bloodGroups,controller: controller,
           //     placeholder:controller.choiceData.value,paddingVert: 2,
           //     heading: 'Blood Group'),)   ,
          Row(mainAxisAlignment: MainAxisAlignment.center,children:[
            SizedBox(width: width!/2.2,child:const Card(color: Colors.black54,child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Donate To',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),),
            ),),),
            SizedBox(width: width!/2.2,child:const Card(color: Colors.black54,child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Receive From',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),),
            ),),),
          ]),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(width: width!/2.2,
                  height: height!-180,
                  child: Card(
                    child: Column(children: [
                      for(var grp in controller.choiceDonors.value)
                        ListTile(title: Text(grp,style:const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),),),
                    ],),
                  ),
                ),
                SizedBox(width: width!/2.2,
                  height: height!-180,
                  child:Card(child: Column(children: [
                    for(var grp in controller.choiceReceivers.value)
                      ListTile(title: Text(grp,style:const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),),),
                  ],)),
                )

              ],),

            ],),
        ),
      );


      }),
    );
  }
}

