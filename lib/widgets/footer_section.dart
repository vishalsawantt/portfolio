import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/footer_model.dart';
import 'package:portfolio/services/data_services.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 24 : 80,
        vertical: 32,
      ),
      child: FutureBuilder<FooterModel>(
        future: DataService.loadFooter(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 60);
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;

          return Responsive.isMobile(context)
              ? _MobileFooter(data: data)
              : _DesktopFooter(data: data);
        },
      ),
    );
  }
}

// ----------------------------------------------------------
// _DesktopFooter : logo+tagline | links | copyright — one row
// ----------------------------------------------------------
class _DesktopFooter extends StatelessWidget {
  final FooterModel data;
  const _DesktopFooter({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FooterLogo(data: data),

        Row(
          children: [
            _FooterLink(label: 'GitHub', url: data.github),
            const SizedBox(width: 28),
            _FooterLink(label: 'LinkedIn', url: data.linkedin),
            const SizedBox(width: 28),
            _FooterLink(label: 'WhatsApp', url: data.whatsapp),
          ],
        ),

        Text(
          '© ${DateTime.now().year} ${data.copyrightName}. All rights reserved.',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _MobileFooter : stacked + centered
// ----------------------------------------------------------
class _MobileFooter extends StatelessWidget {
  final FooterModel data;
  const _MobileFooter({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _FooterLogo(data: data, centered: true),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _FooterLink(label: 'GitHub', url: data.github),
            _FooterLink(label: 'LinkedIn', url: data.linkedin),
            _FooterLink(label: 'WhatsApp', url: data.whatsapp),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          '© ${DateTime.now().year} ${data.copyrightName}. All rights reserved.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _FooterLogo : "V" accent + "ishal." + tagline below
// ----------------------------------------------------------
class _FooterLogo extends StatelessWidget {
  final FooterModel data;
  final bool centered;
  const _FooterLogo({required this.data, this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data.name.substring(0, 1),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: '${data.name.substring(1)}.',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.tagline,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------
// _FooterLink : text link with hover color change
// ----------------------------------------------------------
class _FooterLink extends StatefulWidget {
  final String label;
  final String url;
  const _FooterLink({required this.label, required this.url});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Text(
          widget.label,
          style: TextStyle(
            color: isHovered ? AppColors.primary : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}