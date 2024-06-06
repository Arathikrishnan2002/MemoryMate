import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'remindercare.dart'; // Import your reminder settings page
import 'careprofile.dart';
import 'facerecognition.dart';
import 'package:memorymate/generative/ai.dart';

class CustomWaveShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 300, // Adjust the height as needed
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
  //ClipPath widget
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

class HomeCare extends StatelessWidget {
  const HomeCare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomWaveShape(), // Include the custom wave-like structure here
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to reminder settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReminderCare()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
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
                GestureDetector(
                  onTap: () {
                    // Navigate to face recognition page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FaceRecognitionScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 145, 149, 246),
        items: [
          Icon(Icons.dashboard, color: Colors.white),
          Icon(Icons.android, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        onTap: (index) {
          // Handle navigation based on index
          switch (index) {
            case 0:
              // Dashboard tapped
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerativeAIPage()),
              );
              break;

            case 2:
              // Profile tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EcaregiverProfile()),
              );
              break;
          }
        },
      ),
    );
  }
}
