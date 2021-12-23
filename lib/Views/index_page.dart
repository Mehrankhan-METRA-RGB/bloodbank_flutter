// import 'dart:async';
//
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import '../Controllers/auth/auth_controller.dart';
// import 'dashboard.dart';
// import 'login_page.dart';
//
// class Index extends StatefulWidget {
//    Index({Key? key}) : super(key: key);
//
//   @override
//   State<Index> createState() => _IndexState();
// }
//
// class _IndexState extends State<Index> {
//   final AuthController signCont = Get.put(AuthController());
//   final GoogleSignIn signGoogle= GoogleSignIn();
//   String _connectionStatus = 'Unknown';
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     router(context);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const CircularProgressIndicator();
//   }
//
//   router(BuildContext context)async{
//
//     if(await signGoogle.isSignedIn()){
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Dashboard()));
//
//     }else{
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
//     }
//
//   }
// }
