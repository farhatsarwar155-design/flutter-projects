import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'How do I create a new note?',
      answer:
          'Tap the "+" floating button on the Home screen. Fill in the title and content, then tap "Save".',
    ),
    _FaqItem(
      question: 'How do I set a reminder for a note?',
      answer:
          'Open the note editor and tap the alarm icon in the bottom toolbar. Pick a date and time. The app will send you a notification at that time.',
    ),
    _FaqItem(
      question: 'How do I add a voice note?',
      answer:
          'In the note editor, tap the microphone icon in the bottom toolbar to start recording. Tap the stop icon when done. Your voice note will be attached to the note.',
    ),
    _FaqItem(
      question: 'How do I attach a photo to a note?',
      answer:
          'In the note editor, tap the image or attach icon in the toolbar. You can pick from your gallery or take a new photo with the camera.',
    ),
    _FaqItem(
      question: 'How do I edit my profile name or photo?',
      answer:
          'Go to Profile → tap "Edit Profile". You can change your display name and profile photo from there.',
    ),
    _FaqItem(
      question: 'How do I archive or delete a note?',
      answer:
          'Open the note, tap the three-dot menu (⋮) in the top right. You can archive or move the note to trash from there.',
    ),
    _FaqItem(
      question: 'How do I recover a deleted note?',
      answer:
          'Go to Profile → Trash. Find your note and tap "Restore". Notes in trash are permanently deleted after 30 days.',
    ),
    _FaqItem(
      question: 'How do I switch between dark and light mode?',
      answer:
          'Go to Settings → Appearance. Choose Light, Dark, or System (follows your phone settings).',
    ),
    _FaqItem(
      question: 'How do I search for a note?',
      answer:
          'Tap the search icon on the home screen. You can search by title, content, tags, or category.',
    ),
    _FaqItem(
      question: 'Can I organize notes into categories?',
      answer:
          'Yes! When creating or editing a note, tap the category chip to assign a category. You can manage categories from Profile → Categories.',
    ),
  ];

  final Set<int> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.support_agent_rounded,
                    color: Colors.white, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('How can we help?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Find answers to common questions below.',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text('Frequently Asked Questions',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),

          // FAQs
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              children: _faqs.asMap().entries.map((e) {
                final idx = e.key;
                final faq = e.value;
                final isExpanded = _expanded.contains(idx);
                final isLast = idx == _faqs.length - 1;
                return Column(
                  children: [
                    ListTile(
                      title: Text(faq.question,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20),
                      ),
                      onTap: () => setState(() {
                        if (isExpanded) {
                          _expanded.remove(idx);
                        } else {
                          _expanded.add(idx);
                        }
                      }),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Text(faq.answer,
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.6,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary)),
                      ),
                    if (!isLast)
                      Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Contact card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.mail_outline_rounded,
                      color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text('Still need help?',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 10),
                Text(
                    'Contact us at support@${AppConstants.appName.toLowerCase()}.app — we typically reply within 24 hours.',
                    style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}
