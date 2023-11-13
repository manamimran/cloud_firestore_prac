import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/screens/signIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // List<DashboardModel> userList = []; //initializing the list of data in model class
  // AuthServices authServices = AuthServices();
  // late DashboardModel model;   // Variable to store the retrieved data
  final auth = FirebaseAuth.instance;
  DashboardModel? dashboardModel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var uid = FirebaseAuth.instance.currentUser!
        .uid; //The currentUser property represents the currently signed-in user, and uid is the unique identifier for that user.
    //print(value.user?.uid);

    final doc = FirebaseFirestore.instance.collection("users").doc(uid);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      setState(() {
        // Flutter should rebuild the widget with the updated data.
        // var value;
        // print(value.user?.uid);

        print("userdata exist");
        dashboardModel = DashboardModel.fromMap(snapshot.data() as Map<String,
            dynamic>); //The snapshot.data() method retrieves the data from the Firestore document.
        // Now you have the Model object from Firestore data'
      });
    } else {
      print("No userdata exist");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user data exsists'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('SignOut Successfully'),
                  ),
                );
              },
              icon: Icon(Icons.logout))
        ],
        title: Text('Dashboard'),
      ),
      body: Container(
        child: dashboardModel != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Center(
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(dashboardModel!.image),
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Text('Email: ${dashboardModel!.email.toString()}',
                      style: TextStyle(fontSize: 28)),
                  Text(
                    'Password: ${dashboardModel!.password.toString()}',
                    style: TextStyle(fontSize: 28)
                  ),
                ],
              )
            : CircularProgressIndicator(), // Show loading indicator while data is being fetched
      ),
    );
  }
}

//       body: Container(
//         // child: ListView.builder(
//         //   itemBuilder: (ctx, index) {
//         //     return ShowDashboardData(
//         //       dashboardModel: userList[index],
//         //     );
//         //   },
//         //   itemCount: userList.length,
//         // ),
//       ),

//     );
//   }
// }
