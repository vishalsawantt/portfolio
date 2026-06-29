import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controllers/navbar_controller.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarController controller = Get.put(NavbarController());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavLogo(),

          if (Responsive.isDesktop(context))
            _NavLinks(controller: controller)
          else
            _MobileMenuBtn(),
        ],
      ),
    );
  }
}

//-------------------------------------------------------------------------------
// First letter of my name 'V'
class _NavLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'V',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const TextSpan(
            text: 'ishal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

//----------------------------------------------------------------------
//Navbar for big sceern
class _NavLinks extends StatelessWidget {
  final NavbarController controller;

  const _NavLinks({required this.controller});

  //list of nav sections
  final List<String> sections = const [
    'home',
    'about',
    'experience',
    'skills',
    'projects',
    'education',
    'contact',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sections.map((section) {
        return Padding(
          padding: const EdgeInsets.only(left: 32),
          child: _NavItem(label: section, controller: controller),
        );
      }).toList(),
    );
  }
}

//_NavItem for lab like highlights when active
class _NavItem extends StatelessWidget {
  final String label;
  final NavbarController controller;

  const _NavItem({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    //when active section chnage then rebuild by obx
    return Obx(() {
      final bool isActive = controller.activeSection.value == label;

      return GestureDetector(
        onTap: () => controller.scrollToSection(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                //show underline when active else transparent
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          child: Text(
            //first letter capital
            label[0].toUpperCase() + label.substring(1),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              //active = white, inActive = grey
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    });
  }
}

//drawer bar icon for mobail devices
class _MobileMenuBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(), // ← changed
      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
    );
  }
}

// ----------------------------------------------------------
// MobileNavDrawer : slide-out menu for mobile screens
// ----------------------------------------------------------
class MobileNavDrawer extends StatelessWidget {
  const MobileNavDrawer({super.key});

  final List<String> sections = const [
    'home',
    'about',
    'experience',
    'skills',
    'projects',
    'education',
    'contact',
  ];

  @override
  Widget build(BuildContext context) {
    final NavbarController controller = Get.find<NavbarController>();

    return Drawer(
      backgroundColor: AppColors.bgDark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
  child: _NavLogo(),
),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 8),

            // nav links list
            Expanded(
              child: ListView(
                children: sections.map((section) {
                  return Obx(() {
                    final bool isActive =
                        controller.activeSection.value == section;

                    return ListTile(
                      title: Text(
                        section[0].toUpperCase() + section.substring(1),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                      onTap: () {
                        // close drawer first, then scroll to section
                        Navigator.of(context).pop();
                        controller.scrollToSection(section);
                      },
                    );
                  });
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
