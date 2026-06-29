import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:portfolio/controllers/navbar_controller.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/home_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  final HomeModel data;

  const HeroSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
  width: double.infinity,
  // removed minHeight entirely — no more forced centering inside
  // an oversized box, so top/bottom spacing are now independent
  padding: EdgeInsets.only(
    left: Responsive.isMobile(context) ? 24 : 80,
    right: Responsive.isMobile(context) ? 24 : 80,
    top: Responsive.isMobile(context) ? 40 : 80,   // ← ONLY this controls the gap after navbar
    bottom: 60,                                      // ← ONLY this controls the gap before About
  ),
  child: Responsive.isMobile(context)
      ? _MobileHero(data: data)
      : _DesktopHero(data: data),
);
  }
}

// ----------------------------------------------------------
// _DesktopHero
// ----------------------------------------------------------
class _DesktopHero extends StatelessWidget {
  final HomeModel data;
  const _DesktopHero({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 55, child: _HeroText(data: data)),
        const SizedBox(width: 40),
        Expanded(flex: 45, child: _HeroImage(imagePath: data.profileImage)),
      ],
    );
  }
}

// ----------------------------------------------------------
// _MobileHero
// ----------------------------------------------------------
class _MobileHero extends StatelessWidget {
  final HomeModel data;
  const _MobileHero({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _HeroImage(imagePath: data.profileImage),
        const SizedBox(height: 40),
        _HeroText(data: data),
      ],
    );
  }
}

// ----------------------------------------------------------
// _HeroText : badge + value headline + name/role + bio + buttons
// ----------------------------------------------------------
class _HeroText extends StatelessWidget {
  final HomeModel data;
  const _HeroText({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // status badge — like Taksh's "Open to freelance projects"
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  data.status,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        // bold value headline — replaces "Hi there I am [Name]"
        FadeInLeft(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 200),
          child: Text(
            data.headline,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),

        const SizedBox(height: 18),

        // name + typewriter role — now a subtitle, not the headline
        FadeInLeft(
  duration: const Duration(milliseconds: 700),
  delay: const Duration(milliseconds: 400),
  child: Wrap(        // ← change Row to Wrap!
    children: [
      Text(
        '${data.name} — ',
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      AnimatedTextKit(
        animatedTexts: data.titles
            .map(
              (title) => TypewriterAnimatedText(
                title,
                speed: const Duration(milliseconds: 80),
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            .toList(),
        repeatForever: true,
        pause: const Duration(milliseconds: 1000),
      ),
    ],
  ),
),

        const SizedBox(height: 24),

        // bio
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 600),
          child: Text(data.bio, style: Theme.of(context).textTheme.bodyLarge),
        ),

        const SizedBox(height: 36),

        // buttons
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 800),
          child: _HeroButtons(data: data),
        ),

        const SizedBox(height: 32),

        // social links
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 1000),
          child: _SocialLinks(data: data),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _HeroButtons : View Projects + Download CV buttons
// ----------------------------------------------------------
class _HeroButtons extends StatelessWidget {
  final HomeModel data;
  const _HeroButtons({required this.data});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            final controller = Get.find<NavbarController>();
            controller.scrollToSection('projects');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.bgDark,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'View Projects',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            final Uri url = Uri.base.resolve(data.cvUrl);
            await launchUrl(url, mode: LaunchMode.externalApplication);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Download CV',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _SocialLinks
// ----------------------------------------------------------
class _SocialLinks extends StatelessWidget {
  final HomeModel data;
  const _SocialLinks({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialIcon(
          icon: FontAwesomeIcons.github,
          url: data.github,
          tooltip: 'GitHub',
        ),
        const SizedBox(width: 20),
        _SocialIcon(
          icon: FontAwesomeIcons.linkedin,
          url: data.linkedin,
          tooltip: 'LinkedIn',
        ),
        const SizedBox(width: 20),
        _SocialIcon(
          icon: FontAwesomeIcons.whatsapp,
          url: 'https://wa.me/917066188421',
          tooltip: 'WhatsApp',
        ),
        const SizedBox(width: 20),
        _SocialIcon(
          icon: FontAwesomeIcons.envelope,
          url: 'mailto:${data.email}',
          tooltip: 'Email',
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: () async {
            final Uri url = Uri.parse(widget.url);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isHovered ? AppColors.primary : AppColors.border,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              widget.icon,
              color: isHovered ? AppColors.primary : AppColors.textSecondary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// _HeroImage
// ----------------------------------------------------------
class _HeroImage extends StatelessWidget {
  final String imagePath;
  const _HeroImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInRight(
        duration: const Duration(milliseconds: 800),
        delay: const Duration(milliseconds: 300),
        child: Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
  shape: BoxShape.circle,
  boxShadow: [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.35),
      blurRadius: 70,
      spreadRadius: 8,
    ),
  ],
  border: Border.all(
    color: AppColors.primary,   // full opacity, not faded — this is the main change
    width: 5,                    // thicker border — was 2
  ),
),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.bgCard,
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: AppColors.textMuted,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
