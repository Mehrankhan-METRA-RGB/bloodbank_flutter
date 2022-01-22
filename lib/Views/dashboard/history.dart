import 'dart:convert';
import 'package:bloodbank/Views/constants/widgets.dart';
import 'package:bloodbank/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Controllers/contants/values.dart';

class ReceiveHistory extends StatefulWidget {
  const ReceiveHistory({Key? key}) : super(key: key);

  @override
  State<ReceiveHistory> createState() => _ReceiveHistoryState();
}

class _ReceiveHistoryState extends State<ReceiveHistory> {
  List<UserModel> get listOfHistory => Hive.box(yourDonorsBox)
      .values
      .map((map) => UserModel.fromMap(jsonDecode(map)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'History',
            style: style(size: 20),
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
            listOfHistory.isNotEmpty? MaterialButton(
              onPressed: () {
                App.instance.dialog(context,
                    title: 'Alert',
                    content: const Text('Are you to delete all history?'),
                    onDonePressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Hive.box(yourDonorsBox)
                        .deleteAll(Hive.box(yourDonorsBox).keys)
                        .whenComplete(() => App.instance.snackBar(context,
                            text: 'All Data Cleared',
                            bgColor: Colors.deepPurple));
                  });

                });
              },
              child: const Text(
                'Clear All',
                style: TextStyle(fontSize: 10),
              ),
            ):const SizedBox()
          ],
        ),
        body: ListView.builder(
            itemCount:listOfHistory.isNotEmpty? listOfHistory.length:1,
            itemBuilder: (context, index) {
              UserModel u = listOfHistory.isNotEmpty?listOfHistory[index >= 1 ? index - 1 : 0]:UserModel();

              return listOfHistory.isNotEmpty
                  ?ListTile(
                  title: Text(
                    '${u.name ?? ' '} donated you ${u.group ?? ' '} ',
                    style: style(),
                  ),
                  subtitle: Text(
                    '${u.email ?? ' '}\n${phoneWithDialCode(u.country!,u.phone!)}',
                    style: style(color: Colors.black38, size: 10),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        Hive.box(yourDonorsBox)
                            .deleteAt(index - 1)
                            .whenComplete(() => App.instance.snackBar(context,
                                text: 'Deleted', bgColor: Colors.deepPurple));
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 15,
                      color: Colors.black54,
                    ),
                  ),
                  style: ListTileStyle.list,
                  minVerticalPadding: 4)
                  :Container(height: 200,alignment: Alignment.bottomCenter,
              child:const Text('No History'),);
            }));
  }

  TextStyle style({Color color = Colors.black87, double size = 12}) =>
      TextStyle(
        color: color,
        fontSize: size,
      );
}
