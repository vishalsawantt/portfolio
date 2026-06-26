import 'package:flutter/material.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/skills_model.dart';
import 'package:portfolio/screens/Skills/widget/skillsgrid.dart';
import 'package:portfolio/services/data_services.dart';
import 'package:portfolio/widgets/section_header.dart';

class SkillsSection  extends StatelessWidget {
  const SkillsSection ({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 24 :80,
        vertical: 80,
      ),
      color: AppColors.bgSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: "Technologies I work with", title: "Skills"),
          
          const SizedBox(height: 48),

          FutureBuilder<List<SkillModel>> (
            future: DataService.loadSkills(),
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
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return SkillsGrid(skills: snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}