import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloodbank/Test/test_1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'contants/values.dart';

class GeoController extends GetxController {
  // final  lat=GeoPoint;
  // final  long=null.obs;

  var geo = Rx<GeoPoint?>(null);
  var placeByGeo = Rx<List<String?>>([]);
  var currentLoc = Rx<Position?>(null);
  var autoCompleteSearchList = Rx<List<PlaceSearch?>>([]);
  var placeById = Rx<List<PlaceSearch?>>([]);

  // returnCurrentGeo(){
  //   return geo.value;
  // }
  insertGeo(GeoPoint? geoPoint) {
    return geo.value = geoPoint;
  }

  Future<List<String?>> getPlace(GeoPoint geoLoc) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        geoLoc.latitude,
        geoLoc.longitude,
      );

      return placeByGeo.value = [
        placeMarks[0].country.toString(),
        placeMarks[0].administrativeArea.toString(),
        placeMarks[0].subAdministrativeArea.toString()
      ];
    } catch (err) {
      rethrow;
    }
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$mapsAPIKey';
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    print(jsonResults.map((place) => PlaceSearch.fromJson(place)).toList());
    autoCompleteSearchList.value =
        jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlaceById(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapsAPIKey';
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces(
      double lat, double lng, String placeType) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=$placeType&rankby=distance&key=$mapsAPIKey';
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
