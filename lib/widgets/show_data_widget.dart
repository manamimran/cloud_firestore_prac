import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/screens/add_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

class ShowDateWidget extends StatelessWidget {
  final UserModel userModel;

  ShowDateWidget({required this.userModel});

  deleteData(String id) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var doc = firestoreInstance //make a variable to get its id
        .collection('users')
        .doc(id);
    doc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: userModel.colors,
        child: Column(
          children: <Widget>[
            Text(userModel.id),
            Text(userModel.firstname),
            Text(userModel.lastname),
            Text(userModel.email),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddData(userModel: userModel)));
                  },
                  child: Icon(
                    Icons.update,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteData(userModel.id);
                  },
                  child: Icon(
                    Icons.delete,
                  ),
                )
              ],
            ),
            Text(
              DateFormat("MMM dd,yyyy")
                  .format(DateTime.fromMillisecondsSinceEpoch(userModel.date)),
            ),
          ],
        ),
      );
  }

}
