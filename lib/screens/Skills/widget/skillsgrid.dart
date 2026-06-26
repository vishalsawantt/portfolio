import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/skills_model.dart';

class SkillsGrid extends StatelessWidget {
  final List<SkillModel> skills;
  const SkillsGrid({required this.skills});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double totalWidth = MediaQuery.of(context).size.width;
    final double padding = isMobile ? 48 : 160; // total left+right padding
    final double spacing = 20;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: skills.map((skill) {
        return SizedBox(
          width: isMobile
              ? totalWidth - padding
              : (totalWidth - padding - spacing) / 2,
          child: FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: _SkillCard(skill: skill),
          ),
        );
      }).toList(),
    );
  }
}

//---------------------------------------------------------------------------------

class _SkillCard extends StatefulWidget {
  final SkillModel skill;
  const _SkillCard({required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHovered
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header row — icon + title
            Row(
              children: [
                _CategoryIcon(iconKey: widget.skill.icon),
                const SizedBox(width: 12),
                Text(
                  widget.skill.category,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 0.5, color: AppColors.border),
            const SizedBox(height: 16),
            // chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.skill.skills
                  .map((name) => _SkillChip(label: name))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------------------

class _CategoryIcon extends StatelessWidget {
  final String iconKey;
  const _CategoryIcon({required this.iconKey});

  IconData _getIcon() {
    switch (iconKey) {
      case 'mobile':
        return FontAwesomeIcons.mobileScreenButton;
      case 'database':
        return FontAwesomeIcons.database;
      case 'tools':
        return FontAwesomeIcons.screwdriverWrench;
      case 'integration':
        return FontAwesomeIcons.puzzlePiece;
      default:
        return FontAwesomeIcons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FaIcon(_getIcon(), color: AppColors.primary, size: 16),
    );
  }
}

//---------------------------------------------------------------------------------

class _SkillChip extends StatefulWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            color: isHovered ? AppColors.primary : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
