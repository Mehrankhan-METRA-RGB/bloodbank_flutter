import 'package:bloodbank/Controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'constants/widgets.dart';

class Dashboard extends StatefulWidget {
  Dashboard({required this.authData, Key? key}) : super(key: key);
  final GoogleSignInAccount? authData;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController googleController=Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ClipOval(
            //     child: googleController.googleAccount.value!.photoUrl != null
            //         ? Image.network(googleController.googleAccount.value!.photoUrl!)
            //         : Text("No Img"),
            //   ),
            // )
          ],
        ),
        drawer: Drawer(child: Column(mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          App.instance.button(context, child:const Text("Logout"), onPressed: ()=>googleController.logout())
        ],),),
        body: const Center(
          child: Text("Dashboard"),
        ));
  }




}

