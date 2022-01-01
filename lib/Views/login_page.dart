import 'dart:convert';
import 'package:bloodbank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import '../Controllers/auth/auth_controller.dart';
import '../Controllers/contants/values.dart';
import '../models/phone_number_model.dart';
import 'dashboard/proceed_signup_form.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final AuthController signCont = Get.put(AuthController());
 final CollectionReference userRef = FirebaseFirestore.instance.collection(userDoc);
  final signGoogle = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Obx(() {
        if (signCont.googleAccount.value == null) {
          return Center(
            child: FloatingActionButton.extended(
              onPressed: () => signInButton(context),
              icon: Image.asset(
                "assets/icons/google_logo.png",
                width: 50,
                height: 50,
              ),
              label: const Text("Google SigIn"),
            ),
          );
        } else {
          return Center(
            child: FloatingActionButton.extended(
              onPressed: () => signInButton(context),
              icon: Image.asset(
                "assets/icons/google_logo.png",
                width: 50,
                height: 50,
              ),
              label: const Text("Google SigIn"),
            ),
          );
        }
      }),
    );
  }

  signInButton(BuildContext context) {
    signCont.login().whenComplete(() async {
      UserModel? user;
      await FirebaseFirestore.instance
          .collection(userDoc)
          .doc(signCont.googleAccount.value!.id)
          .get()
          .then((DocumentSnapshot snap) {
        if (snap.exists) {
          /// Here we break the [UserModel] and created a new [UserModel]
          /// with a phone number having no [dial_code]

          UserModel _user = UserModel.fromJson(jsonEncode(snap.data()));

          List<PhoneModel> _phone =
              countries.map((map) => PhoneModel.fromMap(map)).toList();
          PhoneModel filteredPhone =
              _phone.singleWhere((element) => element.name == _user.country);
          String? newPhone = _user.phone != null
              ? _user.phone!.replaceAll('+${filteredPhone.dialCode}', '')
              : _user.phone;
          user = UserModel(
              id: _user.id,
              isAvailableForDonation: _user.isAvailableForDonation,
              totalDonations: _user.totalDonations,
              name: _user.name,
              email: _user.email,
              nextDonation: _user.nextDonation,
              lastTimeDonated: _user.lastTimeDonated,
              rating: _user.rating,
              timestamp: _user.timestamp,
              phone: newPhone,  ///Here we have assigned a new number without country dial code
              price: _user.price,
              geo: _user.geo,
              group: _user.group,
              bio: _user.bio,
              country: _user.country,
              city: _user.city,
              url: _user.url,
              type: _user.type);
        } else {
          user = null;
        }
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProceedSignUp(
                    currentUser: signCont.googleAccount.value,
                    oldData: user,
                  )));
    });
  }

  Future<UserModel?> initialData(
      String? userDocumentId, BuildContext context) async {}
}
