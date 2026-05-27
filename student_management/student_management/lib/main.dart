import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

// ═══════════════════════════════════════════════════════
// MODEL
// ═══════════════════════════════════════════════════════
class Student {
  String id;
  String name;
  String rollNumber;
  String email;
  String department;
  String semester;
  double cgpa;
  DateTime enrollmentDate;
  bool isActive;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.email,
    required this.department,
    required this.semester,
    required this.cgpa,
    required this.enrollmentDate,
    this.isActive = true,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  Color get avatarColor {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF3ECFCF),
      const Color(0xFFFF6584),
      const Color(0xFFFFB347),
      const Color(0xFF56CCF2),
      const Color(0xFF6FCF97),
    ];
    return colors[name.length % colors.length];
  }

  String get cgpaGrade {
    if (cgpa >= 3.7) return 'A';
    if (cgpa >= 3.3) return 'A-';
    if (cgpa >= 3.0) return 'B+';
    if (cgpa >= 2.7) return 'B';
    if (cgpa >= 2.3) return 'B-';
    return 'C';
  }
}

// ═══════════════════════════════════════════════════════
// GLOBAL STATE (Simple state management)
// ═══════════════════════════════════════════════════════
class StudentStore {
  static final List<Student> students = [
    Student(
      id: '1',
      name: 'Ali Hassan',
      rollNumber: 'BSCS-F21-101',
      email: 'ali.hassan@cuivehari.edu.pk',
      department: 'Computer Science',
      semester: '6th',
      cgpa: 3.75,
      enrollmentDate: DateTime(2021, 9, 1),
    ),
    Student(
      id: '2',
      name: 'Ayesha Khan',
      rollNumber: 'BSCS-F21-102',
      email: 'ayesha.khan@cuivehari.edu.pk',
      department: 'Computer Science',
      semester: '6th',
      cgpa: 3.90,
      enrollmentDate: DateTime(2021, 9, 1),
    ),
    Student(
      id: '3',
      name: 'Umar Farooq',
      rollNumber: 'BSIT-F22-015',
      email: 'umar.farooq@cuivehari.edu.pk',
      department: 'Information Technology',
      semester: '4th',
      cgpa: 2.85,
      enrollmentDate: DateTime(2022, 9, 1),
    ),
    Student(
      id: '4',
      name: 'Sara Malik',
      rollNumber: 'BSSE-F21-033',
      email: 'sara.malik@cuivehari.edu.pk',
      department: 'Software Engineering',
      semester: '6th',
      cgpa: 3.50,
      enrollmentDate: DateTime(2021, 9, 1),
    ),
  ];

  static String generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();
}

// ═══════════════════════════════════════════════════════
// ROOT APP
// ═══════════════════════════════════════════════════════
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUI Student Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SCREEN 0 : SPLASH / TITLE SCREEN
// ═══════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _titleSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(_pulseController);

    // Sequence the animations
    _logoController.forward().then((_) {
      _textController.forward();
    });

    // Navigate after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const StudentListScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B4B),
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF1565C0),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles background
            ..._buildDecorativeCircles(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // University Logo / App Icon
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (_, __) => Transform.scale(
                            scale: _pulse.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'CUI',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1A237E),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Title text
                  SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleOpacity,
                      child: Column(
                        children: [
                          const Text(
                            'COMSATS University',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3,
                            ),
                          ),
                          const Text(
                            'Islamabad',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 60,
                            height: 2,
                            color: Colors.amber,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          const Text(
                            'Vehari Campus',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // App name
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'Student Management System',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'CSC303 — Mobile Application Development',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Assignment No. 3',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Loading indicator
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom info
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _subtitleOpacity,
                child: const Column(
                  children: [
                    Text(
                      'CLO-3: Flutter & Navigation Concepts',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Developed with Flutter 3.x',
                      style: TextStyle(color: Colors.white24, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDecorativeCircles() {
    return [
      Positioned(
        top: -60,
        right: -60,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.04),
          ),
        ),
      ),
      Positioned(
        bottom: 100,
        left: -80,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.03),
          ),
        ),
      ),
      Positioned(
        top: 200,
        left: -40,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade200.withOpacity(0.08),
          ),
        ),
      ),
      Positioned(
        bottom: 200,
        right: -30,
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.withOpacity(0.06),
          ),
        ),
      ),
    ];
  }
}

