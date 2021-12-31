import 'package:bloodbank/Controllers/geo_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliverbar_with_card/sliverbar_with_card.dart';

import '../Controllers/coice_controller.dart';
import '../Controllers/contants/values.dart';
import '../Views/constants/widgets.dart';
import '../Views/dashboard/drawer.dart';
import '../Views/dashboard/map/map_show.dart';
import '../models/user_model.dart';
class Test2 extends StatelessWidget {
  Test2({required this.user, Key? key})
      : super(key: key);
  final UserModel? user;


   final GeoController geoController = Get.put(GeoController());
   final ChoiceBloodController bloodController =Get.put(ChoiceBloodController());
   final googleSign = GoogleSignIn();
   final CollectionReference userReference =
   FirebaseFirestore.instance.collection(userDoc);
   List? myGeo = [];
  final GlobalKey? _key = GlobalKey();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      drawer: const DashboardDrawer(),
      body:
        Center(
          child: GetX<GeoController>(
            init: GeoController(),
              initState:(a){


                geoController.getPlace(GeoPoint(user!.geo![0],user!.geo![1]));


              },
              builder: (builder) {

                return CardSliverAppBar(
                    key: _key,
                    height: 250,
                    background: Image.asset(
                      'assets/images/blood_donor.jpg',
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                        "Looking for ${bloodController.choiceData.value.isNotEmpty ?
                        bloodController.choiceData.value
                            : "---"}",
                        style: Theme.of(context).textTheme.titleLarge),
                    titleDescription: Text(
                      " In ${geoController.placeByGeo.value.isNotEmpty
                          ?geoController.placeByGeo.value[2]
                          : "---"} ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    card: const AssetImage(
                      'assets/images/donate_blood.jpg',
                    ),
                    backButton: false,
                    backButtonColors: const [
                      Colors.white70,
                      Colors.red,
                      Colors.blueAccent
                    ],
                    action: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        IconButton(
                          tooltip:"find the preferred donors according to given data",
                          icon: const Icon(Icons.search_outlined),
                          iconSize: 30.0,
                          color: Colors.red,
                          onPressed: () {},
                        ),
                      ],
                    ),

                    body: MapShow(
                      paddingTop: 30,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 140,
                    ));
              }),
        ),
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
