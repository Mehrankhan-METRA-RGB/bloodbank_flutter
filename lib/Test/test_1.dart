import 'package:bloodbank/Controllers/coice_controller.dart';
import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/Controllers/geo_controller.dart';
import 'package:bloodbank/Views/dashboard/update_profile.dart';
import 'package:bloodbank/models/credentials_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import '../Views/constants/widgets.dart';
import '../Views/dashboard/map/map_show.dart';
import '../Views/dashboard/proceed_signup_form.dart';

class Test1 extends StatelessWidget {
  Test1({ Key? key}) : super(key: key);

  GeoController geoController = Get.put(GeoController());
  ChoiceBloodController bloodController = Get.put(ChoiceBloodController());
var random=Random();
  final GlobalKey? _key = GlobalKey();

  /// local variable fields
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpdateProfile(currentUser: Credentials(
        id: '${1000000 + random.nextInt(100000000 - 1000000)}',
        name: ' user${ random.nextInt(100)}',
        photoUrl: ' ',
        email: 'email@domain.com',
        serverAuthCode: 'authcode',
        authHeader: 'authHeader',
        authentication: 'authentications'

      ),),
      bottomNavigationBar: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color:Colors.white70,
      child: App.instance.dropDown(values: bloodGroups,
          placeholder: 'Blood',
          heading: 'Select Blood Group',
          paddingVert: 1,
          titles: bloodGroups,controller: bloodController),
      ),
    );


  }


}



