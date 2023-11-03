import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';

class AddData extends StatefulWidget {
  AddData({super.key, this.userModel});
  final UserModel? userModel;

  @override
  State<AddData> createState() =>_DataShowState();
}

class _DataShowState extends State<AddData> {
  var firstname_control = TextEditingController();
  var lastname_control = TextEditingController();
  var email_control = TextEditingController();
  Color? colors;
  DateTime date = DateTime.now();

  @override
  void initState() {
    if (widget.userModel != null) {
      firstname_control.text = widget.userModel!.firstname;
      lastname_control.text = widget.userModel!.lastname;
      email_control.text = widget.userModel!.email;
      date = DateTime.fromMillisecondsSinceEpoch(widget.userModel!.date);
      super.initState();
    }
  }

  Future<DateTime?> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('User List'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.userModel == null ? "Add User" : "Update User"),
              TextField(
                controller:firstname_control,
                decoration: InputDecoration(hintText: "First"),
              ),
              TextField(
                controller: lastname_control,
                decoration: InputDecoration(hintText: "Lastname"),
              ),
              TextField(
                controller: email_control,
                decoration: InputDecoration(hintText: "Email"),
              ),
              ColorPicker(
                pickerColor: colors ?? Colors.white,
                onColorChanged: (Color color) {
                  colors = color;
                },
                colorPickerWidth: 300.0,
                pickerAreaHeightPercent: 0.2,
              ),
              InkWell(
                onTap: () async {
                  var d = await getDate();
                  if (d != null) {
                   date = d;
                    setState(() {});
                  }
                },
                child: Text(
                  DateFormat("MMM dd, yyyy").format(date),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var doc = FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.userModel?.id);

                  var userModel = UserModel(
                      doc.id,
                   firstname_control.text,
                     lastname_control.text,
                     email_control.text,
                      date.millisecondsSinceEpoch,
                      colors! );
                 // colors;

                  await doc.set(userModel.toMap());

                  Navigator.pop(
                    context,
                    colors,
                  );
                },
                child: Text("Save"),

              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     colors;
              //     Navigator.of(context).pop();
              //   },
              //   child: Text("Change Color"),
              //
              // )
            ],
          ),
        ),
      ),
    );
  }


}
