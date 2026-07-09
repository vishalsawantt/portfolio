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
    final Uri uri = Uri.base;
    final String? page = uri.queryParameters['page'];
    final bool showDeletePage = page == 'delete-account';

    return GetMaterialApp(
      title: 'Vishal Sawant | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: showDeletePage
          ?  DeleteAccountScreen()
          : _DebugWrapper(
              uri: uri,
              page: page,
              child: const HomeScreen(),
            ),
    );
  }
}

/// TEMPORARY — shows the raw URL Flutter actually sees, right on the page.
/// This lets us diagnose in production without needing DevTools access.
/// Remove this wrapper once delete-account routing is confirmed working.
class _DebugWrapper extends StatelessWidget {
  final Uri uri;
  final String? page;
  final Widget child;

  const _DebugWrapper({
    required this.uri,
    required this.page,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text(
              'DEBUG → Uri.base: "$uri"   |   page param: "${page ?? "null"}"',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}