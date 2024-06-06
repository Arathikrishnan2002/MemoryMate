import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memorymate/Screen/LoginScreen.dart';
import 'package:memorymate/resources/auth_methods.dart';
import 'package:memorymate/widgets/follow.dart';

import 'package:memorymate/Screen/account_settings_page.dart';
import 'package:memorymate/Screen/changepassword.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(
                      'https://imgs.search.brave.com/xovtPOgVsdFwQaH7qdeS9luEKNspqBmFWrdqR7Fsioc/rs:fit:512:512:1/g:ce/aHR0cHM6Ly9wbmcu/cG5ndHJlZS5jb20v/c3ZnLzIwMTYxMjI5/L191c2VybmFtZV9s/b2dpbl8xMTcyNTc5/LnBuZw'),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user!.displayName ?? 'John Doe',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user.email ?? 'john.doe@example.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 145, 149, 246),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AccountSettingsPage(user: user),
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              title: Text(
                'Privacy and Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 145, 149, 246),
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ChangePasswordDialog(),
                );
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              title: Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 145, 149, 246),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AboutPage(),
                  ),
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await AuthMethods().signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text('Sign Out'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 145, 149, 246),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        title: Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MEMORYMATE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'MEMORYMATE is an app designed to help you manage your personal information and memories OF PATIENTS. Developed by Your Company.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}