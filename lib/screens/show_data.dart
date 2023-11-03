import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/show_data_widget.dart';
import 'add_data.dart';

class ShowData extends StatefulWidget{


  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<UserModel> userList = [];

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
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.purple,
      title: Text('User List'),
    ),
      body: ListView.builder(
        itemBuilder: (context , index) {      //show list is name of item // listvalue is default value of item
          return UserDateWidget(
              userModel : userList[index]
          );
        },
        itemCount: userList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddData()));
        },
        child: Icon(
          Icons.add,
        ),
      ),


    );  }
}