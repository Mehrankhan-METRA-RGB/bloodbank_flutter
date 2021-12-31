import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

import '../../../Controllers/geo_controller.dart';

class MapShow extends StatelessWidget {
   MapShow({required this.width,this.initPos,this.paddingTop=80,required this.height,Key? key}) : super(key: key);
   final double? width;
   final double? height;
   final double? paddingTop;
   final LatLng? initPos;



  final GeoController _geoController=Get.put(GeoController());
   final MarkerId idPlace = const MarkerId("pickPlace");

  @override
  Widget build(BuildContext context) {
    return   SizedBox(
      height: height,
      width: width,
      child:Obx((){

        double? lat=_geoController.geo.value?.latitude?? UserModel.fromJson(Hive.box(authBox).get(authBoxDataKey)).geo?[0]??33.65756 ;
        double? long=_geoController.geo.value?.longitude??UserModel.fromJson(Hive.box(authBox).get(authBoxDataKey)).geo?[1]??71.083432;
        _geoController.insertGeo(GeoPoint(lat!,long!));
        return GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {
controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long),zoom: 12)));
           },
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
             Factory<OneSequenceGestureRecognizer>(() =>  EagerGestureRecognizer(),),
          },

compassEnabled: true,
            zoomControlsEnabled: true,
            padding: EdgeInsets.only(top: paddingTop!),
            scrollGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,

            initialCameraPosition: CameraPosition(target:initPos?? LatLng(lat,long), zoom: 10),
            onTap: (geo) {
              if (kDebugMode) {
                print("Latitude: ${geo.latitude}");
                print("Latitude: ${geo.longitude}");
              }
              _geoController.insertGeo(GeoPoint(geo.latitude,geo.longitude));
              // geoController.getPlace(GeoPoint(geoController.geo.value!.latitude, geoController.geo.value!.longitude));
              _geoController.getPlace(GeoPoint(geo.latitude, geo.longitude));
              if (kDebugMode) {
                print(_geoController.placeByGeo.value);

              }
            },
            markers: <Marker>{
              Marker(
                position: LatLng(_geoController.geo.value!.latitude,_geoController.geo.value!.longitude),
                markerId: idPlace,
              )
            });
      })
    );
  }
}
