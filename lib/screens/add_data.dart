import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_prac/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddData extends StatefulWidget {
  //creating constructor of model class and initializing moodel class
  AddData({super.key, this.userModel});
  final UserModel? userModel;

  @override
  State<AddData> createState() => _DataShowState();
}

class _DataShowState extends State<AddData> {
  //initailizing variables and textcontrollers for setting user added text
  var firstname_control = TextEditingController();
  var lastname_control = TextEditingController();
  var email_control = TextEditingController();
  var password_control = TextEditingController();
  var image_control = TextEditingController();
  Color colors = Colors.red;
  DateTime date = DateTime.now();
  XFile? images;     //variable for storing selected image
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    //if model class is not empty  and we are adding data then set data on textfields we created in show data screen(show data widgets)
    if (widget.userModel != null) {
      firstname_control.text = widget.userModel!.firstname;
      lastname_control.text = widget.userModel!.lastname;
      email_control.text = widget.userModel!.email;
      password_control.text = widget.userModel!.password;
      image_control.text = widget.userModel!.image;
      date = DateTime.fromMillisecondsSinceEpoch(widget.userModel!.date);
      super.initState();
    }
  }

  //function for getting date
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

  // Function to upload an image to Firebase Cloud Storage
  Future<String> uploadImage(XFile file, String userId) async {
    final storageRef = FirebaseStorage.instance.ref().child('user_images/$userId.png');
    print(file.path);
   // File(file.path) converts the XFile to a regular File object to be uploaded.
    final uploadTask = await storageRef.putFile(File(file.path), SettableMetadata(contentType: "image/png"));       //uploading task refers to task of uploading data to remote server
    if (uploadTask.state == TaskState.success) {       ///This condition checks if the upload task was successful. If the upload was successful, it means the image is now stored in Firebase Storage.
      String url = await storageRef.getDownloadURL();
      return url;
    } else {
      throw PlatformException(code: "404", message: "no download link found");
    }
  }

  //pick image function
  final ImagePicker imagePicker = ImagePicker();
  Future<XFile?> pickImage(ImageSource source) async {
    XFile? file = await imagePicker.pickImage(
        source: source);                    //Xfile is the class in photomanager package of dart andcontain information related to assets like file size etc
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
        .gallery);     //XFile is used to represent image data into memory

   print(images?.mimeType);
    setState(() {
      images = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('User List'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.userModel == null ? "Add User" : "Update User"),

              //if we are adding new data then show add text otherwise in update case show update text at top
              Stack(
                children: <Widget>[
                  if (images!= null)
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: FileImage(File(images!.path)),
                    )
                  else
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage( widget.userModel?.image ??
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
                controller: firstname_control,
                decoration: InputDecoration(
                    hintText: "First", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: lastname_control,
                decoration: InputDecoration(
                    hintText: "Lastname", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: email_control,
                decoration: InputDecoration(
                    hintText: "Email", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: password_control,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ColorPicker(
                pickerColor: colors ??
                    Colors.white, //is color variable is null then show white color
                onColorChanged: (Color color) {
                  //on changing color, color variable will get value of selected color and change color
                  colors = color;
                },
                colorPickerWidth: 300.0,
                pickerAreaHeightPercent: 0.2,
              ),
              InkWell(
                onTap: () async {
                  //setting date by creating a variable and calling get date function
                  var d = await getDate();
                  if (d != null) {
                    date = d;
                    setState(() {});
                    ///update the state of a widget and trigger a rebuild of the widget tree.
                  }
                },
                child: Text(
                  DateFormat("MMM dd, yyyy").format(date), //setting date format
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  final doc = FirebaseFirestore.instance.collection("users").doc(widget.userModel?.id);

                  // Check if an image has been selected
                  if (images != null) {
                    final url = await uploadImage(images!, doc.id);
                    print(url);

                    final userModel = UserModel(
                      doc.id,
                      firstname_control.text,
                      lastname_control.text,
                      email_control.text,
                      date.millisecondsSinceEpoch,
                      colors,
                      url,
                      password_control.text,
                    );

                    // Save the UserModel to Firestore
                    await doc.set(userModel.toMap());

                    // Create a user account with the email and password
                    //await _registerUser();

                    Navigator.pop(context);
                  } else {
                    // Handle the case where no image is selected
                    // You can display an error message or take appropriate action.
                  }
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
