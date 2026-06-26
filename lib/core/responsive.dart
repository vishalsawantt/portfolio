import 'package:flutter/material.dart';

class Responsive {
  // Helper to check screen size anywhere in the app
  // mobile = width less than 768px
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  // tablet = width between 768 and 1024
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  // desktop = width 1024 and above
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  // returns width of current screen
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  // returns height of current screen
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}