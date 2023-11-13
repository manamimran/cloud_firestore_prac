import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/screens/signUp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../methods/auth_services.dart';
import '../models/dashboard_model.dart';
import 'dashboard.dart';

class SignIn extends StatelessWidget {
  // AuthServices authServices = AuthServices();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var email_controller = TextEditingController();
  var password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: email_controller,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: password_controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email_controller.text,
                      password: password_controller.text,
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
                  // if (authServices.emailController != null &&
                  //     authServices.passwordController != null) {
                  //   authServices.signIn(context);
                  // }
                  // final UserCredential userCredential = await FirebaseAuth.instance
                  //     .signInWithEmailAndPassword(
                  //     email: emailController.text,
                  //     password: passwordController.text);
                  // final User? user = userCredential.user; // Access the User object from UserCredential.
                  //
                  // if (user != null) {
                  //   // User registration was successful
                  //   // You can fetch additional user information if needed and then navigate to the Dashboard.
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Dashboard(user: user), // Pass the user object to Dashboard.
                  //     ),
                  //   );
                  // } else {
                  //   // Handle registration or login errors.
                  // }
                  // // final doc = FirebaseFirestore.instance.collection("users").doc(userModel.email);
                  // //
                  // //   print('Logged in successfully');
                  // //   Navigator.push(
                  // //     context,
                  // //     MaterialPageRoute(builder: (context) => ShowData()),
                  // //   );
                },
                child: Text('Sign In'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You dont have an account?"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text('Sign Up'))
                ],
              ),
            ],
          ),

      ),
    );
  }
}
