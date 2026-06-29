import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/experience_model.dart';
import 'package:portfolio/widgets/section_header.dart';
import 'package:portfolio/services/data_services.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

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
          SectionHeader(label: "WHERE I'VE WORKED", title: "Experience"),
          const SizedBox(height: 48),

          FutureBuilder<List<ExperienceModel>>(
            future: DataService.loadExperience(),
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

              final experiences = snapshot.data!;

              // ── centers the timeline block on the page ──
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: List.generate(experiences.length, (index) {
                      return _ExperienceItem(
                        experience: experiences[index],
                        isLast: index == experiences.length - 1,
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final ExperienceModel experience;
  final bool isLast;
  const _ExperienceItem({required this.experience, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Stack(
        children: [
          // ── connecting line — positioned independently of card height ──
          // no IntrinsicHeight/Expanded needed, so it never misaligns
          // regardless of how much text is in the card
          if (!isLast)
            Positioned(
              left: 21, // centers under the 44px circle
              top: 44,  // starts right below the icon
              bottom: 0,
              child: Container(
                width: 1.5,
                color: AppColors.border,
              ),
            ),

          // ── icon + card row ──
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    color: AppColors.bgCard,
                  ),
                  child: Icon(
                    Icons.work_outline,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _ExperienceCard(experience: experience),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// _ExperienceCard stays exactly as you have it — no changes needed
class _ExperienceCard extends StatelessWidget {
  final ExperienceModel experience;
  const _ExperienceCard({required this.experience});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                experience.role,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  experience.duration,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${experience.company} · ${experience.location}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            experience.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          ...experience.points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 10),
                      child: Container(
                        width: 6,
                        height: 6,
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
        ],
      ),
    );
  }
}