import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/responsive.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/models/contact_model.dart';
import 'package:portfolio/services/data_services.dart';
import 'package:portfolio/widgets/section_header.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
          const SectionHeader(label: "LET'S TALK", title: 'Contact'),
          const SizedBox(height: 48),

          FutureBuilder<ContactModel>(
            future: DataService.loadContact(),
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

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _ContactForm(data: data),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

enum _SubmitState { idle, loading, success, error }

class _ContactForm extends StatefulWidget {
  final ContactModel data;
  const _ContactForm({required this.data});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  _SubmitState _state = _SubmitState.idle;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _state = _SubmitState.loading);

    final endpoint = 'https://formsubmit.co/ajax/${widget.data.formsubmitEmail}';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Accept': 'application/json'},
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'message': _messageController.text,
        },
      );

      if (response.statusCode == 200) {
        setState(() => _state = _SubmitState.success);
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        setState(() => _state = _SubmitState.error);
      }
    } catch (e) {
      setState(() => _state = _SubmitState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          Text(
            widget.data.subheading,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),

          // direct contact info row
          // Wrap(
          //   spacing: 24,
          //   runSpacing: 12,
          //   alignment: WrapAlignment.center,
          //   children: [
          //     _ContactInfoChip(icon: FontAwesomeIcons.envelope, label: widget.data.email),
          //     _ContactInfoChip(icon: FontAwesomeIcons.phone, label: widget.data.phone),
          //     _ContactInfoChip(icon: FontAwesomeIcons.locationDot, label: widget.data.location),
          //   ],
          // ),
          //const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_state == _SubmitState.success)
                    const _StatusBanner(
                      icon: Icons.check_circle_outline,
                      color: Colors.greenAccent,
                      message: "Thanks! Your message has been sent — I'll get back to you soon.",
                    ),
                  if (_state == _SubmitState.error)
                    const _StatusBanner(
                      icon: Icons.error_outline,
                      color: Colors.redAccent,
                      message: "Something went wrong. Please try again or email me directly.",
                    ),
                  if (_state == _SubmitState.success || _state == _SubmitState.error)
                    const SizedBox(height: 20),

                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: _inputDecoration('Your Name'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: _inputDecoration('Your Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter your email';
                      if (!value.contains('@')) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _messageController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: _inputDecoration('Your Message'),
                    maxLines: 5,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Please enter a message' : null,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _state == _SubmitState.loading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.bgDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _state == _SubmitState.loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.bgDark,
                              ),
                            )
                          : const Text(
                              'Send Message',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.bgSection,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  const _StatusBanner({required this.icon, required this.color, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(color: color, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _ContactInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ContactInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }
}