import 'package:memorymate/Screen/HomeCare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memorymate/Screen/HomeScreen.dart';
import 'package:memorymate/Screen/MainReg.dart';
import 'package:memorymate/Screen/patient_signup.dart';
import 'package:memorymate/Screen/home2.dart';
import 'package:memorymate/Screen/forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();           // form widget - form validation

  final TextEditingController emailcontroller = new TextEditingController();  
  final TextEditingController passwordcontroller = new TextEditingController();
  var userData = {};                               // store userdata
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailfield = TextFormField(
      autofocus: false,
      controller: emailcontroller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a valid  mail");
        }
        return null;
      },
      onSaved: (value) {
        emailcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Email ",
          hintStyle: TextStyle(color: Colors.grey[400])),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );

    final passwordfield = TextFormField(
      autofocus: false,
      controller: passwordcontroller,
      obscureText: true,
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
        passwordcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey[400])),
          cursorColor: Color.fromARGB(255, 145, 149, 246),
    );
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 200),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              scale: 2,
                              image: AssetImage(
                                'lib/asset/logo.png',
                              ))),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Arial',
                              
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey))),
                                      child: emailfield),
                                  Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: passwordfield)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(140, 183, 201, 242),
                                    Color.fromARGB(255, 145, 149, 246),
                                  ])),
                              child: GestureDetector(
                                child: Center(
                                  child: Text(
                                    "Signin",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                        
                                  ),
                                ),
                                onTap: () {
                                  signIn(emailcontroller.text,
                                      passwordcontroller.text);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Container(
                              child: GestureDetector(
                                child: Center(
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 145, 149, 246),
                                    ),
                                  ),
                                ),
                                onTap: () {
                               Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPasswordPage(),
                                      ));
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: GestureDetector(
                                child: Center(
                                  child: Text(
                                    "Don't have an account? SignUp",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 145, 149, 246),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Choose(),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void signIn(String uid, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        await _auth
            .signInWithEmailAndPassword(email: uid, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                });
        User? user = _auth.currentUser!;
        var db = await FirebaseFirestore.instance
            .collection('student')
            .doc(user.uid)
            .get();
        userData = db.data()!;
        if (userData['role'] == 'teacher') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => HomeCare())));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => HomeScreen2())));
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
