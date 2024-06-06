import 'package:memorymate/Screen/ProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorymate/Screen/patientprofile.dart';
import 'package:memorymate/facedetection/faceintro.dart';
import 'package:memorymate/utils/globalvar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:memorymate/Screen/reminder.dart';
import 'package:memorymate/Screen/photoalbum.dart';
import 'package:memorymate/Screen/addnotepage.dart';
import 'package:memorymate/generative/ai.dart';
import 'package:memorymate/Screen/custom_wave_shape.dart';

class CustomWaveShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 250, // Adjust the height as needed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 145, 149, 246),
              Color.fromARGB(255, 200, 180, 220), // Adjust colors as needed
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            'WELCOME TO MEMORYMATE !!!',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.75);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height * 0.75);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height * 0.5);
    var secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  late PageController pageController;
  int _page = 0;
  bool isUser = false;
  final _auth = FirebaseAuth.instance;
  var userData = {};

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    auth().then((value) {
      setState(() {
        isUser = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Future<bool> auth() async {
    bool g = false;
    User? user = _auth.currentUser;
    if (user != null) {
      var db = await FirebaseFirestore.instance
          .collection('student')
          .doc(user.uid)
          .get();
      var userData = db.data();
      if (userData != null && userData['role'] == 'user') {
        g = true;
      }
    }
    return g;
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  // Function to navigate to the reminder setting page
  void navigateToReminderSettingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReminderPage()),
    );
  }

  // Function to navigate to the photo album page
  void navigateToPhotoAlbumPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoAlbumPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomWaveShape(), // Include the custom wave-like structure here
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to reminder setting page
                    navigateToReminderSettingPage(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 165, 185, 255),
                          Color.fromARGB(255, 155, 149, 246),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 6,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'REMINDER',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to face recognition page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => face_reg1()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 165, 185, 255),
                          Color.fromARGB(255, 155, 149, 246),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 6,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'FACE RECOGNITION',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to photo album page
                    navigateToPhotoAlbumPage(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 165, 185, 255),
                          Color.fromARGB(255, 155, 149, 246),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 6,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'PHOTO ALBUM',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
        
      ),
      
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 145, 149, 246),
        items: [
          Icon(
            Icons.dashboard,
            color: _page == 0 ? Colors.white : Colors.white,
          ),
          GestureDetector(
            child: Icon(
              IconData(0xee40, fontFamily: 'MaterialIcons'),
              color: _page == 1 ? Colors.white : Colors.white,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotePage()),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              // Navigate to Generative AI page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerativeAIPage()),
              );
            },
            child: Icon(
              Icons.android, // Change to desired generative AI/chatbot icon
              color: _page == 3 ? Colors.white : Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Icon(
              Icons.person, // Profile icon
              color: _page == 4 ? Colors.white : Colors.white,
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}

class Addnotepage {}
