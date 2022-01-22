import 'dart:io';

import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/models/phone_number_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controllers/blood_controller.dart';
import '../../models/user_model.dart';
import '../blood_board.dart';
import '../constants/small_tiles.dart';

class Donors extends StatelessWidget {
  Donors({required this.users, this.userBloodGroup, this.userCity, Key? key})
      : super(key: key);
  List<UserModel?> users;
  String? userBloodGroup;
  String? userCity;
  final double _iconSize = 14;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Container(
        height: MediaQuery.of(context).size.height,
        width: 140,
        color: Colors.red,
        child: ListView(
          shrinkWrap: true,
          children: [
          const  SizedBox(height: 35,),
            ListTile(
              autofocus: true,
              focusColor: Colors.yellow,
              style: ListTileStyle.drawer,
              title: const Text(
                'Blood Board ',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              // leading: const Icon(
              //   Icons.bloodtype,
              //   color: Colors.white,
              // ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BloodBoard()));
              },
            ),
            ListTile(
              style: ListTileStyle.drawer,
              title: const Text(
                'Send To All',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              // leading: const Icon(
              //   Icons.send,
              //   color: Colors.white,
              // ),
              onTap: _sendSMSToAll,
            ),
          ],
        ),
      ),
      body: CardSliverAppBar(
        height: 150,
        background: Image.asset(
          'assets/images/donors.png',
          fit: BoxFit.cover,
        ),
        title: Text(userBloodGroup!,
            style: Theme.of(context).textTheme.titleLarge),
        titleDescription: Text(
          "Accept: ${BloodController.instance.receiveFrom(userBloodGroup)!.length == bloodGroups!.length ? 'Every One' : BloodController.instance.receiveFrom(userBloodGroup)!.toString().replaceAll('[', ' ').replaceAll(']', ' ').replaceAll(',', ' | ')}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        card: const AssetImage('assets/images/transparent.png'),
        backButton: true,
        backButtonColors: const [Colors.white70, Colors.red, Colors.blueAccent],
        action: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Text(userCity!),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.only(top: 35, bottom: 100),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel? snap = users[index];

              List<PhoneModel> _phone =
                  countries.map((map) => PhoneModel.fromMap(map)).toList();
              PhoneModel filteredPhone = _phone
                  .singleWhere((element) => element.name == snap?.country);
              String? code = '+${filteredPhone.dialCode}';

              return Card(
                color: Colors.red,
                child: ExpansionTile(
                    collapsedTextColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    title: Text(
                      snap!.name!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      snap.city!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    childrenPadding: const EdgeInsets.all(15),
                    leading: Text(
                      snap.group!,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SmallTile(
                            title: 'Stars',
                            value: '${(snap.totalDonations ?? 0) * 8.5}',
                            isBlackTheme: false,
                            icon: Icons.star,
                            scale: 1.5,
                            height: 40,
                          ),
                          SmallTile(
                            isBlackTheme: false,
                            title: 'Donations',
                            value: '${snap.totalDonations ?? 0}',
                            icon: Icons.people,
                            scale: 1.5,
                            height: 40,
                          )
                        ],
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Text('$code${snap.phone}'),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.phone,
                                size: _iconSize,
                                color: Colors.white,
                              ),
                              onPressed: () => _makeCall('$code${snap.phone}'),
                            ),
                          ],
                        ),
                        textColor: Colors.white,
                        trailing: IconButton(
                          icon: Icon(
                            Icons.sms,
                            size: _iconSize,
                            color: Colors.white,
                          ),
                          onPressed: () => _sendSMS('$code${snap.phone}',
                              'Urgent need $bloodGroups for $userBloodGroup \nJoin Room if interested to donate blood\nRoomId: $generateRoomId'),
                        ),
                      ),
                      ListTile(
                        title: Text(snap.email ?? ' '),
                        textColor: Colors.white,
                        trailing: IconButton(
                          icon: Icon(
                            Icons.email,
                            size: _iconSize,
                            color: Colors.white,
                          ),
                          onPressed: () => _sendMail(snap.email),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                            child: Text(snap.bio ?? ' ',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ))),
                      )
                    ]),
              );
            }),
      ),
      // FloatingActionButton(backgroundColor:Colors.deepPurple,
      //   child: const Icon(Icons.bloodtype),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => BloodBoard()));
      //   },
      // ),
    );
  }

  _sendMail(String? mail) async {
    var url =
        'mailto:$mail?subject=Donate Blood Save Lives&body=Urgent need $bloodGroups for $userBloodGroup \nJoin! to donate blood to Recipient\nRoomId: $generateRoomId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendSMS(String? phoneNo, String body) async {
    var url = "sms:$phoneNo?body=$body";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    // Android
  }

  _makeCall(String? phoneNo) async {
    var url = "tel://+$phoneNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _sendSMSToAll() async {
    List<PhoneModel> _phone =
        countries.map((map) => PhoneModel.fromMap(map)).toList();

    List<String>? donorsNumbers = [];
    String message =
        'Donate Blood Save Lives&body=Urgent need $bloodGroups for $userBloodGroup \nJoin! to donate blood to Recipient\nRoomId: $generateRoomId';
    for (var element in users) {
      PhoneModel filteredPhone =
          _phone.singleWhere((filter) => filter.name == element?.country);
      String? code = '+${filteredPhone.dialCode}';

      donorsNumbers.add('$code${element!.phone!}');
    }

    String _result = await sendSMS(message: message, recipients: donorsNumbers)
        .catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
    if (kDebugMode) {
      print(_result);
    }
  }
}

///'mailto:admin@fluttercentral.com?subject=Sample Subject&body=This is a Sample email'
