import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.red,
      //   elevation: 0,
      // ),
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              padding: const EdgeInsets.only(top: 35,bottom: 100),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel? snap = users[index];
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
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SmallTile(
                              title: 'Stars',
                              value: '79,969',
                              isBlackTheme: false,
                              icon: Icons.star,
                              scale: 1.5,
                              height: 40,
                            ),
                            SmallTile(
                              isBlackTheme: false,
                              title: 'Donations',
                              value: '28,99',
                              icon: Icons.people,
                              scale: 1.5,
                              height: 40,
                            )
                          ],
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text(snap.phone!),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                onPressed: () => _makeCall(snap.phone),
                              ),
                            ],
                          ),
                          textColor: Colors.white,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.sms,
                              color: Colors.white,
                            ),
                            onPressed: () => _sendSMS(snap.phone),
                          ),
                        ),
                        ListTile(
                          title: Text(snap.email!),
                          textColor: Colors.white,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            onPressed: () => _sendMail(snap.email),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                              child: Text(snap.bio!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ))),
                        )
                      ]),
                );
              }),
        ),
      ),

      floatingActionButton: FloatingActionButton(backgroundColor:Colors.deepPurple,
        child: const Icon(Icons.bloodtype),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BloodBoard()));
        },
      ),
    );
  }

  _sendMail(String? mail) async {
    var url = 'mailto:$mail';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendSMS(String? phoneNo) async {
    var url = "sms:$phoneNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _makeCall(String? phoneNo) async {
    var url = "tel://+$phoneNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
