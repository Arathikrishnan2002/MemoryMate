import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:memorymate/Screen/Feed.dart';
import 'package:memorymate/Screen/Feed2.dart';
import 'package:memorymate/Screen/ProfileScreen.dart';
import 'package:memorymate/Screen/ProfileTeacher.dart';


List<Widget> homeScreenItems = [
  const FeedScreen(),

  
  ProfileScreen2(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  FeedScreen2(),
];

List<Widget> homeScreenItems2 = [
  const FeedScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  FeedScreen2(),
  
];
