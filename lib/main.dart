import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Views/login_page.dart';


  bool shouldUseFirestoreEmulator = false;

  Future<void> main() async {


    ///Firebase Initializations for application
    ///
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    if (shouldUseFirestoreEmulator) {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(


        primarySwatch: Colors.blue,
      ),
      home:   Login(),
    );
  }
}

