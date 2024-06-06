import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AccountSettingsPage extends StatefulWidget {
  final User user;

  const AccountSettingsPage({Key? key, required this.user}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _referralIdController; // Referral ID controller
  String _referralId = ''; // Referral ID variable
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  bool _canChangeReferralId =
      true; // Variable to track if referral ID can be changed

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _emailController = TextEditingController(text: widget.user.email);
    _referralIdController =
        TextEditingController(); // Initialize the controller
    _loadReferralId(); // Load referral ID when the page loads
  }

  Color nameColor = Colors.black;
  Color emailColor = Colors.black;

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
              onTap: () {
                setState(() {
                  nameColor = Color.fromARGB(
                      255, 145, 149, 246); // Change color when touched
                });
              },
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: nameColor),
                focusColor: Color.fromARGB(
                    255, 145, 149, 246), // Change text color when focused
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 145, 149,
                          246)), // Change line color when focused
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              onTap: () {
                setState(() {
                  emailColor = Color.fromARGB(
                      255, 145, 149, 246); // Change color when touched
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: emailColor),
                focusColor: Color.fromARGB(
                    255, 145, 149, 246), // Change text color when focused
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 145, 149,
                          246)), // Change line color when focused
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_canChangeReferralId) ...[
              // Display TextFormField if referral ID can be changed
              TextFormField(
                controller: _referralIdController,
                decoration: InputDecoration(labelText: 'Referral ID'),
              ),
            ] else ...[
              // Display referral ID as text if it cannot be changed
              Text(
                'Referral ID: $_referralId',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Password: 123abc',
                style: TextStyle(fontSize: 16),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _canChangeReferralId ? _saveReferralId : _saveChanges,
              child: Text(
                  _canChangeReferralId ? 'Save Referral ID' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 145, 149, 246),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save referral ID
  void _saveReferralId() async {
    String referralId = _referralIdController.text.trim();
    if (referralId.isNotEmpty) {
      await _firestore.collection('user1').doc(widget.user.uid).set({
        'referral_id': referralId,
      }, SetOptions(merge: true));
      setState(() {
        _referralId = referralId;
        _canChangeReferralId = false; // Prevent further changes to referral ID
      });
    }
  }

  // Function to save changes
  void _saveChanges() {
    widget.user.updateDisplayName(_nameController.text);
    widget.user.updateEmail(_emailController.text);
    Navigator.pop(context);
  }

  // Function to load referral ID from Firestore
  void _loadReferralId() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('user1').doc(widget.user.uid).get();
    String? referralId = userDoc['referral_id'];
    if (referralId != null && referralId.isNotEmpty) {
      setState(() {
        _referralId = referralId;
        _canChangeReferralId = false; // Prevent further changes to referral ID
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _referralIdController.dispose();
    super.dispose();
  }
}
