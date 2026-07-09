import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:portfolio/screens/DeleteAccount/delete_account_screen.dart';
import 'package:portfolio/screens/Home/home_screen.dart';
import 'core/theme.dart';

void main() {
  // CRITICAL: without this, Flutter web defaults to its own hash-based
  // URL strategy and rewrites the browser URL during engine bootstrap —
  // which strips query strings like ?page=delete-account before your
  // code ever runs. This call keeps the URL exactly as the user typed it.
  usePathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.base;
    final String? page = uri.queryParameters['page'];
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