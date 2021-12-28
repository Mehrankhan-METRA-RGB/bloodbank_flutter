import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Controllers/auth/auth_controller.dart';
import '../Controllers/contants/values.dart';
import 'dashboard/proceed_signup_form.dart';

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
              currentUser: signCont.googleAccount.value,
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

