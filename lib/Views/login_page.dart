
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Controllers/auth/auth_controller.dart';
import '../Controllers/contants/values.dart';
import '../models/user_model.dart';
import 'constants/text_field.dart';
import 'constants/widgets.dart';
import 'dashboard.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final AuthController signCont = Get.put(AuthController());
  CollectionReference userRef = FirebaseFirestore.instance.collection(userDoc);
  final signGoogle = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
      ),
      body: Center(
        child: Obx(() {

          if (signCont.googleAccount.value == null) {
            return signInButton();
          } else {
            return ProceedSignUp(
              authData: signCont,


            );
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
      FirebaseFirestore.instance.collection(userDoc);

  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();

  final TextEditingController _controllerBio = TextEditingController();

  final TextEditingController _controllerType = TextEditingController();

  final TextEditingController _controllerCountry = TextEditingController();

  final TextEditingController _controllerCity = TextEditingController();

  final TextEditingController _controllerBloodGroup = TextEditingController();

  final TextEditingController _controllerPrice = TextEditingController();
  Future<DocumentSnapshot<Map<String, dynamic>>>? loadedData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///get the old users data
    loadedData=userReference.doc(widget.authData!.googleAccount.value!.id).get() as Future<DocumentSnapshot<Map<String, dynamic>>>?;

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
    return SingleChildScrollView(child: formColumn(context));
  }

  Widget formColumn(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
    future: userReference.doc(widget.authData!.googleAccount.value!.id).get(),
      builder: (context, snapshot) {
      if(snapshot.hasData){
        ///after Successful login
        ///app will load users data if exists
        ///and assign it to TextFields
        if(snapshot.data!.data()!=null){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          UserModel current=UserModel.fromMap(data);
          _controllerBloodGroup.text=current.group!;
          _controllerType.text=current.type!;
          _controllerPrice.text=current.rate!;
          _controllerBio.text=current.bio!;
          _controllerCity.text=current.city!;
          _controllerCountry.text=current.country!;
        }

      }

        return Form(
            key: _userFormKey,
            child: Column(
              children: [
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
                  inputType: TextInputType.name,
                  hint: "Price",
                ),
                AppTextField(
                  controller: _controllerBloodGroup,
                  inputType: TextInputType.name,
                  hint: "Blood Group",
                ),
                AppTextField(
                  controller: _controllerType,
                  inputType: TextInputType.name,
                  hint: "Type",
                ),
                AppTextField(
                  controller: _controllerBio,
                  hint: "Bio",
                  inputType: TextInputType.multiline,
                  expand: true,
                ),
                const SizedBox(
                  height: 50,
                ),
                App.instance.button(context, child: const Text("Proceed"),
                    onPressed: () async {
                  if (_userFormKey.currentState!.validate()) {
                    UserModel userData = UserModel(
                        id: widget.authData!.googleAccount.value!.id,
                        name: widget.authData!.googleAccount.value!.displayName,
                        country: _controllerCountry.text,
                        city: _controllerCity.text,
                        bio: _controllerBio.text,
                        rate: _controllerPrice.text,
                        type: _controllerType.text,
                        group: _controllerBloodGroup.text);
                    App.instance.snackBar(context, text: "Loading....");

                    await addUser(context, userModel: userData)
                        .then((value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard(
                                      authData:
                                          widget.authData!.googleAccount.value!,
                                    ))));
                  } else {
                    App.instance.snackBar(context,
                        text: "Something is Wrong", bgColor: Colors.red);
                  }
                })
              ],
            ));
      }
    );
  }

  Future<void> addUser(BuildContext context, {UserModel? userModel}) {
    return userReference
        .doc(userModel!.id)
        .set(userModel.toMap())
        .then((value) => App.instance.snackBar(context, text: "User Added"))
        .catchError((error) => App.instance.snackBar(context,
            text: "Failed to add user: $error", bgColor: Colors.redAccent));
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
