import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmNewPassword = _confirmNewPasswordController.text;

    if (newPassword != confirmNewPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match.'),
      ));
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reauthenticate user before changing password
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        // Change password
        await user.updatePassword(newPassword);

        // Password changed successfully, close dialog
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not logged in.'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to change password: $error'),
      ));
    }
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
            cursorColor: Color.fromARGB(255, 145, 149, 246),
            decoration: InputDecoration(
              labelText: 'Old Password',
              labelStyle: TextStyle(color: Color.fromARGB(255, 145, 149, 246)),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
              ),
            ),
          ),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            cursorColor: Color.fromARGB(255, 145, 149, 246),
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(color: Color.fromARGB(255, 145, 149, 246)),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
              ),
            ),
          ),
          TextField(
            controller: _confirmNewPasswordController,
            obscureText: true,
            cursorColor: Color.fromARGB(255, 145, 149, 246),
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              labelStyle: TextStyle(color: Color.fromARGB(255, 145, 149, 246)),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
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
          onPressed: _changePassword,
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 145, 149, 246),
          ),
        ),
      ],
    );
  }
}
