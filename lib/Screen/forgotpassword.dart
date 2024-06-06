import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memorymate/Screen/LoginScreen.dart';

class ForgotPasswordPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('A password reset link has been sent to $email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(
      color: Color.fromARGB(255, 145, 149, 246), // Change the color of 'OK' text to purple
    ),),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors
      print("Failed to send reset email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
      color: Color.fromARGB(255, 145, 149, 246), // Change label text color to purple
    ),
      focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
                  
                ),
                 
                
              ),
              cursorColor: Color.fromARGB(255, 145, 149, 246),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendPasswordResetEmail(context, _emailController.text);
              },
              style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 145, 149, 246)), // Change the color here
  ),
              child: Text('Send Reset Link',),
            ),
          ],
        ),
      ),
    );
  }
}
