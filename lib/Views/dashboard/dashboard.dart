import 'package:bloodbank/Controllers/geo_controller.dart';
import 'package:bloodbank/Controllers/loading_controller.dart';
import 'package:bloodbank/Views/dashboard/donars.dart';
import 'package:bloodbank/Views/dashboard/right_small_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import '../../Controllers/blood_controller.dart';
import '../../Controllers/coice_controller.dart';
import '../../Controllers/contants/values.dart';
import '../../models/user_model.dart';
import '../constants/widgets.dart';
import 'map/map_show.dart';

class Dashboard extends StatelessWidget {
  Dashboard({required this.user, Key? key}) : super(key: key);
  final UserModel? user;
  final LoadingController loadingController = Get.put(LoadingController());
  final GeoController geoController = Get.put(GeoController());
  final ChoiceBloodController bloodController =
      Get.put(ChoiceBloodController());
  final googleSign = GoogleSignIn();
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection(firebaseCollection);
  final List? myGeo = [];
  final GlobalKey? _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const UserProfile(),
      endDrawer: RightDrawer(),
      body: Center(
        child: GetX<GeoController>(
            init: GeoController(),
            initState: (a) {
              geoController.getPlace(GeoPoint(user!.geo![0], user!.geo![1]));
              bloodController.val(user!.group);
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
                      "Looking for ${bloodController.choiceData.value.isNotEmpty ? bloodController.choiceData.value : "---"}",
                      style: Theme.of(context).textTheme.titleLarge),
                  titleDescription: Text(
                    " In ${geoController.placeByGeo.value.isNotEmpty ? geoController.placeByGeo.value[2] : " - - - "} ",
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
                      Obx(() {
                        return !loadingController.isLoadingSearchButton.value
                            ? IconButton(
                                tooltip:
                                    "find the preferred donors according to given data",
                                icon: const Icon(Icons.search_outlined),
                                iconSize: 30.0,
                                color: Colors.red,
                                onPressed: () => _onSearchButton(context))
                            : const SizedBox(
                                height: 60,
                                width: 60,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                ),
                              );
                      }),
                    ],
                  ),
                  body: MapShow(
                    paddingTop: 30,
                    initPos: LatLng(user!.geo![0], user!.geo![1]),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 140,
                  ));
            }),
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: Colors.white70,
        child: App.instance.dropDown(
            values: bloodGroups,
            placeholder: ' blood',
            heading: 'Recipient Blood Group',
            paddingVert: 1,
            titles: bloodGroups,
            controller: bloodController),
      ),
    );
  }

  _onSearchButton(BuildContext context) async {
    if (bloodController.choiceData.value.isNotEmpty &&
        geoController.placeByGeo.value.isNotEmpty) {
      loadingController.isLoadingSearchButton.value = true;

      ///Filtered  data according to blood group and city name

      if (kDebugMode) {
        print(BloodController.instance
            .receiveFrom(bloodController.choiceData.value)!);
        print(bloodController.choiceData.value);
      }
      await _filterSearchList(
              geoController.placeByGeo.value[2],
              BloodController.instance
                  .receiveFrom(bloodController.choiceData.value)!)
          .then((users) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Donors(
                        users: users,
                        userBloodGroup: bloodController.choiceData.value,
                        userCity: geoController.placeByGeo.value[2],
                      ))))
          .whenComplete(
              () => loadingController.isLoadingSearchButton.value = false);
    } else {
      App.instance.snackBar(context,
          text: "Please Point location on a map and Select Blood Group",
          bgColor: Colors.red);
    }
  }

  Future<List<UserModel?>> _filterSearchList(
      String? yourCity, List<String?> bGroups) async {
    if (kDebugMode) {
      print("Searching for........");
      print(bGroups);
      print(yourCity);
    }

    List<UserModel> users = [];
    await FirebaseFirestore.instance
        .collection(firebaseCollection)
        .where('city', isEqualTo: yourCity)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snap) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> filtered =
          snap.docs.where((element) {
        UserModel user = UserModel.fromMap(element.data());
        bool isDonateAble =
            bGroups.contains(user.group);
        Timestamp? lastDonationTime =user.lastTimeDonated ??
                Timestamp(000, 000);
        DateTime? oldTimeWithTimeSpan =
            lastDonationTime.toDate().add(const Duration(days: 90));
        bool isBloodDurationCompleted =
            oldTimeWithTimeSpan.isBefore(DateTime.now());

        if (kDebugMode) {
          print(
              '\n\n\nName: ${user.name}\n LastTime: $lastDonationTime \n isBloodDurationCompleted: $isBloodDurationCompleted \n\n\n ');
        }
///Here we have check the acceptable blood and Time Span of donor since last Donation
        return isDonateAble && isBloodDurationCompleted;
      }).toList();

      for (QueryDocumentSnapshot<Map<String, dynamic>> element in filtered) {
        users.add(UserModel.fromMap(element.data()));
        if (kDebugMode) {
          print('${element['name']} Added');
        }
      }
    });

    return users;
  }
}
