import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CVViewScreen extends StatelessWidget {
  const CVViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        title: const Text(
          'Professional CV',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading CV...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: const CVBody(),
    );
  }
}

// Main Body
class CVBody extends StatelessWidget {
  const CVBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          CVHeader(),
          SizedBox(height: 30),
          CVSections(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// Header
class CVHeader extends StatelessWidget {
  const CVHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF3B3486),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: const Column(
        children: [
          ProfileAvatar(),
          SizedBox(height: 20),
          Text(
            'Farhat',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Computer Science Student',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(255, 255, 255, 0.7),
            ),
          ),
          SizedBox(height: 20),
          ContactRow(),
        ],
      ),
    );
  }
}

// Profile Avatar
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        size: 60,
        color: Color(0xFF6C63FF),
      ),
    );
  }
}

// Contact Row
class ContactRow extends StatelessWidget {
  const ContactRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ContactItem(icon: Icons.email, text: 'farhat@example.com'),
        SizedBox(width: 20),
        ContactItem(icon: Icons.phone, text: '+92 XXX XXXXXXX'),
        SizedBox(width: 20),
        ContactItem(icon: Icons.location_on, text: 'Vehari, Pakistan'),
      ],
    );
  }
}

// Contact Item
class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color.fromRGBO(255, 255, 255, 0.7), size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.7),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// CV Sections
class CVSections extends StatelessWidget {
  const CVSections({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          PersonalSection(),
          SizedBox(height: 25),
          SummarySection(),
          SizedBox(height: 25),
          EducationSection(),
          SizedBox(height: 25),
          AchievementsSection(),
          SizedBox(height: 25),
          SkillsSection(),
        ],
      ),
    );
  }
}

// Section Card
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget content;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title, icon: icon),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }
}

// Section Title
class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(108, 99, 255, 0.1),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }
}

// Personal Section
class PersonalSection extends StatelessWidget {
  const PersonalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: 'Personal Information',
      icon: FontAwesomeIcons.idCard,
      content: Column(
        children: [
          InfoRow(label: 'Full Name', value: 'Farhat'),
          InfoRow(label: 'Height', value: '5.7'),
          InfoRow(label: 'Education', value: 'Undergraduate'),
          InfoRow(label: 'Field', value: 'Computer Science'),
          InfoRow(label: 'University', value: 'COMSATS Vehari'),
          InfoRow(label: 'Location', value: 'Vehari, Pakistan'),
        ],
      ),
    );
  }
}

// Info Row
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(128, 128, 128, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Summary Section
class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: 'Professional Summary',
      icon: FontAwesomeIcons.userTie,
      content: Text(
        'Dedicated Computer Science student with a strong academic background and passion for mobile application development and E-Commerce solutions. Proficient in Flutter framework and Dart programming.',
        style: TextStyle(
          fontSize: 15,
          color: Color.fromRGBO(128, 128, 128, 1),
          height: 1.6,
        ),
      ),
    );
  }
}

// Education Section
class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: 'Education',
      icon: FontAwesomeIcons.graduationCap,
      content: Column(
        children: [
          EduItem(
            degree: 'BS Computer Science',
            school: 'COMSATS University Vehari',
            status: 'Present',
            marks: null,
            isCurrent: true,
          ),
          Divider(height: 30),
          EduItem(
            degree: 'FSc Pre-Engineering',
            school: 'Aspire College, Vehari',
            status: 'Completed',
            marks: '1010/1100',
            isCurrent: false,
          ),
          Divider(height: 30),
          EduItem(
            degree: 'Matriculation',
            school: 'Alfurqan High School',
            status: 'Completed',
            marks: '1050/1100',
            isCurrent: false,
          ),
        ],
      ),
    );
  }
}

// Education Item
class EduItem extends StatelessWidget {
  final String degree;
  final String school;
  final String status;
  final String? marks;
  final bool isCurrent;

  const EduItem({
    super.key,
    required this.degree,
    required this.school,
    required this.status,
    this.marks,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: isCurrent ? const Color(0xFF6C63FF) : const Color.fromRGBO(189, 189, 189, 1),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                degree,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                school,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(128, 128, 128, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  StatusBadge(text: status, isCurrent: isCurrent),
                  if (marks != null) ...[
                    const SizedBox(width: 8),
                    MarksBadge(marks: marks!),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Status Badge
class StatusBadge extends StatelessWidget {
  final String text;
  final bool isCurrent;

  const StatusBadge({super.key, required this.text, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color.fromRGBO(108, 99, 255, 0.1)
            : const Color.fromRGBO(238, 238, 238, 1),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isCurrent ? const Color(0xFF6C63FF) : const Color.fromRGBO(97, 97, 97, 1),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Marks Badge
class MarksBadge extends StatelessWidget {
  final String marks;

  const MarksBadge({super.key, required this.marks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 184, 148, 0.1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        marks,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF00B894),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Achievements Section
class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: 'Academic Achievements',
      icon: FontAwesomeIcons.trophy,
      content: Column(
        children: [
          AchievementCard(
            title: 'Matriculation Excellence',
            subtitle: 'Scored 1050/1100 marks',
            icon: FontAwesomeIcons.school,
            color: Color(0xFFE17055),
          ),
          SizedBox(height: 12),
          AchievementCard(
            title: 'FSc Distinction',
            subtitle: 'Scored 1010/1100 marks',
            icon: FontAwesomeIcons.buildingColumns,
            color: Color(0xFF00B894),
          ),
        ],
      ),
    );
  }
}

// Achievement Card
class AchievementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AchievementCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(r, g, b, 0.1),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color.fromRGBO(r, g, b, 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(r, g, b, 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(128, 128, 128, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Skills Section
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: 'Technical Skills',
      icon: FontAwesomeIcons.code,
      content: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          SkillChip(label: 'E-Commerce'),
          SkillChip(label: 'Flutter'),
          SkillChip(label: 'Dart'),
          SkillChip(label: 'Mobile Dev'),
          SkillChip(label: 'UI/UX'),
          SkillChip(label: 'Problem Solving'),
          SkillChip(label: 'Programming'),
          SkillChip(label: 'Git & GitHub'),
          SkillChip(label: 'Firebase'),
          SkillChip(label: 'REST APIs'),
        ],
      ),
    );
  }
}

// Skill Chip
class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3B3486)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(108, 99, 255, 0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}