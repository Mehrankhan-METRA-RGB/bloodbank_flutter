import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/Controllers/phone_controller.dart';
import 'package:bloodbank/Views/dashboard/proceed_signup_form.dart';
import 'package:bloodbank/Views/dashboard/update_profile.dart';
import 'package:bloodbank/models/credentials_model.dart';
import 'package:bloodbank/models/phone_number_model.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/countries.dart';

import '../../Controllers/auth/auth_controller.dart';
import '../blood_board.dart';
import '../constants/small_tiles.dart';
import '../login_page.dart';

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({Key? key}) : super(key: key);

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}




class _DashboardDrawerState extends State<DashboardDrawer> {
  Credentials? localData;
  final AuthController googleController=Get.put(AuthController());
  final CollectionReference reference =
  FirebaseFirestore.instance.collection(userDoc);
  final PhoneNumberController _phoneNumberController=Get.put(PhoneNumberController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localData= Credentials.fromJson(Hive.box(authBox).get(authBoxCredentialsKey)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      height: MediaQuery.of(context).size.height,
      color: Colors.white.withOpacity(0.98),
      padding: const EdgeInsets.only(top: 30, right: 0, left: 0, bottom: 1),
      child:FutureBuilder<DocumentSnapshot>(

          future: reference.doc(localData!.id).get(),
          builder: (context,snap){



if(snap.hasData){
  Map<String, dynamic> data =
  snap.data!.data() as Map<String, dynamic>;
  UserModel user=UserModel.fromMap(data);
  List<PhoneModel>  _phone=     countries.map((map) => PhoneModel.fromMap(map)).toList();
  PhoneModel filteredPhone= _phone.singleWhere((element) => element.name==user.country);
  _phoneNumberController.countryDialCode.value=filteredPhone.dialCode.toString();

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        flex: 2,
        child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                  localData!.photoUrl!
              ),
            )),),
      Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              SmallTile(
                value: user.totalDonations.toString(),
                icon: Icons.people,
                title: "Donated",
              ),
              SmallTile(
                value: user.rating.toString(),
                icon: Icons.star,
                title: "Ratings",
              ),
              SmallTile(
                value: user.nextDonation.toString(),
                icon: Icons.build,
                title: "Coming",
              ),
            ],
          )),
      Container(color: Colors.grey,
        padding:const EdgeInsets.all(3),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(user.id!,
              style: Theme.of(context).textTheme.bodySmall,
              textScaleFactor: 0.8,),
          ],
        ),
      ),

      Expanded(
        flex: 5,
        child:
            _profileData(user,code:'+${filteredPhone.dialCode}'),


      )
    ],
  );
}
else if(!snap.hasData){
  return const Center(child: CircularProgressIndicator());
}
else{
  return const Center(child: CircularProgressIndicator());
}




          }
      ),
    );
  }

  Widget _tile({String? heading, String? value, double scale = 0.8}) =>
      SizedBox(
        child: Column(
          children: [
            ListTile(contentPadding:const EdgeInsets.symmetric(horizontal: 10,vertical: 2),

              title: Text(
                heading ?? "heading",
                textScaleFactor: scale + 0.1,
              ),
              subtitle: Text(value ?? "null", textScaleFactor: scale),
            ),
            const Divider(height: 1,)
          ],
        ),
      );

  Widget _profileData(UserModel user, {String? code}) {


    return ListView(
padding:const EdgeInsets.only(right: 15,left: 15,top:5,bottom: 20),
      children: [


        _tile(
            heading:"Bio",
            value: user.bio,
            scale: 0.9
        ),
        _tile(
          heading:"Name",
          value: user.name,
        ),
        _tile(
          heading:"Phone",
          value: '$code ${user.phone}',
        ),
        _tile(
          heading:"Email",
          value: user.email,
        ),
        _tile(
          heading:"Country",
          value: user.country,
        ),
        _tile(
          heading:"City",
          value: user.city,
        ),
        _tile(
          heading:"Blood Group",
          value: user.group,
        ),
        _tile(
          heading:"Account type",
          value: user.type,
        ),
        _tile(
          heading:"Price/100mL",
          value: user.price,
        ),


        SizedBox(height: 60,
          child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [
            MaterialButton(onPressed: edit,child:const Text("Edit"),),
            MaterialButton(onPressed: signOut,child:const Text("Logout"),),
          ],),
        )

      ],
    );
  }
  ///This will LogOut user from application
  Future<void> signOut()async{
    googleController.logout();
    Hive.box(authBox).delete(authBoxCredentialsKey);
    Hive.box(authBox).containsKey(authBoxDataKey)?
    Hive.box(authBox).delete(authBoxDataKey):null;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));

  }
  edit(){
    // AuthController authController=Get.put(AuthController());

    Navigator.push(context, MaterialPageRoute(builder: (context){return
      UpdateProfile(currentUser:localData,);

    }));
  }
}
