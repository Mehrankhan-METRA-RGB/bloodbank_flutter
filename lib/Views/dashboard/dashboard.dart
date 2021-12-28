import 'package:bloodbank/Controllers/auth/auth_controller.dart';
import 'package:bloodbank/Controllers/blood_controller.dart';
import 'package:bloodbank/Controllers/geo_controller.dart';
import 'package:bloodbank/Views/dashboard/drawer.dart';
import 'package:bloodbank/models/credentials_model.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import '../../Controllers/coice_controller.dart';
import '../../Controllers/contants/values.dart';
import '../constants/widgets.dart';

import 'map/map_show.dart';

class Dashboard extends StatefulWidget {
  Dashboard({required this.authData, this.geo, this.id, Key? key})
      : super(key: key);
  final Credentials? authData;
  final LatLng? geo;
  final String? id;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GeoController geoController = Get.put(GeoController());
  final ChoiceBloodController bloodController =
      Get.put(ChoiceBloodController());
  final googleSign = GoogleSignIn();
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection(userDoc);
  List? myGeo = [];
  LatLng? _geo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _geo = widget.geo!;
    // userCredentials();
    UserModel s = UserModel.fromJson(Hive.box(authBox).get(authBoxDataKey));
    // print(Hive.box(authBox).get(authBoxDataKey));
    myGeo = [s.geo![0], s.geo![1]];
    geoController.getPlace(GeoPoint(_geo!.latitude,_geo!.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(),
      body:
        Column(
          children: [
            const TextField(),
            Expanded(
                flex: 1,
                child: MapShow(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ))
            ,
            SizedBox(
              height: 250,
              child: Column(
                children: [
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                    child: Container(alignment:Alignment.centerLeft,child:
                    Obx(() {if(geoController.placeByGeo.value.isNotEmpty){
                      return Text(
                        "${geoController.placeByGeo.value[0].toString()}   |   ${geoController.placeByGeo.value[2].toString()}",
                        style: Theme.of(context).textTheme.bodyText2,textScaleFactor: 1.2,);
                    }else{
                      return Row(children:const [
                        CircularProgressIndicator(),
                        Text("        |       "),
                        CircularProgressIndicator(),
                      ],);
                    }

                    })),
                  )),
                  Card(
                    child: App.instance.dropDown(
                      heading: 'Blood Groups',
                      paddingVert: 0,
                      controller: bloodController,
                      values: bloodGroups,
                      titles: bloodGroups,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

    );
  }

  userCredentials() {
    FirebaseFirestore.instance
        .collection(userDoc)
        .doc(googleSign.currentUser!.id)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        try {
          dynamic nested = snapshot.get(FieldPath(const ['url']));

          print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
          print(nested.toString());
        } on StateError catch (e) {
          print('No nested field exists!');
        }
      } else {
        print('Document does not exist on the database');
      }
    });

    // return    Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: ClipOval(
    //     child: FutureBuilder<DocumentSnapshot>(
    //         future:  userReference.doc(widget.authData!.id).get(),
    //         builder: (context,snapshot){
    //           if(snapshot.hasData){
    //
    //             return Image.network(snapshot.data.data())
    //           }else if(){}else{}
    //     return  googleController.googleAccount.value!.photoUrl != null
    //           ? Image.network(googleController.googleAccount.value!.photoUrl!)
    //           :const Text("No Img");
    //     })
    //   ),
    // );
  }
}
