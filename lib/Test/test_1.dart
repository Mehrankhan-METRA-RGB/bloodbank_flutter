import 'package:bloodbank/Controllers/coice_controller.dart';
import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/Controllers/geo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import '../Views/constants/widgets.dart';
import '../Views/dashboard/map/map_show.dart';

class Test1 extends StatelessWidget {
  Test1({this.currentUser, Key? key}) : super(key: key);

  ///Constructor fields
  final GoogleSignInAccount? currentUser;
  GeoController geoController = Get.put(GeoController());
  ChoiceBloodController bloodController = Get.put(ChoiceBloodController());

  final GlobalKey? _key = GlobalKey();

  /// local variable fields
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
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



class PlaceSearch {
  final String? description;
  final String? placeId;

  PlaceSearch({this.description, this.placeId});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json['description'], placeId: json['place_id']);
  }
}

class Place {
  final Geometry? geometry;
  final String? name;
  final String? vicinity;

  Place({this.geometry, this.name, this.vicinity});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      geometry: Geometry.fromJson(json['geometry']),
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}

class Geometry {
  final Location? location;

  Geometry({this.location});

  Geometry.fromJson(Map<dynamic, dynamic> parsedJson)
      : location = Location.fromJson(parsedJson['location']);
}

class Location {
  final double? lat;
  final double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Location(lat: parsedJson['lat'], lng: parsedJson['lng']);
  }
}
