import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX — for state management
import 'package:portfolio/screens/Home/home_screen.dart';
import 'core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vishal Sawant | Flutter Developer',

      // hide debug banner on top right
      debugShowCheckedModeBanner: false,

      // apply our dark theme from theme.dart
      theme: AppTheme.dark,

      // home screen is our starting screen
      home: const HomeScreen(),
    );
  }
}