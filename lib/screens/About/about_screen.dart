import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:portfolio/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/controllers/navbar_controller.dart';
import 'package:portfolio/models/about_model.dart';
import 'package:portfolio/services/data_services.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
  horizontal: Responsive.isMobile(context) ? 24 : 80,
  vertical: Responsive.isMobile(context) ? 40 : 80,
),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── shared section header — matches Skills/Projects ──
          const SectionHeader(label: 'GET TO KNOW ME', title: 'About Me'),
          const SizedBox(height: 48),

          FutureBuilder<AboutModel>(
            future: DataService.loadAbout(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final data = snapshot.data!;

              return Responsive.isMobile(context)
                  ? _MobileAbout(data: data)
                  : _DesktopAbout(data: data);
            },
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------
// _DesktopAbout : image left, content right
// ----------------------------------------------------------
// ----------------------------------------------------------
// _DesktopAbout : image left (capped width), content right
// ----------------------------------------------------------
class _DesktopAbout extends StatelessWidget {
  final AboutModel data;
  const _DesktopAbout({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 45,
          child: Align(
            alignment: Alignment.center, // ← changed from centerLeft
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: _AboutImage(data: data),
            ),
          ),
        ),
        const SizedBox(width: 60),
        Expanded(flex: 55, child: _AboutContent(data: data)),
      ],
    );
  }
}

// ----------------------------------------------------------
// _MobileAbout : image top (capped width, centered), content below
// ----------------------------------------------------------
class _MobileAbout extends StatelessWidget {
  final AboutModel data;
  const _MobileAbout({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: _AboutImage(data: data),
          ),
        ),
        const SizedBox(height: 56),
        _AboutContent(data: data),
      ],
    );
  }
}

// ----------------------------------------------------------
// _AboutImage : photo + floating status badge (no years claim)
// ----------------------------------------------------------
// ----------------------------------------------------------
// _AboutImage : photo (portrait aspect ratio) + floating badge
// ----------------------------------------------------------
class _AboutImage extends StatelessWidget {
  final AboutModel data;
  const _AboutImage({required this.data});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 700),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            // AspectRatio keeps a portrait shape (taller than wide)
            // regardless of screen size — this is what fixes the
            // odd wide-crop "blob" look
            child: AspectRatio(
              aspectRatio: 0.85, // ~portrait — tweak between 0.75–0.95 to taste
              child: Image.asset(
                data.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.bgCard,
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: AppColors.textMuted,
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: -24,
            right: -24,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.photoBadge.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    data.photoBadge.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
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
// _AboutContent : badge + heading + description + stats + buttons
// ----------------------------------------------------------
class _AboutContent extends StatelessWidget {
  final AboutModel data;
  const _AboutContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // badge pill
        // FadeInDown(
        //   duration: const Duration(milliseconds: 600),
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        //     decoration: BoxDecoration(
        //       color: AppColors.primary.withOpacity(0.1),
        //       borderRadius: BorderRadius.circular(20),
        //       border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        //     ),
        //     child: Text(
        //       data.badge,
        //       style: const TextStyle(
        //         color: AppColors.primary,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w600,
        //         letterSpacing: 1,
        //       ),
        //     ),
        //   ),
        // ),

        //const SizedBox(height: 20),

        // heading
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 150),
          child: Text(
            data.heading,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),

        const SizedBox(height: 20),

        // description
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 300),
          child: Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),

        const SizedBox(height: 36),

        // stats row — now just 2 safe, demonstrable stats
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 450),
          child: Wrap(
            spacing: 40,
            runSpacing: 20,
            children: data.stats.map((stat) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 36),

        // buttons
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 600),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // ElevatedButton(
              //   onPressed: () async {
              //     final Uri url = Uri.base.resolve(data.cvUrl);
              //     await launchUrl(url, mode: LaunchMode.externalApplication);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppColors.primary,
              //     foregroundColor: AppColors.bgDark,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 28,
              //       vertical: 16,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   child: const Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(
              //         'Download CV',
              //         style: TextStyle(
              //           fontWeight: FontWeight.w600,
              //           fontSize: 15,
              //         ),
              //       ),
              //       SizedBox(width: 8),
              //       Icon(Icons.download, size: 16),
              //     ],
              //   ),
              // ),
              OutlinedButton(
                onPressed: () {
                  Get.find<NavbarController>().scrollToSection('contact');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border, width: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get In Touch',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}