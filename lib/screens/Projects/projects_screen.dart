import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/project_model.dart';
import 'package:portfolio/services/data_services.dart';
import 'package:portfolio/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
          SectionHeader(label: 'WHAT I BUILT', title: 'Projects'),
          const SizedBox(height: 48),

          FutureBuilder<ProjectsModel>(
            future: DataService.loadProjects(),
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //featured projects
                  ...data.featured.map((project) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _FeaturedCard(project: project)
                    )),

                  const SizedBox(height: 24),

                  //other projects lable
                  if (data.other.isNotEmpty)
                    Text(
                      'Personal Projects',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                  const SizedBox(height: 16),  

                  //other projects grid
                  if (data.other.isNotEmpty)
                    _OtherProjectsGrid(projects: data.other),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

//_FeaturedProjects
class _FeaturedCard extends StatelessWidget {
  final FeaturedProject project;
  const _FeaturedCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //_ProjectImage(image: project.image),
                  const SizedBox(height: 16),
                  _FeaturedContent(project: project),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image left
                  // Expanded(
                  //   flex: 4,
                  //   child: _ProjectImage(image: project.image),
                  // ),
                  //const SizedBox(width: 24),
                  // content right
                  Expanded(
                    flex: 6,
                    child: _FeaturedContent(project: project),
                  ),
                ],
              ),
      ),
    );
  }
}

//_ProjectImage
class _ProjectImage extends StatelessWidget {
  final String image;
  const _ProjectImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16/10,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, StackTrace) {
            return Container(
              color: AppColors.bgSection,
              child: const Center(
                child: Icon(
                 Icons.image_outlined,
                 color: AppColors.textPrimary,
                 size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//_FeaturedContent
class _FeaturedContent extends StatelessWidget {
  final FeaturedProject project;
  const _FeaturedContent({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            project.badge,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 10),

        //title
        Text(
          project.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 4),

        //tagline
        Text(
          project.tagline,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            //fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 10),

        //description
        Text(
          project.descroption,
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(height: 14),

        // after description SizedBox
        const SizedBox(height: 12),

        // bullet points
        ...project.points.map((point) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 10),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  point,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        )),

        //tech chips
        // Wrap(
        //   spacing: 8,
        //   runSpacing: 8,
        //   children: project.tech
        //       .map((t) => Container(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 10,
        //           vertical: 5,
        //         ),
        //         decoration: BoxDecoration(
        //           border: Border.all(color: AppColors.border),
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: Text(
        //           t,
        //           style: const TextStyle(
        //             fontSize: 12,
        //             color: AppColors.textSecondary,
        //           ),
        //         ),
        //       ))
        //       .toList(),
        // ),

        //tech chips
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: project.tech.map((t) => _TechChip(label: t)).toList(),
),

        const SizedBox(height: 14),

        //link
        Row(
          children: [
            if (project.github.isNotEmpty)
            _LinkButton(
              icon: FontAwesomeIcons.github, 
              label: 'Code', 
              url: project.github
            ),
            if (project.github.isNotEmpty && project.demo.isNotEmpty)
             const SizedBox(width: 12),
            if (project.demo.isNotEmpty)
             _LinkButton(
              icon: FontAwesomeIcons.accusoft, 
              label: 'Live Demo', 
              url: project.demo,
            ),
          ],
        ),
      ],
    );
  }
}

//----------------------------------------------------------
// _LinkButton : small button with icon — GitHub / Demo
// ----------------------------------------------------------
class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 14, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// _techIconSlugs : maps tech name -> Simple Icons slug
// not every tech has a real brand logo (e.g. Provider, GetX,
// Dio are Flutter packages, not companies) — those just
// fall back to text-only, same as before
// ----------------------------------------------------------
const Map<String, String> _techIconSlugs = {
  'Flutter': 'flutter',
  'Firebase': 'firebase',
  'Firebase FCM': 'firebase',
  'PostgreSQL': 'postgresql',
  'Spring Boot': 'springboot',
  'Kotlin': 'kotlin',
  'Java': 'openjdk',
  'Razorpay': 'razorpay',
  'Google Maps': 'googlemaps',
  'OpenCV': 'opencv',
  'JavaScript': 'javascript',
  'Next.js': 'nextdotjs',
  'MySQL': 'mysql',
  'Git': 'git',
  'GitHub': 'github',
  'HTML': 'html5',
  'CSS': 'css',
  'Figma': 'figma',
  // Provider, GetX, Dio, News API → no brand logo, text-only
};

// ----------------------------------------------------------
// _TechChip : shared tech tag with optional logo
// used by both _FeaturedContent and _OtherProjectCard
// ----------------------------------------------------------
class _TechChip extends StatelessWidget {
  final String label;
  final bool small; // smaller version for _OtherProjectCard

  const _TechChip({required this.label, this.small = false});

  @override
  Widget build(BuildContext context) {
    final String? slug = _techIconSlugs[label];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 4 : 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (slug != null) ...[
            Container(
              width: small ? 12 : 14,
              height: small ? 12 : 14,
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: SvgPicture.network(
                'https://cdn.simpleicons.org/$slug',
                placeholderBuilder: (context) => const SizedBox.shrink(),
              ),
            ),
            SizedBox(width: small ? 4 : 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: small ? 11 : 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------
// _OtherProjectsGrid : smaller cards for college projects
// ----------------------------------------------------------
class _OtherProjectsGrid extends StatelessWidget {
  final List<OtherProject> projects;
  const _OtherProjectsGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double totalWidth = MediaQuery.of(context).size.width;
    final double padding = isMobile ? 48 : 160;
    final double spacing = 16;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(projects.length, (index) {
        return SizedBox(
          width: isMobile
              ? totalWidth - padding
              : (totalWidth - padding - spacing * 2) / 3,
          child: FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: index * 100),
            child: _OtherProjectCard(project: projects[index]),
          ),
        );
      }),
    );
  }
}

class _OtherProjectCard extends StatelessWidget {
  final OtherProject project;
  const _OtherProjectCard({required this.project});

  // separate method for launching url
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── title + github icon ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // ← only icon is clickable now!
              if (project.github.isNotEmpty)
                GestureDetector(
                  onTap: () => _launchUrl(project.github),
                  child: const FaIcon(
                    FontAwesomeIcons.github,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // ── description ──
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 12),

          // ── image ──
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              project.image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover, // ← contain keeps full logo
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: AppColors.bgSection,
                  child: const Center(
                    child: Icon(
                      Icons.phone_android,
                      color: AppColors.textMuted,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ── tech chips ──
          // Wrap(
          //   spacing: 6,
          //   runSpacing: 6,
          //   children: project.tech
          //       .map((t) => Container(
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: 8,
          //               vertical: 4,
          //             ),
          //             decoration: BoxDecoration(
          //               border: Border.all(color: AppColors.border),
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Text(
          //               t,
          //               style: const TextStyle(
          //                 fontSize: 11,
          //                 color: AppColors.textSecondary,
          //               ),
          //             ),
          //           ))
          //       .toList(),
          // ),
          // ── tech chips ──
Wrap(
  spacing: 6,
  runSpacing: 6,
  children: project.tech
      .map((t) => _TechChip(label: t, small: true))
      .toList(),
),
        ],
      ),
    );
  }
}