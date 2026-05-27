import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/semester.dart';
import '../providers/cgpa_provider.dart';
import '../theme/app_theme.dart';
import 'semester_detail_screen.dart';
import 'add_semester_screen.dart';
import 'cgpa_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('CGPA Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CGPAAnalysisScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkGradient,
        ),
        child: SafeArea(
          child: Consumer<CGPAProvider>(
            builder: (context, provider, child) {
              final cgpa = provider.getCGPA;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildCGPACard(cgpa),
                  ),
                  SliverToBoxAdapter(
                    child: _buildStatsRow(provider),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Semesters',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE94560).withAlpha(51),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${provider.semesters.length} Total',
                              style: const TextStyle(
                                color: Color(0xFFE94560),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: provider.semesters.isEmpty
                        ? SliverToBoxAdapter(
                      child: _buildEmptyState(),
                    )
                        : SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final semester = provider.semesters[index];
                          final gpa = provider.getSemesterGPA(semester.id);
                          return _buildSemesterCard(semester, gpa, index);
                        },
                        childCount: provider.semesters.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddSemesterScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New Semester'),
      ),
    );
  }

  Widget _buildCGPACard(double cgpa) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withAlpha(102),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Cumulative GPA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildCGPABadge(cgpa),
            ],
          ),
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFFFD700)],
            ).createShader(bounds),
            child: Text(
              cgpa.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _getClassStanding(cgpa),
            style: TextStyle(
              color: Colors.white.withAlpha(230),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: cgpa / 4.0,
              backgroundColor: Colors.white.withAlpha(51),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCGPABadge(double cgpa) {
    Color color;
    String label;

    if (cgpa >= 3.7) {
      color = const Color(0xFFFFD700);
      label = 'Excellent';
    } else if (cgpa >= 3.0) {
      color = const Color(0xFF00D9FF);
      label = 'Good';
    } else if (cgpa >= 2.0) {
      color = const Color(0xFFFFA502);
      label = 'Average';
    } else {
      color = const Color(0xFFFF4757);
      label = 'Poor';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(127)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatsRow(CGPAProvider provider) {
    final totalCourses = provider.allCourses.length;
    final totalCredits = provider.allCourses.fold<double>(
      0,
          (sum, course) => sum + course.creditHours,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard('Courses', totalCourses.toString(), Icons.book, const Color(0xFF00D9FF)),
          const SizedBox(width: 12),
          _buildStatCard('Credits', totalCredits.toStringAsFixed(1), Icons.timelapse, const Color(0xFFFFA502)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(76)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withAlpha(153),
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterCard(Semester semester, double gpa, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),  // ✅ FIXED: Gradient remove
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getGPAColor(gpa).withAlpha(76),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SemesterDetailScreen(semester: semester),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: _getGPAGradient(gpa),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        semester.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Year ${semester.year}',
                        style: TextStyle(
                          color: Colors.white.withAlpha(153),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _getGPAColor(gpa).withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    gpa.toStringAsFixed(2),
                    style: TextStyle(
                      color: _getGPAColor(gpa),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 100,
            color: Colors.white.withAlpha(51),
          ),
          const SizedBox(height: 20),
          Text(
            'No Semesters Yet',
            style: TextStyle(
              color: Colors.white.withAlpha(153),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add your first semester to start tracking',
            style: TextStyle(
              color: Colors.white.withAlpha(102),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGPAGradient(double gpa) {
    if (gpa >= 3.5) {
      return const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      );
    }
    if (gpa >= 3.0) {
      return const LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      );
    }
    if (gpa >= 2.5) {
      return const LinearGradient(
        colors: [Color(0xFFFFA502), Colors.orange],
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFFF4757), Colors.red],
    );
  }

  Color _getGPAColor(double gpa) {
    if (gpa >= 3.5) return const Color(0xFFFFD700);
    if (gpa >= 3.0) return const Color(0xFF00D9FF);
    if (gpa >= 2.5) return const Color(0xFFFFA502);
    return const Color(0xFFFF4757);
  }

  String _getClassStanding(double cgpa) {
    if (cgpa >= 3.8) return 'Summa Cum Laude';
    if (cgpa >= 3.6) return 'Magna Cum Laude';
    if (cgpa >= 3.4) return 'Cum Laude';
    if (cgpa >= 3.0) return 'Good Standing';
    if (cgpa >= 2.0) return 'Satisfactory';
    return 'Academic Probation';
  }
}