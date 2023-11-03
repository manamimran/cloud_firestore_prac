import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserModel {

  late String id;
  late String firstname;
  late String lastname;
  late String email;
  late Color colors;
  late int date;

  UserModel(this.id, this.firstname, this.lastname, this.email,this.date,this.colors);

  UserModel.fromMap(Map<String, dynamic> data){
    id = data["Id"];
    firstname = data["First"];
    lastname = data["Lastname"] ;
    email = data["Email"];
    date = data["Date"];
    colors = Color(data["Color"]);
  }

  Map<String, dynamic> toMap(){
    return {
      "Id" : id,
      "First" : firstname,
      "Lastname" : lastname,
      "Email" : email,
      "Date" : date,
      "Color" : colors.value,
    };
  }

}