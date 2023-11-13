import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/show_data_widget.dart';
import 'add_data.dart';

class ShowData extends StatefulWidget {
  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<UserModel> userList = []; //initializing the list of data in model class

  //getting list of data saved in model w.r.t FromMap function in model class getting data from firebase
  getData() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      var docs = event.docs;
      userList = List.generate(
          docs.length, (index) => UserModel.fromMap(docs[index].data()));

      setState(() {});
    });
  }

  @override
  void initState() {
    //init function (initializing the previously defined variables of the stateful widget)
    super.initState();
    getData(); // call GetData function in init
  }

  // Function to sign out the user
  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop(); // Return to the previous screen
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('User List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              signOut();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          //context is name of item // index is default value of item
          return ShowDateWidget(
              userModel: userList[index] //passing userlist of model class to list View builder
              );
        },
        itemCount: userList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddData()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
