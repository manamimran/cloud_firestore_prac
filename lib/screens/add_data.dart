import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AddData extends StatefulWidget {
  AddData({super.key, this.userModel});

  var firstname_control = TextEditingController();
  var lastname_control = TextEditingController();
  var email_control = TextEditingController();
  DateTime date = DateTime.now();
  final UserModel? userModel;

  @override
  State<AddData> createState() => _DataShowState();

}

class _DataShowState extends State<AddData> {
  @override
  void initState() {

    if (widget.userModel != null) {
      widget.firstname_control.text = widget.userModel!.firstname;
      widget.lastname_control.text = widget.userModel!.lastname;
      widget.email_control.text = widget.userModel!.email;
      widget.date = DateTime.fromMillisecondsSinceEpoch(widget.userModel!.date);
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.userModel == null ? "Add User" : "Update User"),
            TextField(
              controller: widget.firstname_control,
              decoration: InputDecoration(hintText: "First"),
            ),
            TextField(
              controller: widget.lastname_control,
              decoration: InputDecoration(hintText: "Lastname"),
            ),TextField(
              controller: widget.email_control,
              decoration: InputDecoration(hintText: "Email"),
            ),
            InkWell(
              onTap: () async {
                var d = await getDate();
                if (d != null) {
                  widget.date = d;
                  setState(() {});
                }
              },
              child: Text(
                DateFormat("MMM dd, yyyy").format(widget.date),
              ),
            ),
            ElevatedButton(
              onPressed: () async {

                var doc = FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.userModel?.id);

                var userModel = UserModel(
                    doc.id,
                    widget.firstname_control.text,
                    widget.lastname_control.text,
                    widget.email_control.text,
                    widget.date.millisecondsSinceEpoch);

                await doc.set(userModel.toMap());

                Navigator.of(context).pop();
              },
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
