import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/screens/add_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';

class ShowDateWidget extends StatelessWidget {
  //constructor of model
  ShowDateWidget({required this.userModel});

  //initializing model class by adding its constructor
  final UserModel userModel;

  //function for deleting data
  deleteData(String id) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var doc = firestoreInstance //make a variable to get its id
        .collection('users')
        .doc(id);
    doc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: userModel
          .colors, //getting colors field present in model class to set color
      child: Column(
        children: <Widget>[
          ClipOval(
            child: Image(
              image: NetworkImage(
                userModel.image
              ),
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text(userModel.id),
          Text(userModel.firstname),
          Text(userModel.lastname),
          Text(userModel.email),
          Text(userModel.password),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) =>  // setting update button, on update it move to add screen with values saved in model class
                                  AddData(userModel: userModel)));
                },
                child: Icon(
                  Icons.update,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteData(userModel.id); //deleting data from model class wrt to id in userlist
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

            /// setting date in model class
          ),
        ],
      ),
    );
  }
}
