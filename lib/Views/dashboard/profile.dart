import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/Controllers/phone_controller.dart';
import 'package:bloodbank/Views/dashboard/update_profile.dart';
import 'package:bloodbank/models/credentials_model.dart';
import 'package:bloodbank/models/phone_number_model.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/countries.dart';
import '../../Controllers/auth/auth_controller.dart';
import '../constants/small_tiles.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Credentials? localData;
  final AuthController googleController = Get.put(AuthController());
  final CollectionReference reference =
      FirebaseFirestore.instance.collection(firebaseCollection);
  final PhoneNumberController _phoneNumberController =
      Get.put(PhoneNumberController());
  UserModel? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localData =
        Credentials.fromJson(Hive.box(authBox).get(authBoxCredentialsKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // toolbarHeight: 45,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            onPressed: edit,
            icon:const Icon(Icons.edit,color: Colors.black87,),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(0.98),
        padding: const EdgeInsets.only(top: 30, right: 0, left: 0, bottom: 1),
        child: StreamBuilder<DocumentSnapshot>(
            stream: reference.doc(localData!.id).snapshots(),
            builder: (context, snap) {
              if (snap.hasData) {
                Map<String, dynamic> data =
                    snap.data!.data() as Map<String, dynamic>;
                user = UserModel.fromMap(data);
                List<PhoneModel> _phone =
                    countries.map((map) => PhoneModel.fromMap(map)).toList();
                PhoneModel filteredPhone = _phone
                    .singleWhere((element) => element.name == user?.country);
                _phoneNumberController.countryDialCode.value =
                    filteredPhone.dialCode.toString();

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
                            foregroundImage: NetworkImage(localData!.photoUrl!),
                          )),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmallTile(
                              value: user?.totalDonations.toString(),
                              icon: Icons.people,
                              title: "Donated",
                            ),
                            SmallTile(
                              value: '${(user?.totalDonations??0)*8.5}',
                              icon: Icons.star,
                              title: "Stars",
                            ),

                          ],
                        )),
                    Container(
                      color: Colors.grey,
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(
                            user!.id!,
                            style: Theme.of(context).textTheme.bodySmall,
                            textScaleFactor: 0.8,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child:
                          _profileData(user!, code: '+${filteredPhone.dialCode}'),
                    )
                  ],
                );
              } else if (!snap.hasData) {
                return const ProfileShimmers();
              } else {
                return const ProfileShimmers();
              }
            }),
      ),
    );
  }

  Widget _tile({String? heading, String? value, double scale = 0.8}) =>
      SizedBox(
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              title: Text(
                heading ?? "heading",
                textScaleFactor: scale + 0.1,
              ),
              subtitle: Text(value ?? "null", textScaleFactor: scale),
            ),
            const Divider(
              height: 1,
            )
          ],
        ),
      );

  Widget _profileData(UserModel user, {String? code}) {
    return ListView(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 20),
      children: [
        _tile(heading: "Bio", value: user.bio, scale: 0.9),
        _tile(
          heading: "Name",
          value: user.name,
        ),
        _tile(
          heading: "Phone",
          value: '$code ${user.phone}',
        ),
        _tile(
          heading: "Email",
          value: user.email,
        ),
        _tile(
          heading: "Country",
          value: user.country,
        ),
        _tile(
          heading: "City",
          value: user.city,
        ),
        _tile(
          heading: "Blood Group",
          value: user.group,
        ),
        _tile(
          heading: "Account type",
          value: user.type,
        ),
        _tile(
          heading: "Price/100mL",
          value: user.price,
        ),
      ],
    );
  }


  edit() {
    // AuthController authController=Get.put(AuthController());

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UpdateProfile(
        currentUser: localData,
      );
    }));
  }
}

class ProfileShimmers extends StatelessWidget {
  const ProfileShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
              child: const CircleAvatar(
                backgroundColor: Color(0xffd4d1d1),
                foregroundColor: Color(0xffd5d3d3),
                foregroundImage: AssetImage('assets/images/transparent.png'),
              )),
        ),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallTile(
                  value: ' ',
                  icon: Icons.people,
                  title: "Donated",
                ),
                SmallTile(
                  value: ' ',
                  icon: Icons.star,
                  title: "Ratings",
                ),
                SmallTile(
                  value: ' ',
                  icon: Icons.build,
                  title: "Coming",
                ),
              ],
            )),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                  height: 30,
                  width: 120,
                  child: ColoredBox(
                    color: Color(0xffcdc9c9),
                  ))
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: ListView(
            padding:
                const EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 20),
            children: [
              _shimmerTile(height: 100),
              _shimmerTile(),
              _shimmerTile(),
              _shimmerTile(),
              _shimmerTile(),
              _shimmerTile(),
              _shimmerTile(),
              _shimmerTile(),
              _shimmerTile(),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.meeting_room_sharp),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.logout),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _shimmerTile({
    Color color = const Color(0xffcdc9c9),
    double height=28
  }) =>
      SizedBox(
        child: Column(
          children: [
            ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                title: SizedBox(
                  height: 16,
                  width: 40,
                  child: ColoredBox(
                    color: color,
                  ),
                ),
                subtitle: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  height: height,
                  width: 130,
                  color: color,
                ),),
            const Divider(
              height: 1,
            )
          ],
        ),
      );
}
