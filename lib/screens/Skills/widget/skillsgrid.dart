import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/skills_model.dart';

class SkillsGrid extends StatelessWidget {
  final List<SkillCategory> categories;
  const SkillsGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double totalWidth = MediaQuery.of(context).size.width;
    final double padding = isMobile ? 48 : 160;
    final double spacing = 20;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: categories.map((category) {
        return SizedBox(
          width: isMobile
              ? totalWidth - padding
              : (totalWidth - padding - spacing) / 2,
          child: FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: _SkillCard(category: category),
          ),
        );
      }).toList(),
    );
  }
}

//---------------------------------------------------------------------------------
// _SkillCard : one category — header (icon + title) + chips with logos
//---------------------------------------------------------------------------------

class _SkillCard extends StatefulWidget {
  final SkillCategory category;
  const _SkillCard({required this.category});

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
            // header row — category icon (keyword-based) + title
            Row(
              children: [
                _CategoryIcon(title: widget.category.title),
                const SizedBox(width: 12),
                Text(
                  widget.category.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 0.5, color: AppColors.border),
            const SizedBox(height: 16),
            // chips — each with its own logo from JSON
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.category.skills
                  .map((skill) => _SkillChip(skill: skill))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------------------
// _CategoryIcon : picks an icon by matching keywords in the category title
// no JSON field needed — purely decorative
//---------------------------------------------------------------------------------

class _CategoryIcon extends StatelessWidget {
  final String title;
  const _CategoryIcon({required this.title});

  IconData _getIcon() {
    final t = title.toLowerCase();
    if (t.contains('language') || t.contains('framework')) {
      return FontAwesomeIcons.code;
    }
    if (t.contains('backend') || t.contains('database')) {
      return FontAwesomeIcons.database;
    }
    if (t.contains('tool') || t.contains('platform')) {
      return FontAwesomeIcons.screwdriverWrench;
    }
    return FontAwesomeIcons.puzzlePiece;
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
// _SkillChip : logo (from JSON url) + skill name
//---------------------------------------------------------------------------------

class _SkillChip extends StatefulWidget {
  final SkillItem skill;
  const _SkillChip({required this.skill});

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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // logo on white backdrop — keeps dark-colored logos visible
            Container(
              width: 16,
              height: 16,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: SvgPicture.network(
                widget.skill.icon,
                placeholderBuilder: (context) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              widget.skill.name,
              style: TextStyle(
                fontSize: 13,
                color: isHovered ? AppColors.primary : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}