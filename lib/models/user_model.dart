import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserModel {

  late String id;
  late String image;
  late String firstname;
  late String lastname;
  late String email;
  late String password;
  late Color colors;
  late int date;

  UserModel(this.id, this.firstname, this.lastname, this.email,this.date,this.colors,this.image, this.password);

  UserModel.fromMap(Map<String, dynamic> data){          //hashmap for getting data from firestore
    id = data["Id"];
    image = data["Image"];
    firstname = data["First"];
    lastname = data["Lastname"] ;
    email = data["Email"];
    password = data["Password"];
    date = data["Date"];
    colors = Color(data["Color"]);             //The Color is being used to represent a color value that is stored in your data source, likely as an integer value.
  }

  Map<String, dynamic> toMap(){       // hashmap for setting data to firestore
    return {
      "Id" : id,
      "Image" : image,
      "First" : firstname,
      "Lastname" : lastname,
      "Email" : email,
      "Password" : password,
      "Date" : date,
      "Color" : colors.value,
    };
  }

}