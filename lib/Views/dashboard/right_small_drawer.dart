import 'dart:math';
import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/Views/dashboard/donors_room.dart';
import 'package:bloodbank/Views/dashboard/join_room.dart';
import 'package:bloodbank/Views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hive/hive.dart';
import '../../Controllers/auth/auth_controller.dart';
import '../constants/widgets.dart';
import 'profile.dart';
import 'history.dart';

class RightDrawer extends StatelessWidget {
  RightDrawer({Key? key}) : super(key: key);
  final AuthController googleController = Get.put(AuthController());

  final random = Random();
  final databaseReference = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: 75,
          height: MediaQuery.of(context).size.height,
          color: Colors.redAccent.withOpacity(0.98),
          padding:
              const EdgeInsets.only(top: 30, right: 2, left: 2, bottom: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserProfile()));
                  },
                  child: CircleAvatar(
                    foregroundImage:currentUserModel?.url!=null? NetworkImage(currentUserModel!.url!):null,
                    backgroundColor: Colors.grey,
                  )),
              const SizedBox(
                height: 15,
              ),
              imageButton(
                  imageAssetPath: 'assets/icons/people.png',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Room()));
                  },
                  iconColor: Colors.white),
              imageButton(
                  imageAssetPath: 'assets/icons/add-friend.png',
                  onTap: () => JoinRoom.instance.show(context),
                  iconColor: Colors.white),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReceiveHistory())),
                icon: const Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              IconButton(
                onPressed: () => signOut(context),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          )),
    );
  }

  Widget imageButton({
    required String imageAssetPath,
    required Function() onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15),
        child: Image.asset(
          imageAssetPath,
          width: 25,
          height: 37,
          color: iconColor ?? Colors.white70,
        ),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    googleController.logout();
    Hive.box(authBox).delete(authBoxCredentialsKey);
    Hive.boxExists(yourDonorsBox).then((exist) => exist
        ? Hive.box(yourDonorsBox).deleteAll(Hive.box(yourDonorsBox).keys)
        : null);
    Hive.box(authBox).containsKey(authBoxDataKey)
        ? Hive.box(authBox).delete(authBoxDataKey)
        : null;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
