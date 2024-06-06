import 'package:flutter/material.dart';
import 'package:memorymate/facedetection/faceintro.dart';
import 'package:memorymate/Screen/addnotepage.dart';
import 'package:memorymate/Screen/custom_wave_shape.dart';
import 'package:memorymate/Screen/photoalbum.dart';
import 'package:memorymate/Screen/reminder.dart';
import 'package:memorymate/Screen/patientprofile.dart';
import 'package:memorymate/generative/ai.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomWaveShape(),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderPage()),
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
                      offset: Offset(0, 3),
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
            GestureDetector(
              onTap: () {
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
                      offset: Offset(0, 3),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotoAlbumPage()),
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
                      offset: Offset(0, 3),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotePage()),
              );
            },
            child: Icon(
              IconData(0xee40, fontFamily: 'MaterialIcons'),
              color: _page == 1 ? Colors.white : Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerativeAIPage()),
              );
            },
            child: Icon(
              Icons.android,
              color: _page == 3 ? Colors.white : Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Icon(
              Icons.person,
              color: _page == 3 ? Colors.white : Colors.white,
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
