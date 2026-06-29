import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/core/theme.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  final String title;

  const SectionHeader({required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // ← changed from .start
        children: [
          Text(
            label,
            textAlign: TextAlign.center, // ← added
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center, // ← added
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}