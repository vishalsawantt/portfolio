import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/screens/DeleteAccount/delete_account_screen.dart';
import 'package:portfolio/screens/Home/home_screen.dart';

import 'core/theme.dart';

void main() {
  print("PATH: ${html.window.location.pathname}");
  print("SEARCH: ${html.window.location.search}");
  print("HASH: ${html.window.location.hash}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the query parameter safely
    final String search = html.window.location.search ?? "";

    // Check if the URL contains ?page=delete-account
    final bool showDeletePage =
        search.contains("page=delete-account");

    return GetMaterialApp(
      title: 'Vishal Sawant | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,

      home: showDeletePage
          ? DeleteAccountScreen()
          : const HomeScreen(),
    );
  }
}