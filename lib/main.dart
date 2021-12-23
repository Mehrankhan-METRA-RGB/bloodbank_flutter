import 'package:bloodbank/Controllers/auth/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Views/dashboard.dart';
import 'Views/index_page.dart';
import 'Views/login_page.dart';
// final AuthController authController=Get.put(AuthController());
final GoogleSignIn signGoogle = GoogleSignIn();
bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  ///Firebase Initializations for application
  ///
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // signGoogle.signOut();
  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  ///Check if user is Already logged In or not
  if (await signGoogle.isSignedIn()) {
    runApp(const MyApp(
      isAlreadyLoggedIn: true,
    ));
  } else {
    runApp(const MyApp(isAlreadyLoggedIn: false));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({required this.isAlreadyLoggedIn, Key? key}) : super(key: key);
  final bool isAlreadyLoggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isAlreadyLoggedIn ?  Dashboard(authData: signGoogle.currentUser,) : Login(),
    );
  }
}