// ═══════════════════════════════════════════════════════
// SCREEN 1 : Student List Screen (with Search + Stats)
// ═══════════════════════════════════════════════════════
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _filterDept = 'All';
  bool _showSearch = false;
  late AnimationController _fabController;

  final List<String> _departments = [
    'All',
    'Computer Science',
    'Information Technology',
    'Software Engineering',
  ];

  List<Student> get _filteredStudents {
    return StudentStore.students.where((s) {
      final matchSearch =
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.rollNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchDept = _filterDept == 'All' || s.department == _filterDept;
      return matchSearch && matchDept;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _showSnackBar(String msg, Color color, {IconData? icon}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  void _navigateToAdd() async {
    final result = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditStudentScreen()),
    );
    if (result != null) {
      setState(() => StudentStore.students.add(result));
      _showSnackBar(
        '${result.name} added successfully!',
        Colors.green.shade700,
        icon: Icons.check_circle,
      );
    }
  }

  void _navigateToDetails(Student student) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailsScreen(student: student),
      ),
    );
    if (result == 'deleted' || result == 'updated') {
      setState(() {});
      if (result == 'deleted') {
        _showSnackBar('Student deleted.', Colors.red.shade700,
            icon: Icons.delete);
      } else {
        _showSnackBar('Student updated successfully!', Colors.blue.shade700,
            icon: Icons.edit);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredStudents;
    final totalStudents = StudentStore.students.length;
    final activeStudents = StudentStore.students.where((s) => s.isActive).length;
    final avgCgpa = totalStudents > 0
        ? StudentStore.students.map((s) => s.cgpa).reduce((a, b) => a + b) /
        totalStudents
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar (collapsible) ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF1A237E),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D1B4B), Color(0xFF1565C0)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Student Manager',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text(
                          'COMSATS University — Vehari Campus',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Stats row
                        Row(
                          children: [
                            _statChip(
                                Icons.people, '$totalStudents', 'Total'),
                            const SizedBox(width: 10),
                            _statChip(
                                Icons.check_circle, '$activeStudents', 'Active'),
                            const SizedBox(width: 10),
                            _statChip(Icons.star,
                                avgCgpa.toStringAsFixed(2), 'Avg CGPA'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_showSearch ? Icons.close : Icons.search,
                    color: Colors.white),
                onPressed: () => setState(() {
                  _showSearch = !_showSearch;
                  if (!_showSearch) _searchQuery = '';
                }),
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const StatisticsDashboardScreen()),
                ),
              ),
            ],
          ),

          // ── Search Bar ──
          if (_showSearch)
            SliverToBoxAdapter(
              child: Container(
                color: const Color(0xFF1A237E),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  autofocus: true,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by name, roll no, email...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon:
                    const Icon(Icons.search, color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),

          // ── Department Filter Chips ──
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              color: const Color(0xFF1A237E),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _departments.length,
                itemBuilder: (_, i) {
                  final dept = _departments[i];
                  final isSelected = _filterDept == dept;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filterDept = dept),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.amber
                              : Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dept == 'All'
                              ? 'All'
                              : dept.replaceAll(' ', '\n').split('\n').first,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF0D1B4B)
                                : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Results count ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '${filtered.length} student${filtered.length != 1 ? 's' : ''} found',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // ── Student List ──
          filtered.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined,
                      size: 70, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'No students match your search.'
                        : 'No students yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final student = filtered[index];
                return _StudentCard(
                  student: student,
                  onTap: () => _navigateToDetails(student),
                );
              },
              childCount: filtered.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabController,
        child: FloatingActionButton.extended(
          onPressed: _navigateToAdd,
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.person_add),
          label: const Text(
            'Add Student',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 6,
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.amber, size: 14),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Text(label,
                  style:
                  const TextStyle(color: Colors.white60, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Student Card Widget ──
class _StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const _StudentCard({required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: student.avatarColor,
                  child: Text(
                    student.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        student.rollNumber,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        student.department,
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // CGPA badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _cgpaColor(student.cgpa).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        student.cgpa.toStringAsFixed(2),
                        style: TextStyle(
                          color: _cgpaColor(student.cgpa),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.semester,
                      style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right,
                    color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _cgpaColor(double cgpa) {
    if (cgpa >= 3.5) return Colors.green.shade700;
    if (cgpa >= 2.5) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}

// ═══════════════════════════════════════════════════════
// SCREEN 2 : Add / Edit Student Screen
// ═══════════════════════════════════════════════════════
class AddEditStudentScreen extends StatefulWidget {
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _rollCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _cgpaCtrl;
  String _selectedDept = 'Computer Science';
  String _selectedSemester = '1st';
  bool _isLoading = false;

  bool get _isEdit => widget.student != null;

  final List<String> _departments = [
    'Computer Science',
    'Information Technology',
    'Software Engineering',
    'Electrical Engineering',
  ];

  final List<String> _semesters = [
    '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th',
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _rollCtrl = TextEditingController(text: s?.rollNumber ?? '');
    _emailCtrl = TextEditingController(text: s?.email ?? '');
    _cgpaCtrl =
        TextEditingController(text: s != null ? s.cgpa.toString() : '');
    _selectedDept = s?.department ?? 'Computer Science';
    _selectedSemester = s?.semester ?? '1st';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rollCtrl.dispose();
    _emailCtrl.dispose();
    _cgpaCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600)); // UX delay

    final student = Student(
      id: _isEdit ? widget.student!.id : StudentStore.generateId(),
      name: _nameCtrl.text.trim(),
      rollNumber: _rollCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      department: _selectedDept,
      semester: _selectedSemester,
      cgpa: double.parse(_cgpaCtrl.text.trim()),
      enrollmentDate:
      _isEdit ? widget.student!.enrollmentDate : DateTime.now(),
      isActive: _isEdit ? widget.student!.isActive : true,
    );

    if (_isEdit) {
      final idx =
      StudentStore.students.indexWhere((s) => s.id == widget.student!.id);
      if (idx != -1) StudentStore.students[idx] = student;
      Navigator.pop(context, 'updated');
    } else {
      Navigator.pop(context, student);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: Text(
          _isEdit ? 'Edit Student' : 'Add New Student',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF1565C0)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        _isEdit ? Icons.edit : Icons.person_add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEdit ? 'Update Record' : 'New Student',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          'Fill in all required fields',
                          style:
                          TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Personal Info section
              _sectionLabel('Personal Information'),
              const SizedBox(height: 10),
              _buildField(
                controller: _nameCtrl,
                label: 'Full Name *',
                icon: Icons.person,
                hint: 'e.g. Ali Hassan',
                cap: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name is required'
                    : null,
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _emailCtrl,
                label: 'Email Address *',
                icon: Icons.email,
                hint: 'student@cuivehari.edu.pk',
                keyboard: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Email is required';
                  final rx = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!rx.hasMatch(v.trim())) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Academic Info section
              _sectionLabel('Academic Information'),
              const SizedBox(height: 10),
              _buildField(
                controller: _rollCtrl,
                label: 'Roll Number *',
                icon: Icons.badge,
                hint: 'e.g. BSCS-F21-101',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Roll number is required'
                    : null,
              ),
              const SizedBox(height: 12),

              // Department Dropdown
              _buildDropdown(
                label: 'Department',
                icon: Icons.school,
                value: _selectedDept,
                items: _departments,
                onChanged: (v) => setState(() => _selectedDept = v!),
              ),
              const SizedBox(height: 12),

              // Semester + CGPA row
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Semester',
                      icon: Icons.calendar_today,
                      value: _selectedSemester,
                      items: _semesters,
                      onChanged: (v) =>
                          setState(() => _selectedSemester = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      controller: _cgpaCtrl,
                      label: 'CGPA *',
                      icon: Icons.star,
                      hint: '0.00 - 4.00',
                      keyboard:
                      const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'CGPA required';
                        final d = double.tryParse(v.trim());
                        if (d == null) return 'Invalid number';
                        if (d < 0 || d > 4.0) return '0.00 to 4.00';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isEdit ? Icons.save : Icons.add_circle),
                      const SizedBox(width: 8),
                      Text(
                        _isEdit ? 'Update Student' : 'Add Student',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: Color(0xFF1A237E)),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(
                          fontSize: 15, color: Color(0xFF1A237E))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    TextCapitalization cap = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textCapitalization: cap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items
          .map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis)))
          .toList(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SCREEN 3 : Student Details Screen
// ═══════════════════════════════════════════════════════
class StudentDetailsScreen extends StatefulWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Delete Student'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete:',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_student.name}\n${_student.rollNumber}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              StudentStore.students
                  .removeWhere((s) => s.id == _student.id);
              Navigator.pop(context); // close dialog
              Navigator.pop(context, 'deleted');
            },
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
          builder: (_) => AddEditStudentScreen(student: _student)),
    );
    if (result == 'updated') {
      // Refresh from store
      final updated =
      StudentStore.students.firstWhere((s) => s.id == _student.id);
      setState(() => _student = updated);
      Navigator.pop(context, 'updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: CustomScrollView(
        slivers: [
          // ── Profile Header ──
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: _student.avatarColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _student.avatarColor,
                      _student.avatarColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Big avatar
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.25),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                              width: 3),
                        ),
                        child: Center(
                          child: Text(
                            _student.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _student.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _student.rollNumber,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _student.isActive ? '● Active' : '○ Inactive',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _navigateToEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: _confirmDelete,
              ),
            ],
          ),

          // ── Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // CGPA Card
                  _cgpaCard(),
                  const SizedBox(height: 16),

                  // Info Cards
                  _infoCard(
                    title: 'Contact Information',
                    icon: Icons.contact_mail,
                    items: [
                      _InfoItem(Icons.email, 'Email', _student.email),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoCard(
                    title: 'Academic Details',
                    icon: Icons.school,
                    items: [
                      _InfoItem(Icons.business, 'Department',
                          _student.department),
                      _InfoItem(
                          Icons.calendar_today, 'Semester', _student.semester),
                      _InfoItem(
                          Icons.date_range,
                          'Enrollment Date',
                          '${_student.enrollmentDate.day}/${_student.enrollmentDate.month}/${_student.enrollmentDate.year}'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          label: 'Edit Student',
                          icon: Icons.edit,
                          color: const Color(0xFF1A237E),
                          onTap: _navigateToEdit,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          label: 'Delete',
                          icon: Icons.delete,
                          color: Colors.red.shade700,
                          onTap: _confirmDelete,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Toggle active status
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final idx = StudentStore.students
                            .indexWhere((s) => s.id == _student.id);
                        if (idx != -1) {
                          StudentStore.students[idx].isActive =
                          !_student.isActive;
                          setState(() =>
                          _student = StudentStore.students[idx]);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(_student.isActive
                              ? 'Student marked as Active'
                              : 'Student marked as Inactive'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: _student.isActive
                              ? Colors.green
                              : Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(12),
                        ));
                      },
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(
                            color: _student.isActive
                                ? Colors.orange
                                : Colors.green),
                      ),
                      icon: Icon(
                        _student.isActive
                            ? Icons.toggle_off
                            : Icons.toggle_on,
                        color: _student.isActive
                            ? Colors.orange
                            : Colors.green,
                      ),
                      label: Text(
                        _student.isActive
                            ? 'Mark as Inactive'
                            : 'Mark as Active',
                        style: TextStyle(
                          color: _student.isActive
                              ? Colors.orange
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _cgpaCard() {
    final color = _student.cgpa >= 3.5
        ? Colors.green.shade700
        : _student.cgpa >= 2.5
        ? Colors.orange.shade700
        : Colors.red.shade700;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Text(
              _student.cgpaGrade,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current CGPA',
                    style:
                    TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  _student.cgpa.toStringAsFixed(2),
                  style: TextStyle(
                    color: color,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          // CGPA bar
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _student.cgpa / 4.0,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 8,
                ),
                Text(
                  '${((_student.cgpa / 4.0) * 100).toInt()}%',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required IconData icon,
    required List<_InfoItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1A237E), size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(item.icon, color: Colors.grey, size: 18),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label,
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(item.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  _InfoItem(this.icon, this.label, this.value);
}

// ═══════════════════════════════════════════════════════
// SCREEN 4 : Statistics Dashboard (BONUS)
// ═══════════════════════════════════════════════════════
class StatisticsDashboardScreen extends StatelessWidget {
  const StatisticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = StudentStore.students;
    final total = students.length;
    final active = students.where((s) => s.isActive).length;
    final avgCgpa = total > 0
        ? students.map((s) => s.cgpa).reduce((a, b) => a + b) / total
        : 0.0;
    final topStudent = total > 0
        ? students.reduce((a, b) => a.cgpa > b.cgpa ? a : b)
        : null;

    // Dept distribution
    final deptMap = <String, int>{};
    for (final s in students) {
      deptMap[s.department] = (deptMap[s.department] ?? 0) + 1;
    }

    // Semester distribution
    final semMap = <String, int>{};
    for (final s in students) {
      semMap[s.semester] = (semMap[s.semester] ?? 0) + 1;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('Statistics Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(
                    child: _summaryCard('Total', '$total', Icons.people,
                        const Color(0xFF1A237E))),
                const SizedBox(width: 12),
                Expanded(
                    child: _summaryCard('Active', '$active', Icons.check_circle,
                        Colors.green.shade700)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _summaryCard('Avg CGPA',
                        avgCgpa.toStringAsFixed(2), Icons.star, Colors.amber.shade700)),
                const SizedBox(width: 12),
                Expanded(
                    child: _summaryCard(
                        'Departments',
                        '${deptMap.length}',
                        Icons.business,
                        Colors.purple.shade700)),
              ],
            ),
            const SizedBox(height: 20),

            // Top student
            if (topStudent != null) ...[
              _sectionTitle('Top Performer'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade600, Colors.orange.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events,
                        color: Colors.white, size: 40),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(topStudent.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(topStudent.rollNumber,
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Text(
                      topStudent.cgpa.toStringAsFixed(2),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Department breakdown
            _sectionTitle('By Department'),
            const SizedBox(height: 10),
            ...deptMap.entries.map((e) {
              final pct = total > 0 ? e.value / total : 0.0;
              final colors = [
                const Color(0xFF6C63FF),
                const Color(0xFF3ECFCF),
                const Color(0xFFFF6584),
                const Color(0xFFFFB347),
              ];
              final color = colors[deptMap.keys.toList().indexOf(e.key) %
                  colors.length];
              return _deptBar(e.key, e.value, pct, color);
            }),
            const SizedBox(height: 20),

            // All students CGPA list
            _sectionTitle('CGPA Ranking'),
            const SizedBox(height: 10),
            ...(() {
              final sorted = List<Student>.from(students)
                ..sort((a, b) => b.cgpa.compareTo(a.cgpa));
              return sorted.asMap().entries.map((entry) {
                final i = entry.key;
                final s = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: i == 0
                              ? Colors.amber
                              : i == 1
                              ? Colors.grey.shade300
                              : i == 2
                              ? Colors.brown.shade300
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${i + 1}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: i < 3
                                      ? Colors.white
                                      : Colors.grey)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(s.rollNumber,
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        s.cgpa.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: s.cgpa >= 3.5
                              ? Colors.green.shade700
                              : s.cgpa >= 2.5
                              ? Colors.orange.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              });
            })(),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, color: color)),
          Text(label,
              style:
              TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E)));

  Widget _deptBar(String dept, int count, double pct, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(dept,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Text('$count student${count != 1 ? 's' : ''}',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}