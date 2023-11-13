import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/methods/auth_services.dart';
import 'package:cloud_firestore_prac/models/dashboard_model.dart';
import 'package:cloud_firestore_prac/screens/dashboard.dart';
import 'package:cloud_firestore_prac/screens/signIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // AuthServices authServices = AuthServices();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var image_controller = TextEditingController();
  var email_controller = TextEditingController();
  var password_controller = TextEditingController();
  XFile? images;
  //pick image function
  final ImagePicker imagePicker = ImagePicker();

  // Function to upload an image to Firebase Cloud Storage
  Future<String> uploadImage(XFile file, String userId) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('user_images/$userId.png');
    print(file.path);
    // File(file.path) converts the XFile to a regular File object to be uploaded.
    final uploadTask = await storageRef.putFile(
        File(file.path), SettableMetadata(contentType: "image/png")); //uploading task refers to task of uploading data to remote server
    if (uploadTask.state == TaskState.success) {
      ///This condition checks if the upload task was successful. If the upload was successful, it means the image is now stored in Firebase Storage.
      String url = await storageRef.getDownloadURL();
      return url;
    } else {
      throw PlatformException(code: "404", message: "no download link found");
    }
  }

  Future<XFile?> pickImage(ImageSource source) async {
    XFile? file = await imagePicker.pickImage(
        source:
            source); //Xfile is the class in photomanager package of dart andcontain information related to assets like file size etc
    if (file != null) {
      return file;
    } else {
      print('Image not Selected');
    }
    return null;
  }

//select image from gallery
  selectImage() async {
    XFile? image = await pickImage(ImageSource
        .gallery); //XFile is used to represent image data into memory

    print(images?.mimeType);
    setState(() {
      images = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Stack(
                  children: <Widget>[
                    if (images != null)
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(File(images!.path)),
                      )
                    else
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg"),
                      ),
                    Positioned(
                      child: IconButton(
                        onPressed:
                            selectImage, // Call your selectImage function when the IconButton is pressed.
                        icon: Icon(Icons.add_a_photo),
                      ),
                      bottom: -10,
                      left: 80,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: email_controller,
                  decoration: InputDecoration(
                      hintText: "Email", border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: password_controller,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password", border: OutlineInputBorder()),
                ),
                Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: 40.0,
                    child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.purple),
                        child: InkWell(
                          onTap: () async {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: email_controller.text,
                                  password: password_controller.text).then((value) async {
                                // print(value.user?.uid);
                                print('SignUp successfully');
                                var uid = FirebaseAuth.instance.currentUser!.uid;   ////The currentUser property represents the currently signed-in user, and uid is the unique identifier for that user.

                                if (images != null) {
                                  final url = await uploadImage(images!, uid);
                                  // print(url);

                                  //passing values to Model
                                  final dashboardModel = DashboardModel(
                                      id: uid,
                                      email: email_controller.text,
                                      image: url,
                                      password: password_controller.text);

                                  final doc = FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(uid);
                                  // Save the Model to Firestore
                                  await doc.set(dashboardModel.toMap());
                                  print('data added');
                                }
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
                            // if (authServices.emailController != null &&
                            //     authServices.passwordController != null) {
                            //   authServices.signUp(context);
                            //   print('auth done');
                            // }

                            // var uid = FirebaseAuth.instance.currentUser!.uid;   ////The currentUser property represents the currently signed-in user, and uid is the unique identifier for that user.
                            //
                            // if (images != null) {
                            //   final url = await uploadImage(images!, uid);
                            //   // print(url);
                            //
                            //   //passing values to Model
                            //   final dashboardModel = DashboardModel(
                            //       id: uid,
                            //       email: authServices.emailController.text,
                            //       image: url,
                            //       password: authServices.passwordController.text);
                            //
                            //   final doc = FirebaseFirestore.instance
                            //       .collection("users")
                            //       .doc(uid);
                            //   // Save the Model to Firestore
                            //   await doc.set(dashboardModel.toMap());
                            //   print('data added');
                            // }

                          },
                          child: Center(
                            child: Text('Sign up',
                                textScaleFactor: 1,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You already have an account?"),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SignIn()));
                        },
                        child: Text('Sign In'))
                  ],
                ),
              ],
            ),

        ),
      ),
    );
  }
}
