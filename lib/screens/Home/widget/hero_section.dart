import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/home_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  // data comes from home.json via DataService
  final HomeModel data;

  const HeroSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // min height = full screen height
      constraints: BoxConstraints(
        minHeight: Responsive.screenHeight(context),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 24 : 80,
        vertical: 60,
      ),
      child: Responsive.isMobile(context)
          // mobile → single column
          ? _MobileHero(data: data)
          // desktop → two columns
          : _DesktopHero(data: data),
    );
  }
}

// ----------------------------------------------------------
// _DesktopHero : text on left, image on right
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
        // left side — text (takes 55% of width)
        Expanded(
          flex: 55,
          child: _HeroText(data: data),
        ),

        const SizedBox(width: 40),

        // right side — image (takes 45% of width)
        Expanded(
          flex: 45,
          child: _HeroImage(imagePath: data.profileImage),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _MobileHero : image on top, text below
// ----------------------------------------------------------
class _MobileHero extends StatelessWidget {
  final HomeModel data;
  const _MobileHero({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image on top for mobile
        _HeroImage(imagePath: data.profileImage),

        const SizedBox(height: 40),

        // text below
        _HeroText(data: data),
      ],
    );
  }
}

// ----------------------------------------------------------
// _HeroText : greeting + name + typewriter + bio + buttons
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
        // greeting — fades in first
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'Hi there 👋 I am',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // name — slides in from left
        FadeInLeft(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 200),
          child: Text(
            data.name,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),

        const SizedBox(height: 16),

        // typewriter titles — fades in
        FadeInLeft(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 400),
          child: Row(
            children: [
              Text(
                'I am a ',
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // AnimatedTextKit cycles through titles from JSON
              AnimatedTextKit(
                animatedTexts: data.titles
                    .map(
                      (title) => TypewriterAnimatedText(
                        title,
                        // speed of typing each character
                        speed: const Duration(milliseconds: 80),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                    .toList(),
                // keep cycling forever
                repeatForever: true,
                // pause between each title
                pause: const Duration(milliseconds: 1000),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // bio — fades in
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 600),
          child: Text(
            data.bio,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),

        const SizedBox(height: 36),

        // buttons — zooms in
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 800),
          child: _HeroButtons(data: data),
        ),

        const SizedBox(height: 32),

        // social links — fades in last
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
        // Primary button — View Projects
        ElevatedButton(
          onPressed: () {
            // TODO: scroll to projects section
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.bgDark,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'View Projects',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),

        // Secondary button — Download CV
        OutlinedButton(
          onPressed: () async {
            // opens CV url in browser
            final Uri url = Uri.parse(data.cvUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
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
          child: const Text(
            'Download CV',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _SocialLinks : GitHub + LinkedIn icon buttons
// ----------------------------------------------------------
class _SocialLinks extends StatelessWidget {
  final HomeModel data;
  const _SocialLinks({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // GitHub icon button
        _SocialIcon(
          icon: FontAwesomeIcons.github,
          url: data.github,
          tooltip: 'GitHub',
        ),
        const SizedBox(width: 20),
        // LinkedIn icon button
        _SocialIcon(
          icon: FontAwesomeIcons.linkedin,
          url: data.linkedin,
          tooltip: 'LinkedIn',
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _SocialIcon : single social icon with hover effect
// ----------------------------------------------------------
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
  // isHovered tracks mouse hover for web
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        // MouseRegion detects hover on web/desktop
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
              // on hover → show border
              border: Border.all(
                color: isHovered ? AppColors.primary : AppColors.border,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              widget.icon,
              // on hover → accent color, else grey
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
// _HeroImage : profile photo with glowing border
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
            // glow effect around image
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 60,
                spreadRadius: 10,
              ),
            ],
            border: Border.all(
              color: AppColors.primary.withOpacity(0.4),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              // shows placeholder if image not found
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