import 'dart:io';

import 'package:bloodbank/models/credentials_model.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathF;
import 'Controllers/contants/values.dart';
import 'Views/dashboard/dashboard.dart';
import 'Views/login_page.dart';

// final AuthController authController=Get.put(AuthController());
final GoogleSignIn signGoogle = GoogleSignIn();
bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathF.getApplicationDocumentsDirectory();

  ///Hive initiated
  Hive.init(directory.path);
  await Hive.openBox(authBox);

  ///Firebase Initializations for application
  await Firebase.initializeApp();
  // signGoogle.signOut();
  // Hive.box(authBox).delete(authBoxCredentialsKey);
  // Hive.box(authBox).containsKey(authBoxDataKey)?
  // Hive.box(authBox).delete(authBoxDataKey):null;
  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
/// Remove Account if closed before adding users data [UserModel]
  !Hive.box(authBox).containsKey(authBoxCredentialsKey)?signGoogle.signOut():null;

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
  Credentials _credentials() {


    return isAlreadyLoggedIn?Credentials
        .fromJson(Hive.box(authBox)
        .get(authBoxCredentialsKey)):Credentials();
  }
  UserModel user(){

  if(isAlreadyLoggedIn){
    UserModel model=UserModel
        .fromJson(Hive.box(authBox)
        .get(authBoxDataKey));
    return model;
  }else{
    return   UserModel();
  }

}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonBarTheme:ButtonBarThemeData() ,
        // appBarTheme: AppBarTheme(color: Colors.red,
        //   elevation: 0,
        //   backgroundColor: Colors.red,
        //   iconTheme: const IconThemeData(color: Colors.white,),
        // toolbarTextStyle:const TextStyle(fontSize: 20,color: Colors.white)
        // ) ,

        cardColor: Colors.red,
        accentColor: Colors.redAccent,

        primaryColor: Colors.red,
      ),
      home:
      // const DashboardMap()
      // Test1(),
      // Test2(user:user() ,)
       // UpdateProfile(currentUser: _credentials(),)



      isAlreadyLoggedIn
          ? Dashboard(user:user(),

            )
          : Login(),
    );
  }
}
