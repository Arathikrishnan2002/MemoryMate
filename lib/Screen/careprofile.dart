import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorymate/Screen/LoginScreen.dart';
import 'package:memorymate/resources/auth_methods.dart';
import 'package:memorymate/widgets/follow.dart';
import 'package:memorymate/Screen/changepasscare.dart';

class EcaregiverProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(                //fetch data from Firestore
      future: FirebaseFirestore.instance.collection('student').doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Fetch patient details
          var patientData = snapshot.data!.data() as Map<String, dynamic>;
          String patientName = patientData['patientName'];
          String phone = patientData['phone'];

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
                      'Patient Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 145, 149, 246),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PatientDetailsPage(patientData: patientData),
                        ),
                      );
                    },
                  ),
                  Divider(color: Colors.grey[300]),
                  // Account Settings Section
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
                          builder: (context) => AccountSettings(user: user),
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
                  builder: (BuildContext context) => ChangePasswordDialog1(),
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
      },
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientDetailsPage({Key? key, required this.patientData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String patientName = patientData['patientName'];
    String referralId = patientData['referralId'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        title: Text('Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            SizedBox(height: 10),
            Text('Name: $patientName',style: TextStyle(
             fontSize: 20,color: Color.fromARGB(255, 145, 149, 246),
    
  ),),
            SizedBox(height: 20),
            Text('Referral ID: $referralId',style: TextStyle(
             fontSize: 20,color: Color.fromARGB(255, 145, 149, 246), 
    
  ),),

 
            // Add more patient details here if needed
          ],
        ),
      ),
    );
  }
}


class AccountSettings extends StatefulWidget {
  final User user;

  const AccountSettings({Key? key, required this.user}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettings> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle updating name and email
                widget.user.updateDisplayName(_nameController.text);
                widget.user.updateEmail(_emailController.text);
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 145, 149, 246),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change Password',
        style: TextStyle(
          color: Color.fromARGB(255, 145, 149, 246), // Change the color here
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _oldPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Old Password',
              labelStyle: TextStyle(color: Color.fromARGB(255, 145, 149, 246)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 145, 149, 246)), // Change the color to purple
              ),
            ),
          ),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(color: Color.fromARGB(255, 145, 149, 246)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 145, 149, 246)), // Change the color to purple
              ),
            ),
          ),
          TextField(
            controller: _confirmNewPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              labelStyle: TextStyle(color: Color.fromARGB(255, 145, 149, 246)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 145, 149, 246)), // Change the color to purple
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Color.fromARGB(255, 145, 149, 246)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            String oldPassword = _oldPasswordController.text;
            String newPassword = _newPasswordController.text;
            String confirmNewPassword = _confirmNewPasswordController.text;

            if (newPassword == confirmNewPassword) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Passwords do not match.'),
              ));
            }
          },
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(
                255, 145, 149, 246), // Change the background color here
          ),
        ),
      ],
    );
  }
}