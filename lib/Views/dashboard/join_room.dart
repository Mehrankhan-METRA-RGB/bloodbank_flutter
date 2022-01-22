import 'package:bloodbank/Controllers/contants/values.dart';
import 'package:bloodbank/Views/constants/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/text_field.dart';

class JoinRoom {
  JoinRoom._private();
  static final JoinRoom instance = JoinRoom._private();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final _databaseReference = FirebaseFirestore.instance;

  show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          title: const Text('Room'),
          content: Form(
            key: _formKey,
            child: AppTextField(
              hint: 'Room id',
              controller: _textController,
              onChange: (a) {},
            ),
          ),
          actions: [
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Text('Join'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addToRoom(context,_textController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }
///room will be in this form 65352_1234567890123456_room
  Future _addToRoom(BuildContext context,String roomUserId) async {
    String id=roomUserId.split('_')[1];
    _databaseReference
        .collection(firebaseCollection)
        .doc(currentUserModel?.id).get().then((snap) {

      _databaseReference
          .collection(firebaseCollection)
          .doc(id).collection(firebaseSubCollection)
          .doc(currentUserModel?.id)
          .set(snap.data()!)
          .whenComplete(() => App.instance.snackBar(context,
      text: "You are Added to Room", bgColor: Colors.deepPurple).whenComplete(() => Navigator.pop(context)))
          .catchError((error) => App.instance.snackBar(context,
      text: "Failed: $error", bgColor: Colors.redAccent));
    });
    }

}
