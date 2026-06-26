import 'package:get/get.dart';

class NavbarController extends GetxController {
  var activeSection = 'home'.obs;

  // called when user clicks a nav item or scrolls to a section
  void setActive(String section) {
    activeSection.value = section;
  }
}