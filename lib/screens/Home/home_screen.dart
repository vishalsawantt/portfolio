import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:portfolio/controllers/navbar_controller.dart';
import 'package:portfolio/models/home_model.dart';
import 'package:portfolio/screens/About/about_screen.dart';
import 'package:portfolio/screens/Contact/contact_screen.dart';
import 'package:portfolio/screens/Education/education_screen.dart';
import 'package:portfolio/screens/Experience/experience_screen.dart';
import 'package:portfolio/screens/Home/widget/hero_section.dart';
import 'package:portfolio/screens/Home/widget/navbar.dart';
import 'package:portfolio/screens/Projects/projects_screen.dart';
import 'package:portfolio/screens/Skills/skills_screen.dart';
import 'package:portfolio/services/data_services.dart';
import 'package:portfolio/widgets/footer_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarController controller = Get.put(NavbarController());

    return Scaffold(
      drawer: const MobileNavDrawer(), 
      body: Column(
        children: [
          const NavBar(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero Section ────────────────────────
                  // FutureBuilder waits for DataService.loadHome()
                  // then passes data to HeroSection
                  Container(
                    key: controller.sectionKeys['home'],
                    child: FutureBuilder<HomeModel>(
                      // calls DataService which reads home.json
                      future: DataService.loadHome(),

                      builder: (context, snapshot) {
                        // ── State 1: Still loading ───────────
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const _LoadingWidget();
                        }

                        // ── State 2: Error occurred ──────────
                        if (snapshot.hasError) {
                          return _ErrorWidget(error: snapshot.error.toString());
                        }

                        // ── State 3: Data ready ──────────────
                        // snapshot.data is our HomeModel object
                        final HomeModel homeData = snapshot.data!;

                        // pass data down to HeroSection widget
                        return HeroSection(data: homeData);
                      },
                    ),
                  ),

                  Container(
                    key: controller.sectionKeys['about'],
                    child: AboutSection(),
                  ),

                  Container(
                    key: controller.sectionKeys['experience'],
                    child: ExperienceSection(),
                  ),

                  Container(
                    key: controller.sectionKeys['skills'],
                    child: SkillsSection(),
                  ),

                  Container(
                    key: controller.sectionKeys['projects'],
                    child: ProjectsSection(),
                  ),

                  Container(
                    key: controller.sectionKeys['education'],
                    child: EducationSection(),
                  ),

                  Container(
                    key: controller.sectionKeys['contact'],
                    child: ContactSection(),
                  ),

                  const FooterSection(), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------
// _LoadingWidget : shown while JSON is being loaded
// kept as separate widget — clean and reusable
// ----------------------------------------------------------
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00D4FF), // AppColors.primary
          strokeWidth: 2,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// _ErrorWidget : shown if JSON loading fails
// shows the actual error message so you can debug easily
// ----------------------------------------------------------
class _ErrorWidget extends StatelessWidget {
  final String error;
  const _ErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Failed to load data',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            // shows actual error — helps in debugging
            Text(
              error,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
