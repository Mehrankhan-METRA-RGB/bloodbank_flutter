import 'package:bloodbank/Controllers/coice_controller.dart';
import 'package:bloodbank/Controllers/contants/methods.dart';
import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/Controllers/geo_controller.dart';
import 'package:bloodbank/Views/constants/widgets.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class Room extends StatefulWidget {
  const Room({Key? key}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  GeoController geoController = Get.put(GeoController());

  ChoiceBloodController bloodController = Get.put(ChoiceBloodController());

  final databaseReference = FirebaseFirestore.instance;

  UserModel? localUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localUser = currentUserModel;
    // addToRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Interested Donors',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 50,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: databaseReference
              .collection(firebaseCollection)
              .doc(localUser?.id)
              .collection(firebaseSubCollection)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.isEmpty
                      ? 1
                      : snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Map<String, dynamic>>? dox;
                    UserModel? dt;
                    if (snapshot.data!.docs.isNotEmpty) {
                      dox = snapshot.data?.docs[index];
                      dt = UserModel.fromMap(dox!.data());
                    }

                    return snapshot.data!.docs.isEmpty
                        ? const Center(
                      child: Text('No Donors'),
                    )
                        : Card(
                      color: Colors.red,
                      child: ExpansionTile(
                          collapsedTextColor: Colors.white,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          title: Text(
                            dt!.name ?? ' ',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          subtitle: Text(
                            dt.city ?? ' ',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          childrenPadding: const EdgeInsets.all(15),
                          leading: Text(
                            dt.group ?? ' ',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          trailing: InkWell(
                            onTap: () => App.instance.dialog(context,
                                content: const Text(
                                    'Are you sure to mark this person as donor'),
                                onDonePressed: () {
                                  ///if already marked as donated then don't mark it again
                                  dt!.isAvailableForDonation ?? false
                                      ? null
                                      : _addButtonClick(dt);
                                  Navigator.of(context).pop();
                                }, title: 'Dialog'),
                            child: Image.asset(
                              'assets/images/mark_as_donor.png',
                              width: 35,
                              height: 44,
                              color: dt.isAvailableForDonation ?? false
                                  ? const Color(0xff379a10)
                                  : Colors.white54,
                            ),
                          ),
                          children: [
                            const Divider(),
                            ListTile(
                              title: Row(
                                children: [
                                  Text('${phoneWithDialCode(dt.country!,dt.phone!)}'),
                                  const Spacer(),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => Methods.instance
                                          .makeCall(phoneWithDialCode(dt!.country!,dt.phone!))),
                                ],
                              ),
                              textColor: Colors.white,
                              trailing: IconButton(
                                  icon: const Icon(
                                    Icons.sms,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Methods.instance
                                      .sendSMSTo(phoneWithDialCode(dt!.country!,dt.phone!))),
                            ),
                            ListTile(
                              title: Text(dt.email ?? ' '),
                              textColor: Colors.white,
                              trailing: IconButton(
                                  icon: const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Methods.instance
                                      .sendMail(dt!.email)),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                  child: Text(dt.bio ?? ' ',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ))),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => App.instance.dialog(
                                        context,
                                        content: const Text(
                                            'Are you sure to delete this person from current room?'),
                                        onDonePressed: () {
                                          _deleteDonor(dt!.id!);
                                          Navigator.of(context).pop();
                                        }, title: 'Alert')),
                              ],
                            ),
                          ]),
                    );
                  });
            } else if (!snapshot.hasData) {
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => Container(
                  height: 75,
                  width: MediaQuery.of(context).size.width,
                  margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: const Color.fromARGB(20, 30, 56, 90),
                ),
              );
            } else if (snapshot.hasError) {
              return const CircularProgressIndicator();
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  void saveDonorsLocally(Map<String,dynamic> value) {

    UserModel oldval=UserModel.fromMap(value);
    final newVal=UserModel(id: oldval.id,name: oldval.name,group: oldval.group,country: oldval.country,phone: oldval.phone,email: oldval.email).toJson();

    // Hive.box(yourDonorsBox).deleteAll(Hive.box(yourDonorsBox).keys);
    Hive.box(yourDonorsBox).add(newVal).whenComplete(
          () => App.instance.snackBar(
        context,
        text: 'History Saved',
        bgColor: Colors.deepPurple,
      ),
    );
  }

  void markDonorAsDonatedBlood(String userId, {UserModel? user}) {
    ///Update profile in a room
    databaseReference
        .collection(firebaseCollection)
        .doc(localUser?.id)
        .collection(firebaseSubCollection)
        .doc(userId)
        .update({
      'isAvailableForDonation': true,
      'lastTimeDonated': DateTime.now(),

    });

    ///update user actual profile of a donor
    databaseReference
        .collection(firebaseCollection)
        .doc(userId)
        .get()
        .then((value) {
      int? donates = UserModel.fromMap(value.data()!).totalDonations;
      databaseReference
          .collection(firebaseCollection)
          .doc(userId)
          .update({
        'lastTimeDonated': DateTime.now(),
        'totalDonations': (donates ?? 0) + 1
      })
          .whenComplete(() => App.instance
          .snackBar(context, text: 'Updated', bgColor: Colors.deepPurple))
          .catchError((error) => App.instance.snackBar(context,
          text: 'Failed:$error', bgColor: Colors.yellow));
    });
  }

  void _deleteDonor(String donorId) async {
    await FirebaseFirestore.instance
        .collection(firebaseCollection)
        .doc(localUser?.id)
        .collection(firebaseSubCollection)
        .doc(donorId)
        .delete()
        .then((snap) => App.instance.snackBar(context,
        text: '$donorId has been deleted', bgColor: Colors.deepPurple)
      // print('$donorId has been deleted');
    );
  }

  void _addButtonClick(UserModel? dt) {

    saveDonorsLocally(dt!.toMap());
    markDonorAsDonatedBlood(dt.id!);
  }
}
