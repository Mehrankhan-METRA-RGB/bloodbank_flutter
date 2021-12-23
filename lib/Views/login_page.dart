import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/auth/auth_controller.dart';
import '../models/user_model.dart';
import 'constants/text_field.dart';
import 'constants/widgets.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final AuthController signCont = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [App.instance.button(context, child:const Text("logout"), onPressed: (){signCont.logout();})],),
      body: Center(
        child: Obx(() {
          if (signCont.googleAccount.value == null) {
            return signInButton();
          } else {
            return const ProceedSignUp();
          }
        }),
      ),
    );
  }

  signInButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        signCont.login();
      },
      icon: Image.asset(
        "assets/icons/google_logo.png",
        width: 50,
        height: 50,
      ),
      label: const Text("Google SigIn"),
    );
  }
}

@immutable
class ProceedSignUp extends StatefulWidget {
  const ProceedSignUp({this.authData, Key? key}) : super(key: key);

  ///Constructor fields
  final AuthController? authData;

  @override
  State<ProceedSignUp> createState() => _ProceedSignUpState();
}

class _ProceedSignUpState extends State<ProceedSignUp> {
  /// local variable fields
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();

  final TextEditingController _controllerBio = TextEditingController();

  final TextEditingController _controllerType = TextEditingController();

  final TextEditingController _controllerCountry = TextEditingController();

  final TextEditingController _controllerCity = TextEditingController();

  final TextEditingController _controllerBloodGroup = TextEditingController();

  final TextEditingController _controllerPrice = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _userFormKey,
      child: formColumn(context),
    );
  }

  Widget formColumn(BuildContext context) {
    return ListView(
      children: [
        AppTextField(
          controller: _controllerCountry,
          hint: "Country",
        ),
        AppTextField(
          controller: _controllerCity,
          hint: "City",
        ),
        AppTextField(
          controller: _controllerBio,
          hint: "Bio",
          lines: 5,
        ),
        AppTextField(
          controller: _controllerPrice,
          hint: "Price",
        ),
        AppTextField(
          controller: _controllerBloodGroup,
          hint: "Blood Group",
        ),
        AppTextField(
          controller: _controllerType,
          hint: "Type",
        ),
        App.instance.button(context, child: const Text("Proceed"),
            onPressed: () {
          if (_userFormKey.currentState!.validate()) {
            App.instance.snackBar(context, text: "uploading data");
          }
        })
      ],
    );
  }

  Future<void> addUser(BuildContext context, {UserModel? userModel}) {
    return userReference
        .doc(userModel!.id.toString())
        .set(userModel.toJson())
        .then((value) => App.instance.snackBar(context, text: "User Added"))
        .catchError((error) => App.instance.snackBar(context,
            text: "Failed to add user: $error", bgColor: Colors.redAccent));
  }

  ///Cloud Firestore supports storing and manipulating
  /// values on your database, such as Timestamps, GeoPoints,
  /// Blobs and array management.
  Future<void> updateUserGeo() {
    return userReference
        .doc('ABC123')
        .update({'info.address.location': const GeoPoint(53.483959, -2.244644)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }



  ///Sometimes you may wish to update a document, rather than replacing all
  ///of the data. The set method above replaces any existing data on a given
  ///DocumentReference. If you'd like to update a document instead, use the
  ///update method:
  Future<void> updateUserNormal() {
    return userReference
        .doc('ABC123')
        .update({'company': 'Stokes and Sons'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
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
    // _controllerBio.dispose();
  }
}
