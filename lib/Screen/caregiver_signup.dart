import 'dart:ffi';  //Dart Foreign Function Interface 
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorymate/Screen/HomeCare.dart';
import 'package:memorymate/model/teacher_model.dart' as model;
import 'package:memorymate/resources/StorageMethods.dart';
import 'package:memorymate/utils/utils.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final patientNameController = TextEditingController();
  final referralIdController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Uint8List? _image;
  String? photoUrl;

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    patientNameController.dispose();
    referralIdController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
//first
    Color _borderColor = Colors.grey;
    final firstfield = TextFormField(
      autofocus: false,
      controller: fullNameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        fullNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(IconData(0xe043, fontFamily: 'MaterialIcons'),color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name",
         border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: _borderColor), // Use dynamic color
    ),
    focusedBorder: OutlineInputBorder( // Define focused border
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)), // Purple color when focused
    ),
  ),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

//first
    final patientfield = TextFormField(
      autofocus: false,
      controller: patientNameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        patientNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(IconData(0xe043, fontFamily: 'MaterialIcons'),color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Patient Name",
        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: _borderColor), // Use dynamic color
    ),
    focusedBorder: OutlineInputBorder( // Define focused border
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)), // Purple color when focused
    ),
  ),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

    //first
    final emailfield = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a Valid Email Id");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(IconData(0xe043, fontFamily: 'MaterialIcons'),color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "emailid",
         border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: _borderColor), // Use dynamic color
    ),
    focusedBorder: OutlineInputBorder( // Define focused border
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)), // Purple color when focused
    ),
  ),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

    final IDfield = TextFormField(
      autofocus: false,
      controller: referralIdController,
      keyboardType: TextInputType.name,
       validator: (value) {
        RegExp regex = new RegExp(r'^.{5,5}');
        if (value!.isEmpty) {
          return ("Please Enter Referral Id");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter 5 digit in it");
        }
        return null;
      },
      onSaved: (value) {
        referralIdController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(IconData(0xe043, fontFamily: 'MaterialIcons'),color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Referralid",
          border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: _borderColor), // Use dynamic color
    ),
    focusedBorder: OutlineInputBorder( // Define focused border
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)), // Purple color when focused
    ),
  ),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );


    final phonefield = TextFormField(
      autofocus: false,
      controller: phoneNumberController,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{10,10}');
        if (value!.isEmpty) {
          return ("Please Enter phone number");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter 10 digit in it");
        }
        return null;
      },
      onSaved: (value) {
        phoneNumberController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(IconData(0xe4a2, fontFamily: 'MaterialIcons'),color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number (10 Digits)",
          border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: _borderColor), // Use dynamic color
    ),
    focusedBorder: OutlineInputBorder( // Define focused border
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)), // Purple color when focused
    ),
  ),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );
//first

    final passfield = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key,color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: _borderColor), // Use dynamic color
    ),
    focusedBorder: OutlineInputBorder( // Define focused border
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)), // Purple color when focused
    ),
  ),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

    final confirmpassfield = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      obscureText: true,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key,color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: _borderColor), // Use dynamic color
    ),
    focusedBorder: OutlineInputBorder( // Define focused border
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)), // Purple color when focused
    ),
  ),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

    final NextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: Color.fromARGB(255, 145, 149, 246),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUser(
              email: emailController.text,
              password: passwordController.text,
              file: _image!);
        },
        child: Container(
            child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
    );

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(36.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 64,
                                      backgroundColor: Colors.black,
                                      backgroundImage: MemoryImage(_image!))
                                  : CircleAvatar(
                                      radius: 64,
                                      backgroundColor: Colors.black,
                                      backgroundImage: NetworkImage(
                                          'https://imgs.search.brave.com/xovtPOgVsdFwQaH7qdeS9luEKNspqBmFWrdqR7Fsioc/rs:fit:512:512:1/g:ce/aHR0cHM6Ly9wbmcu/cG5ndHJlZS5jb20v/c3ZnLzIwMTYxMjI5/L191c2VybmFtZV9s/b2dpbl8xMTcyNTc5/LnBuZw'),
                                    ),
                              Positioned(
                                bottom: -15,
                                left: 92,
                                child: IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Text(
                            "REGISTRATION FORM",
                            style: TextStyle(
                                color: Color.fromARGB(255, 145, 149, 246),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          firstfield,
                          SizedBox(height: 5),
                          patientfield,
                          SizedBox(height: 5),
                          emailfield,
                          SizedBox(height: 5),
                          phonefield,
                          SizedBox(height: 5),
                          IDfield,
                          SizedBox(height: 5),
                          passfield,
                          SizedBox(height: 5),
                          confirmpassfield,
                          SizedBox(height: 15),
                          NextButton,
                        ],
                      ))),
            )),
          )),
    );
  }

  Future<String> signUser({
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    setState(() {
      isLoading = true;
    });
    String res = "Some error occured";
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        //if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.Teacher userModel = model.Teacher(
          role:'teacher',
          uid: cred.user!.uid,
          email: email,
          fullname: fullNameController.text,
          patientName: patientNameController.text,
          referralId: referralIdController.text,
          phone: phoneNumberController.text,
          password: passwordController.text,
          confirmpassword: confirmPasswordController.text,
        );

        await _firestore
            .collection("student")
            .doc(cred.user!.uid)
            .set(userModel.toMap());
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Account created Successfully");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => HomeCare()),
            (route) => false);
      } else {
        res = "Please enter all the fields";
        Fluttertoast.showToast(msg: "Please enter all the fields");
      }
    } catch (err) {
      res = err.toString();
      Fluttertoast.showToast(msg: res);
      setState(() {
        isLoading = false;
      });
    }
    return res;
  }
}

