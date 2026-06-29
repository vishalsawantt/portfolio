import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  var activeSection = 'home'.obs;

  final Map<String, GlobalKey> sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'projects': GlobalKey(),
    'experience': GlobalKey(),
    'education': GlobalKey(),
    'contact': GlobalKey(),
  };

  // called when user clicks a nav item or scrolls to a section
  void setActive(String section) {
    activeSection.value = section;
  }

   void scrollToSection(String section) {
    setActive(section);
    final key = sectionKeys[section];
    final context = key?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }
}