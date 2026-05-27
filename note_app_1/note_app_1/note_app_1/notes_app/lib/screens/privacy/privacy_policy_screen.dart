import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                const Icon(Icons.privacy_tip_rounded,
                    color: Colors.white, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Privacy Matters',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Last updated: April 2025',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildSection(
            context, isDark,
            icon: Icons.info_outline_rounded,
            title: 'Introduction',
            body:
                '${AppConstants.appName} ("we", "our", or "us") is committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.storage_rounded,
            title: 'Data We Collect',
            body:
                '• Your email address (for login and account management)\n'
                '• Notes, voice recordings, and images you create\n'
                '• App preferences and settings\n'
                '• Reminder dates and times\n\n'
                'We do NOT collect your location, contacts, or any data beyond what is needed to run the app.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.phone_android_rounded,
            title: 'Local Storage',
            body:
                'Your notes are stored locally on your device using SQLite. Voice recordings and images are stored in the app\'s private directory and are never shared with third parties.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.cloud_rounded,
            title: 'Firebase & Cloud',
            body:
                'We use Firebase Authentication for secure login. Your email is stored with Firebase to manage your account. Notes are not synced to the cloud unless you explicitly enable backup.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.share_rounded,
            title: 'Data Sharing',
            body:
                'We do not sell, rent, or share your personal data with any third parties. We only use Firebase services (governed by Google\'s Privacy Policy) for authentication purposes.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            body:
                'If you set reminders, the app will request permission to send local notifications. These notifications are generated on your device and do not involve any external servers.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.mic_outlined,
            title: 'Microphone & Camera',
            body:
                'The app requests microphone access only when you record a voice note, and camera/storage access only when you attach a photo. These permissions are used solely for the features you explicitly activate.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.delete_outline_rounded,
            title: 'Data Deletion',
            body:
                'You can delete your notes at any time from within the app. To permanently delete your account and all associated data, sign out and contact us at support@${AppConstants.appName.toLowerCase()}.app.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.update_rounded,
            title: 'Changes to This Policy',
            body:
                'We may update this Privacy Policy from time to time. We will notify you of significant changes via the app. Continued use of the app after changes constitutes acceptance of the updated policy.',
          ),
          _buildSection(
            context, isDark,
            icon: Icons.mail_outline_rounded,
            title: 'Contact Us',
            body:
                'For any privacy-related questions or data requests, contact us at:\nsupport@${AppConstants.appName.toLowerCase()}.app',
          ),

          const SizedBox(height: 8),
          Center(
            child: Text(
              '© 2025 ${AppConstants.appName}. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, bool isDark,
      {required IconData icon,
      required String title,
      required String body}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 10),
          Text(body,
              style: TextStyle(
                  fontSize: 13,
                  height: 1.65,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)),
        ],
      ),
    );
  }
}
