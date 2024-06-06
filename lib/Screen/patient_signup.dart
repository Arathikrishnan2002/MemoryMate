import 'dart:ffi';
import 'dart:typed_data';

import 'package:memorymate/Screen/home2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorymate/Screen/HomeScreen.dart';
import 'package:memorymate/model/user_model.dart' as model;
import 'package:memorymate/resources/StorageMethods.dart';
import 'package:memorymate/resources/auth_methods.dart';
import 'package:memorymate/utils/utils.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? photoUrl;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Color _borderColor = Colors.grey;

    final firstfield = TextFormField(
      autofocus: false,
      controller: fullNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        fullNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(IconData(0xe043, fontFamily: 'MaterialIcons'),
            color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Full Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: _borderColor), // Use dynamic color
        ),
        focusedBorder: OutlineInputBorder(
          // Define focused border
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 145, 149, 246)), // Purple color when focused
        ),
      ),
      cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

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
          return ("Please Enter a valid Mail");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(IconData(0xe043, fontFamily: 'MaterialIcons'),
            color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Emailid",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: _borderColor), // Use dynamic color
        ),
        focusedBorder: OutlineInputBorder(
          // Define focused border
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 145, 149, 246)), // Purple color when focused
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
        prefixIcon: Icon(IconData(0xe4a2, fontFamily: 'MaterialIcons'),
            color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Phone Number (10 Digits)",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: _borderColor), // Use dynamic color
        ),
        focusedBorder: OutlineInputBorder(
          // Define focused border
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 145, 149, 246)), // Purple color when focused
        ),
      ),
      cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

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
        prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: _borderColor), // Use dynamic color
        ),
        focusedBorder: OutlineInputBorder(
          // Define focused border
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 145, 149, 246)), // Purple color when focused
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
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: _borderColor), // Use dynamic color
        ),
        focusedBorder: OutlineInputBorder(
          // Define focused border
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 145, 149, 246)), // Purple color when focused
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
          );
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
                          SizedBox(height: 30),
                          Text(
                            "REGISTRATION FORM",
                            style: TextStyle(
                                color: Color.fromARGB(255, 145, 149, 246),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 25),
                          SizedBox(height: 5),
                          firstfield,
                          SizedBox(height: 5),
                          emailfield,
                          SizedBox(height: 5),
                          phonefield,
                          SizedBox(height: 5),
                          passfield,
                          SizedBox(height: 5),
                          confirmpassfield,
                          SizedBox(height: 40),
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
  }) async {
    setState(() {
      isLoading = true;
    });
    String role = "user";
    String res = "Some error occured";
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        // else if(email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        model.UserModel userModel = model.UserModel(
          uid: cred.user!.uid,
          email: email,
          fullName: fullNameController.text,
          emailid: emailController.text,
          phone: phoneNumberController.text,
          password: passwordController.text,
          confirmpassword: confirmPasswordController.text,
          role: role,
        );

        await _firestore
            .collection("student")
            .doc(cred.user!.uid)
            .set(userModel.toJson());
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Account created Successfully");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => HomeScreen2()),
            (route) => false);
      } else {
        res = "Please enter all the fields";
        Fluttertoast.showToast(msg: "Please enter all the fields");
      }
    } catch (err) {
      res = err.toString();
      setState(() {
        isLoading = false;
      });
    }

    return res;
  }
}
