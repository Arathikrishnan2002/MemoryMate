import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memorymate/resources/StorageMethods.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? fullName;
  final String? emailid;
  final String? phone;
  final String? password;
  final String? confirmpassword;
  final String? role;

  const UserModel(
      {required this.uid,
      required this.email,
      required this.fullName,
      required this.emailid,
      required this.phone,
      required this.password,
      required this.confirmpassword,
      required this.role});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      fullName: snapshot['fullName'],
      emailid: snapshot['email'],
      phone: snapshot['phone'],
      password: snapshot['password'],
      confirmpassword: snapshot['Confirm password'],
      role: snapshot['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'confirmpassword': confirmpassword,
        'role': role
      };
}
