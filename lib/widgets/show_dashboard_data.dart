import 'package:cloud_firestore_prac/models/dashboard_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowDashboardData extends StatelessWidget{
   ShowDashboardData( {required this.dashboardModel});

  //initializing model class by adding its constructor
  final DashboardModel dashboardModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:  Center(
          child: Column(
            children: <Widget>[
              Baseline(
                baselineType: TextBaseline.alphabetic,
                baseline: 40.0,
                child: ClipOval(
                  child: Image(
                    image: NetworkImage(
                        dashboardModel.image
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(dashboardModel.id),
              Text(dashboardModel.email),
              Text(dashboardModel.password),

            ],
          ),
        ),
      ),
    );
  }

}