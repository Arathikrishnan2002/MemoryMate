import 'package:memorymate/generative/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerativeAIPage extends StatelessWidget {
  const GenerativeAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BARD FLUTTER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
