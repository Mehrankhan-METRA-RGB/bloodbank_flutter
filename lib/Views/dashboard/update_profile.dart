import 'dart:convert';

import 'package:bloodbank/Controllers/coice_controller.dart';
import 'package:bloodbank/Controllers/geo_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:smart_select/smart_select.dart' ;

import '../../Controllers/contants/values.dart';
import '../../models/credentials_model.dart';
import '../../models/user_model.dart';
import '../constants/text_field.dart';
import '../constants/widgets.dart';
import 'dashboard.dart';
import 'map/map_show.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({this.currentUser, Key? key}) : super(key: key);

  ///Constructor fields
  final Credentials? currentUser;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  /// local variable fields

  final CollectionReference userReference =
      FirebaseFirestore.instance.collection(userDoc);
  final ChoiceBloodController _bloodController=Get.put(ChoiceBloodController());
  final ChoiceTypeController _typeController=Get.put(ChoiceTypeController());
  final GeoController _geoController=Get.put(GeoController());
  bool isDataNotAssignToCont = true;
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  final TextEditingController _controllerBio = TextEditingController();
  final TextEditingController _controllerType = TextEditingController();
  final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final TextEditingController _controllerBloodGroup = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerGeo = TextEditingController();

  Future<DocumentSnapshot<Map<String, dynamic>>>? loadedData;
  // LatLng? _geo;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.currentUser != null) {
      ///get the old users data
      initialData(widget.currentUser!.id);
    } else {
      Credentials credentials =
      Credentials.fromJson(Hive.box(authBox).get(authBoxCredentialsKey));

      initialData(credentials.id);
    }

    _controllerBio.addListener(() {
      setState(() {});
    });
    _controllerType.addListener(() {
      setState(() {});
    });
    _controllerCountry.addListener(() {
      setState(() {});
    });
    _controllerBloodGroup.addListener(() {
      setState(() {});
    });
    _controllerPrice.addListener(() {
      setState(() {});
    });
    _controllerCity.addListener(() {
      setState(() {});
    });
    _controllerPhone.addListener(() {
      setState(() {});
    });
    _controllerEmail.addListener(() {
      setState(() {});
    });
    _controllerName.addListener(() {
      setState(() {});
    });
    _controllerGeo.addListener(() {
      setState(() {});
    });
    initialData(widget.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        SafeArea(child: SingleChildScrollView(child: formColumn(context))));
  }

  Widget formColumn(BuildContext context) {
    return Form(
        key: _userFormKey,
        child: Column(
          children: [
            // App.instance.button(context, child: const Text('Test'), onPressed: (){initialData();}),
            MapShow(
              width: MediaQuery.of(context).size.width - 4,
              height: 200,
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                      _geoController.placeByGeo.value.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    )),
              );
            }),
            AppTextField(
              controller: _controllerBio,
              hint: "Bio",
              inputType: TextInputType.multiline,
              expand: true,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IntlPhoneField(
                initialCountryCode: "PK",
                controller: _controllerPhone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                onChanged: (phone) {
                  // print(countries.contains(phone.countryCode));
                  for (var country in countries) {
                    phone.countryCode == "+${country["dial_code"]}"
                        ? _controllerCountry.text = country["name"]
                        : null;
                  }
                },
                onCountryChanged: (phone) {
                  for (var country in countries) {
                    phone.countryCode == "+${country["dial_code"]}"
                        ? _controllerCountry.text = country["name"]
                        : null;
                  }
                },
              ),
            ),
            AppTextField(
              controller: _controllerCountry,
              inputType: TextInputType.name,
              hint: "Country",
            ),
            AppTextField(
              controller: _controllerCity,
              inputType: TextInputType.name,
              hint: "City",
            ),

            AppTextField(
              controller: _controllerPrice,
              inputType: TextInputType.number,
              hint: "Price",
            ),
            App.instance.dropDown(
                controller: _bloodController,
                values: bloodGroups,
                titles: bloodGroups,
                heading: "Select Blood Group"),

            App.instance.dropDown(
                controller: _typeController,
                values: accountTypes,
                titles: accountTypes,
                heading: "Select Account Type"),

            const SizedBox(
              height: 50,
            ),
            App.instance.button(context,
                child: const Text("Update"),
                onPressed: () => _onSubmit(context)),
            const SizedBox(
              height: 50,
            ),
          ],
        ));
  }






  ///TODO: Business Logic
  ///
  ///
  ///
  Future initialData(String? userDocumentId) async {
    await FirebaseFirestore.instance
        .collection(userDoc)
        .doc(userDocumentId!)
        .get()
        .then((DocumentSnapshot snap) {
      if (snap.exists) {
        UserModel user = UserModel.fromJson(jsonEncode(snap.data()));
        _bloodController.val(user.group!);
        _typeController.val(user.type!);
        _controllerPrice.text = user.price!;
        _controllerBio.text = user.bio!;
        _controllerCity.text = user.city!;
        _controllerCountry.text = user.country!;
        _controllerPhone.text = user.phone!;
        _geoController.insertGeo(GeoPoint(user.geo![0], user.geo![1]));
        _geoController.getPlace(GeoPoint(user.geo![0], user.geo![1]));
      } else {}
    });
  }

  ///Upload or update users data
  ///when submit a form
  ///
  void _onSubmit(BuildContext context) async {
    if (_userFormKey.currentState!.validate()) {
      // final AuthController controller = Get.put(AuthController());
// final  GoogleSignInAccount? google = controller.googleAccount.value;
    Credentials data=Credentials.fromJson(Hive.box(authBox).get(authBoxCredentialsKey));



      UserModel userData = UserModel(
          id: widget.currentUser!.id,
          name: widget.currentUser!.name,
          country: _controllerCountry.text,
          city: _controllerCity.text,
          geo: [
            _geoController.geo.value!.latitude,
            _geoController.geo.value!.longitude
          ],
          bio: _controllerBio.text,
          price: _controllerPrice.text,
          type: _typeController.choiceData.value,
          group: _bloodController.choiceData.value,
          url: widget.currentUser!.photoUrl,
          phone: _controllerPhone.text,
          email: _controllerEmail.text);

      await App.instance
          .snackBar(context, text: "Loading....")
          .whenComplete(() => addUser(context, userModel: userData))
          .whenComplete(() {
        Hive.box(authBox).put(authBoxCredentialsKey, data.toJson());
        Hive.box(authBox).put(authBoxDataKey, userData.toJson());
      });
    } else {
      App.instance
          .snackBar(context, text: "Not Validated", bgColor: Colors.red);
    }
  }

  ///Add new Form data to server DB
  ///push to dashboard
  Future<void> addUser(BuildContext context, {UserModel? userModel}) {
    return userReference
        .doc(userModel!.id)
        .set(userModel.toMap())
        .whenComplete(
            () => App.instance.snackBar(context, text: "Profile Updated"))
        .catchError((error) {
        //   App.instance.snackBar(context,
        // text: "Failed to add user: $error", bgColor: Colors.redAccent);

        print("Failed to add user: $error");
        });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerBio.dispose();
    _controllerType.dispose();
    _controllerCity.dispose();
    _controllerBloodGroup.dispose();
    _controllerCountry.dispose();
    _controllerPrice.dispose();
    _controllerEmail.dispose();
    _controllerPhone.dispose();
    _controllerName.dispose();
    _controllerGeo.dispose();
    // _controllerBio.dispose();
  }
}
