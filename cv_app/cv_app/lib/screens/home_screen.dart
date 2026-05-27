import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'cv_view_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          // Glowing App Bar
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF6C63FF),
                      Color(0xFF1A1A2E),
                      Color(0xFF0A0A0A),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Glowing Avatar
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Farhat',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color(0xFF6C63FF),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Computer Science Student',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(255, 255, 255, 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'COMSATS University Vehari',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00B894),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Neon Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildNeonButton(
                          icon: Icons.visibility,
                          label: 'View CV',
                          color: const Color(0xFF6C63FF),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CVViewScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNeonButton(
                          icon: Icons.download,
                          label: 'Download',
                          color: const Color(0xFF00B894),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Section Title
                  _buildSectionTitle('Education', FontAwesomeIcons.graduationCap),

                  const SizedBox(height: 20),

                  // Glowing Education Cards
                  _buildGlowingCard(
                    title: 'BS Computer Science',
                    subtitle: 'COMSATS University Vehari',
                    detail: 'Currently Studying',
                    icon: FontAwesomeIcons.laptopCode,
                    accentColor: const Color(0xFF6C63FF),
                  ),

                  const SizedBox(height: 16),

                  _buildGlowingCard(
                    title: 'FSc Pre-Engineering',
                    subtitle: 'Aspire College, Vehari',
                    detail: 'Marks: 1010/1100',
                    icon: FontAwesomeIcons.buildingColumns,
                    accentColor: const Color(0xFF00B894),
                  ),

                  const SizedBox(height: 16),

                  _buildGlowingCard(
                    title: 'Matriculation',
                    subtitle: 'Alfurqan High School',
                    detail: 'Marks: 1050/1100',
                    icon: FontAwesomeIcons.school,
                    accentColor: const Color(0xFFE17055),
                  ),

                  const SizedBox(height: 30),

                  // Stats Section
                  _buildSectionTitle('Academic Excellence', FontAwesomeIcons.trophy),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('1050', 'Matric', const Color(0xFFE17055)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('1010', 'FSc', const Color(0xFF00B894)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Skills Section
                  _buildSectionTitle('Skills', FontAwesomeIcons.code),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildSkillChip('E-Commerce', const Color(0xFF00B894)),
                      _buildSkillChip('Flutter', const Color(0xFF6C63FF)),
                      _buildSkillChip('Dart', const Color(0xFF00BCD4)),
                      _buildSkillChip('Mobile Dev', const Color(0xFFE91E63)),
                      _buildSkillChip('UI/UX', const Color(0xFFFF9800)),
                      _buildSkillChip('Height 5.7', const Color(0xFF9C27B0)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Contact Section
                  _buildSectionTitle('Contact', FontAwesomeIcons.envelope),

                  const SizedBox(height: 20),

                  _buildContactCard(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGlowingCard({
    required String title,
    required String subtitle,
    required String detail,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.8),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '/1100',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
        ),
      ),
      child: const Column(
        children: [
          ContactItem(icon: Icons.email, label: 'Email', value: 'farhat@example.com'),
          Divider(height: 24, color: Color.fromRGBO(255, 255, 255, 0.1)),
          ContactItem(icon: Icons.phone, label: 'Phone', value: '+92 XXX XXXXXXX'),
          Divider(height: 24, color: Color.fromRGBO(255, 255, 255, 0.1)),
          ContactItem(icon: Icons.location_on, label: 'Location', value: 'Vehari, Pakistan'),
        ],
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: const Icon(Icons.email, color: Color(0xFF6C63FF), size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}