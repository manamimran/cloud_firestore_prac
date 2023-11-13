
import 'package:cloud_firestore_prac/screens/signIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/dashboard.dart';

class AuthServices {

final auth = FirebaseAuth.instance;
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();


// User Sign up with email and password
 void signUp(context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text).then((value) {
        print(value.user?.uid);
        // print('SignUp successfully');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Dashboard()));
      });
    } catch (e) {
      print("Error: $e");
      // Show a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: Something went wrong : SignUp failed"),
        ),
      );
    }
 }

 // User Sign in with email and password
 void signIn(context) async {
    try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) {
        print("SignIn successfully");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Dashboard()));
     });

    }catch (e) {
      print("Error: $e");
      // Show a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: Something went wrong : SignIn failed"),
        ),
      );
    }
    }
    //User Sign out
  void signOut(context) async {
    auth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute( builder: (context) => SignIn()),
            (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SignOut Successfully'),
      ),
    );}
}





