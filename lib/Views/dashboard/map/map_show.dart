import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Controllers/geo_controller.dart';

class MapShow extends StatelessWidget {
   MapShow({required this.width,this.paddingTop=80,required this.height,Key? key}) : super(key: key);
   final double? width;
   final double? height;
   final double? paddingTop;



  final GeoController _geoController=Get.put(GeoController());
   final MarkerId idPlace = const MarkerId("pickPlace");

  @override
  Widget build(BuildContext context) {
    return   SizedBox(
      height: height,
      width: width,
      child:Obx((){
        double? lat=_geoController.geo.value?.latitude??33.0987394;
        double? long=_geoController.geo.value?.longitude??71.083432;
        _geoController.insertGeo(GeoPoint(lat,long));
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

            initialCameraPosition: CameraPosition(target: LatLng(lat,long), zoom: 14),
            onTap: (geo) {
              if (kDebugMode) {
                print("Latitude: ${geo.latitude}");
                print("Latitude: ${geo.longitude}");
              }
              _geoController.insertGeo(GeoPoint(geo.latitude,geo.longitude));
              _geoController.getPlace(_geoController.geo.value!);
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
