import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class  MapController extends GetxController{
  var geo=Rx<GeoPoint?>(null);


  getCity(GeoPoint geoLoc) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        geoLoc.latitude,
        geoLoc.longitude,
      );


        return [placeMarks[0].administrativeArea,placeMarks[0].subAdministrativeArea];

    } catch (err) {
      rethrow;
    }
  }

}