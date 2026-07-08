import 'package:flutter/material.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/delete_account_model.dart';
import 'package:portfolio/services/data_services.dart';
import 'package:portfolio/widgets/footer_section.dart';
import 'package:url_launcher/url_launcher.dart';



// Import your existing theme files
// import 'app_colors.dart';
// import 'app_theme.dart';
// import 'responsive.dart';

/// DeleteAccountScreen
/// -------------------
/// Static informational page required by Google Play's "Data Safety" section.
/// Content is loaded via DeleteAccountService from delete_account_data.json,
/// parsed into DeleteAccountModel, then rendered here.
///
/// This screen is intentionally NOT linked anywhere in the app's navbar —
/// it is only reachable via direct URL (e.g. /delete-account) and is used
/// as the "Delete account URL" / "Delete data URL" in the Play Console.
class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});

  final DataService _service = DataService();

  // Maps the icon name string stored in JSON to an actual Flutter IconData.
  // Add entries here if you add new icons to the JSON file.
  static const Map<String, IconData> _iconMap = {
    'person_remove_outlined': Icons.person_remove_outlined,
    'delete_sweep_outlined': Icons.delete_sweep_outlined,
    'checklist_rtl_outlined': Icons.checklist_rtl_outlined,
    'schedule_outlined': Icons.schedule_outlined,
  };

  IconData _resolveIcon(String key) =>
      _iconMap[key] ?? Icons.info_outline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: FutureBuilder<DeleteAccountModel>(
          future: _service.loadPolicy(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(
                  'Unable to load policy content.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            final DeleteAccountModel data = snapshot.data!;
            final bool isMobile = Responsive.isMobile(context);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(header: data.header, isMobile: isMobile),
                      const SizedBox(height: 40),

                      // Delete Account + Delete Data cards
                      for (final section in data.sections) ...[
                        _SectionCard(
                          icon: _resolveIcon(section.icon),
                          title: section.title,
                          child: Text(
                            section.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Data Deleted checklist
                      _SectionCard(
                        icon: _resolveIcon(data.checklistIcon),
                        title: data.checklistTitle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final item in data.checklistItems)
                              _ChecklistItem(label: item),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Data Retention
                      _SectionCard(
                        icon: _resolveIcon(data.retention.icon),
                        title: data.retention.title,
                        child: Text(
                          data.retention.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _ContactCard(contact: data.contact),
                      const SizedBox(height: 40),

                      //FooterSection(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// Header
// ------------------------------------------------------------------
class _Header extends StatelessWidget {
  final HeaderModel header;
  final bool isMobile;
  const _Header({required this.header, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header.title,
          style: (isMobile
                  ? Theme.of(context).textTheme.displayMedium
                  : Theme.of(context).textTheme.displayLarge)
              ?.copyWith(fontSize: isMobile ? 26 : 34),
        ),
        const SizedBox(height: 12),
        Text(
          header.subtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------
// Reusable card wrapper used for every section
// ------------------------------------------------------------------
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// Checklist row with a check icon, used inside "Data Deleted" card
// ------------------------------------------------------------------
class _ChecklistItem extends StatelessWidget {
  final String label;
  const _ChecklistItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// Contact card — developer name, email, portfolio link
// ------------------------------------------------------------------
class _ContactCard extends StatelessWidget {
  final PolicyContactModel contact;
  const _ContactCard({required this.contact});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.contact_mail_outlined,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text('Contact', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          _ContactRow(icon: Icons.person_outline, text: contact.developerName),
          const SizedBox(height: 10),
          _ContactRow(
            icon: Icons.email_outlined,
            text: contact.developerEmail,
            onTap: () => _launch('mailto:${contact.developerEmail}'),
          ),
          const SizedBox(height: 10),
          _ContactRow(
            icon: Icons.link,
            text: contact.portfolioUrl,
            onTap: () => _launch(contact.portfolioUrl),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactRow({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: onTap != null
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}