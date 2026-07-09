import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/screens/DeleteAccount/delete_account_screen.dart';
import 'package:portfolio/screens/Home/home_screen.dart';
import 'core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Uri.base works on Flutter web without dart:html
    // reads the full current URL including query params
    final String? page = Uri.base.queryParameters['page'];
    final bool showDeletePage = page == 'delete-account';

    return GetMaterialApp(
      title: 'Vishal Sawant | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: showDeletePage
          ?  DeleteAccountScreen()
          : const HomeScreen(),
    );
  }
}