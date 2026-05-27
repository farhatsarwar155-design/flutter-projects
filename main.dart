import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

// ==================== THEME & COLORS ====================
class AppColors {
  static const Color primary = Color(0xFF7C6EFA);
  static const Color primaryDark = Color(0xFF5A4FD1);
  static const Color secondary = Color(0xFF00D4AA);
  static const Color accent = Color(0xFFFF6B8A);
  static const Color gold = Color(0xFFFFBB44);
  static const Color darkBackground = Color(0xFF0A0A14);
  static const Color cardDark = Color(0xFF13131F);
  static const Color cardLight = Color(0xFF1E1E30);
  static const Color cardBorder = Color(0xFF2A2A40);
  static const Color textLight = Color(0xFFF0F0FF);
  static const Color textMuted = Color(0xFF6B6B8A);
  static const Color underweight = Color(0xFF4CC9F0);
  static const Color normal = Color(0xFF4ADE80);
  static const Color overweight = Color(0xFFFFB347);
  static const Color obese = Color(0xFFFF4757);
  static const Color purple = Color(0xFFB44FFA);
  static const Color cyan = Color(0xFF00D4FF);
}

// ==================== BMI MODEL ====================
class BMIRecord {
  final String id;
  final String name;
  final String gender;
  final double heightCm;
  final double weightKg;
  final int age;
  final double bmi;
  final String category;
  final int colorValue;
  final String date;
  final String? note;

  BMIRecord({
    required this.id,
    required this.name,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.age,
    required this.bmi,
    required this.category,
    required this.colorValue,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gender': gender,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'age': age,
    'bmi': bmi,
    'category': category,
    'colorValue': colorValue,
    'date': date,
    'note': note,
  };

  factory BMIRecord.fromJson(Map<String, dynamic> json) {
    int parsedColor;
    final rawColor = json['colorValue'] ?? json['color'];
    if (rawColor is int) {
      parsedColor = rawColor;
    } else if (rawColor is String) {
      parsedColor = int.tryParse(rawColor) ?? 0xFF4ADE80;
    } else {
      parsedColor = 0xFF4ADE80;
    }

    return BMIRecord(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? 'Male',
      heightCm: (json['heightCm'] ?? json['height'] ?? 170).toDouble(),
      weightKg: (json['weightKg'] ?? json['weight'] ?? 70).toDouble(),
      age: (json['age'] ?? 25).toInt(),
      bmi: (json['bmi'] ?? 0.0).toDouble(),
      category: json['category']?.toString() ?? '',
      colorValue: parsedColor,
      date: json['date']?.toString() ?? '',
      note: json['note']?.toString(),
    );
  }

  // Helper to safely get Color from colorValue
  Color get bmiColor {
    // Ensure alpha channel is set
    final int safeValue = colorValue | 0xFF000000;
    return Color(safeValue);
  }
}

// ==================== BMI SERVICE ====================
class BMIService {
  static const String _key = 'bmi_records_v2';
  static const String _favoritesKey = 'favorite_records';
  static const String _goalsKey = 'bmi_goals_v2';

  static Future<List<BMIRecord>> getRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_key);
      if (data == null || data.isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(data);
      debugPrint('Loaded ${jsonList.length} records from storage');
      return jsonList
          .map((e) => BMIRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading records: $e');
      return [];
    }
  }

  static Future<bool> saveRecord(BMIRecord record) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getRecords();
      records.add(record);
      final jsonList = records.map((e) => e.toJson()).toList();
      final encoded = jsonEncode(jsonList);
      final result = await prefs.setString(_key, encoded);
      debugPrint('Saved record. Total: ${records.length}, result: $result');
      return result;
    } catch (e) {
      debugPrint('Error saving record: $e');
      return false;
    }
  }

  static Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.removeWhere((r) => r.id == id);
    await prefs.setString(_key, jsonEncode(records.map((e) => e.toJson()).toList()));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_favoritesKey);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<double?> getGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_goalsKey);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> setGoal(double goal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setDouble(_goalsKey, goal);
    } catch (e) {
      return false;
    }
  }

  static Future<String> exportAsText() async {
    final records = await getRecords();
    if (records.isEmpty) return 'No records to export.';
    StringBuffer buffer = StringBuffer();
    buffer.writeln('=== BMI CALCULATOR REPORT ===');
    buffer.writeln('Generated: ${DateTime.now().toString().substring(0, 16)}');
    buffer.writeln('Made by Farhat\n');
    for (var r in records) {
      buffer.writeln('Name: ${r.name}');
      buffer.writeln('Date: ${r.date}');
      buffer.writeln('BMI: ${r.bmi.toStringAsFixed(1)} - ${r.category}');
      buffer.writeln(
          'Details: ${r.gender}, ${r.age}yrs, ${r.weightKg.toStringAsFixed(1)}kg, ${r.heightCm.toInt()}cm');
      if (r.note != null && r.note!.isNotEmpty) {
        buffer.writeln('Note: ${r.note}');
      }
      buffer.writeln('---');
    }
    return buffer.toString();
  }

  static Map<String, dynamic> getStatistics(List<BMIRecord> records) {
    if (records.isEmpty) return {};
    final bmis = records.map((r) => r.bmi).toList()..sort();
    double avg = bmis.reduce((a, b) => a + b) / bmis.length;
    Map<String, int> categories = {};
    for (var r in records) {
      categories[r.category] = (categories[r.category] ?? 0) + 1;
    }
    return {
      'total': records.length,
      'average': avg,
      'min': bmis.first,
      'max': bmis.last,
      'categories': categories,
    };
  }
}

// ==================== HEIGHT CONVERTER ====================
class HeightConverter {
  static double feetInchesToCm(int feet, int inches) {
    return (feet * 30.48) + (inches * 2.54);
  }

  static Map<String, int> cmToFeetInches(double cm) {
    double totalInches = cm / 2.54;
    int feet = totalInches ~/ 12;
    int inches = (totalInches % 12).round();
    if (inches == 12) {
      feet++;
      inches = 0;
    }
    return {'feet': feet, 'inches': inches};
  }
}

// ==================== WEIGHT CONVERTER ====================
class WeightConverter {
  static double lbsToKg(double lbs) => lbs * 0.453592;
  static double kgToLbs(double kg) => kg * 2.20462;
}

// ==================== MAIN APP ====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme:
        GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme:
        const ColorScheme.dark(primary: AppColors.primary),
      ),
      home: const SplashScreen(),
    );
  }
}

// ==================== FOOTER ====================
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_rounded,
                size: 12, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              'Made with love by Farhat',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== REUSABLE GRADIENT BUTTON ====================
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final List<Color> colors;
  final double height;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.colors = const [AppColors.primary, AppColors.secondary],
    this.height = 56,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SPLASH SCREEN ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 1800), vsync: this);
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginPage(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.06),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.monitor_heart_rounded,
                        size: 65, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 36),
                FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      Text(
                        'BMI Calculator',
                        style: GoogleFonts.poppins(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textLight,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'PRO',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your Personal Health Companion',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                FadeTransition(
                  opacity: _fade,
                  child: Container(
                    width: 180,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.cardLight,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.secondary
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(
                      duration: 1200.ms,
                      color: AppColors.primary.withOpacity(0.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', _emailCtrl.text.trim());
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.secondary
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.monitor_heart_rounded,
                          size: 32, color: Colors.white),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: -0.2),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome\nBack! 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textLight,
                        height: 1.15,
                      ),
                    ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1),
                    const SizedBox(height: 8),
                    Text(
                      'Login to continue your health journey',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textMuted),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 44),
                    _buildField(
                      controller: _emailCtrl,
                      hint: 'Email Address',
                      icon: Icons.mail_outline_rounded,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email required';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _passCtrl,
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: _loading
                          ? Center(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.secondary
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        ),
                      )
                          : GradientButton(
                        text: 'Login',
                        onTap: _login,
                        icon: Icons.arrow_forward_rounded,
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_showPass,
      validator: validator,
      style: GoogleFonts.poppins(
          color: AppColors.textLight, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            color: AppColors.textMuted, fontSize: 14),
        prefixIcon:
        Icon(icon, color: AppColors.primary, size: 22),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _showPass
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
          onPressed: () =>
              setState(() => _showPass = !_showPass),
        )
            : null,
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: AppColors.accent, width: 1),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}

// ==================== HOME PAGE ====================
// FIX: Use a GlobalKey-based approach so child pages can be refreshed
// from outside. Each tab page has a refresh method triggered on tab switch.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;

  // Keys to access child state and call refresh
  final GlobalKey<_HistoryPageState> _historyKey =
  GlobalKey<_HistoryPageState>();
  final GlobalKey<_AnalyticsPageState> _analyticsKey =
  GlobalKey<_AnalyticsPageState>();
  final GlobalKey<_ProfilePageState> _profileKey =
  GlobalKey<_ProfilePageState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BMICalculatorPage(onSaved: _onRecordSaved),
      HistoryPage(key: _historyKey),
      AnalyticsPage(key: _analyticsKey),
      ProfilePage(key: _profileKey),
    ];
  }

  // Called by calculator when a record is saved
  void _onRecordSaved() {
    _historyKey.currentState?.reload();
    _analyticsKey.currentState?.reload();
    _profileKey.currentState?.reload();
  }

  void _switchTab(int index) {
    setState(() => _idx = index);
    // Refresh data when switching to history, analytics, or profile tabs
    if (index == 1) _historyKey.currentState?.reload();
    if (index == 2) _analyticsKey.currentState?.reload();
    if (index == 3) _profileKey.currentState?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          border:
          Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.calculate_rounded, 'Calculator'),
                _navItem(1, Icons.history_rounded, 'History'),
                _navItem(2, Icons.bar_chart_rounded, 'Analytics'),
                _navItem(3, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isActive = _idx == index;
    return GestureDetector(
      onTap: () => _switchTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.15),
              AppColors.secondary.withOpacity(0.08),
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight:
                isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== BMI CALCULATOR PAGE ====================
class BMICalculatorPage extends StatefulWidget {
  final VoidCallback? onSaved;
  const BMICalculatorPage({super.key, this.onSaved});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final _nameCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _gender = 'Male';
  bool _useFeet = false;
  bool _useLbs = false;

  double _heightCm = 170;
  int _feet = 5;
  int _inches = 7;

  double _weightKg = 70;
  double _weightLbs = 154;

  int _age = 25;
  double? _bmi;
  String _category = '';
  Color _bmiColor = AppColors.normal;
  double? _goalBMI;
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final goal = await BMIService.getGoal();
    if (mounted) setState(() => _goalBMI = goal);
  }

  @override
  void dispose() {
    _confetti.dispose();
    _nameCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _updateHeightFromSlider(double cm) {
    setState(() {
      _heightCm = cm;
      final fi = HeightConverter.cmToFeetInches(cm);
      _feet = fi['feet']!;
      _inches = fi['inches']!;
    });
  }

  void _updateHeightFromFeetInches() {
    setState(() {
      _heightCm = HeightConverter.feetInchesToCm(_feet, _inches);
    });
  }

  void _updateWeightKg(double kg) {
    setState(() {
      _weightKg = kg;
      _weightLbs = WeightConverter.kgToLbs(kg);
    });
  }

  void _updateWeightLbs(double lbs) {
    setState(() {
      _weightLbs = lbs;
      _weightKg = WeightConverter.lbsToKg(lbs);
    });
  }

  void _calculate() {
    double hM = _heightCm / 100;
    double bmi = _weightKg / (hM * hM);
    setState(() {
      _bmi = bmi;
      if (bmi < 18.5) {
        _category = 'Underweight';
        _bmiColor = AppColors.underweight;
      } else if (bmi < 25.0) {
        _category = 'Normal Weight';
        _bmiColor = AppColors.normal;
        _confetti.play();
      } else if (bmi < 30.0) {
        _category = 'Overweight';
        _bmiColor = AppColors.overweight;
      } else {
        _category = 'Obese';
        _bmiColor = AppColors.obese;
      }
    });
  }

  Future<void> _save() async {
    if (_bmi == null) {
      _showSnack('Please calculate BMI first', AppColors.overweight);
      return;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      _showSnack('Please enter a name', AppColors.accent);
      return;
    }

    // FIX: Store color as a safe int with alpha
    final int safeColorValue =
    (_bmiColor.a.toInt() << 24) |
    (_bmiColor.r.toInt() << 16) |
    (_bmiColor.g.toInt() << 8) |
    _bmiColor.b.toInt();

    final record = BMIRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      gender: _gender,
      heightCm: _heightCm,
      weightKg: _weightKg,
      age: _age,
      bmi: _bmi!,
      category: _category,
      colorValue: safeColorValue,
      date: DateTime.now().toString().substring(0, 16),
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );

    final ok = await BMIService.saveRecord(record);
    if (mounted) {
      if (ok) {
        _showSnack('✓ Record saved successfully!', AppColors.secondary);
        // FIX: Notify parent to refresh other pages
        widget.onSaved?.call();
      } else {
        _showSnack('Failed to save. Try again.', AppColors.accent);
      }
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _reset() {
    setState(() {
      _bmi = null;
      _gender = 'Male';
      _heightCm = 170;
      _feet = 5;
      _inches = 7;
      _weightKg = 70;
      _weightLbs = 154;
      _age = 25;
      _useFeet = false;
      _useLbs = false;
      _nameCtrl.clear();
      _noteCtrl.clear();
    });
  }

  void _showGoalDialog() {
    final ctrl =
    TextEditingController(text: _goalBMI?.toStringAsFixed(1) ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flag_rounded,
                  color: AppColors.gold, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Set BMI Goal',
                style: GoogleFonts.poppins(
                    color: AppColors.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Healthy range is 18.5 – 24.9',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              style: GoogleFonts.poppins(
                  color: AppColors.textLight, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'e.g. 22.5',
                hintStyle:
                GoogleFonts.poppins(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.track_changes_rounded,
                    color: AppColors.primary),
                filled: true,
                fillColor: AppColors.darkBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                  const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style:
                GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              final goal = double.tryParse(ctrl.text.trim());
              if (goal != null && goal > 10 && goal < 60) {
                final ok = await BMIService.setGoal(goal);
                if (ok) {
                  if (mounted) setState(() => _goalBMI = goal);
                  if (mounted) Navigator.pop(ctx);
                  _showSnack(
                      '✓ BMI Goal set to ${goal.toStringAsFixed(1)}',
                      AppColors.secondary);
                } else {
                  if (mounted) Navigator.pop(ctx);
                  _showSnack('Failed to save goal', AppColors.accent);
                }
              } else {
                _showSnack('Enter a valid BMI (10–60)', AppColors.overweight);
              }
            },
            child: Text('Set Goal',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        if (_goalBMI != null) ...[
                          const SizedBox(height: 14),
                          _buildGoalBanner(),
                        ],
                        const SizedBox(height: 20),
                        _buildNameField(),
                        const SizedBox(height: 14),
                        _buildGenderSelector(),
                        const SizedBox(height: 14),
                        _buildHeightCard(),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: _buildWeightCard()),
                            const SizedBox(width: 14),
                            Expanded(child: _buildAgeCard()),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildNoteField(),
                        const SizedBox(height: 20),
                        GradientButton(
                          text: 'Calculate BMI',
                          onTap: _calculate,
                          icon: Icons.monitor_heart_rounded,
                        ).animate().fadeIn(delay: 300.ms),
                        if (_bmi != null) ...[
                          const SizedBox(height: 20),
                          _buildResultCard(),
                          const SizedBox(height: 14),
                          _buildActionRow(),
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirection: pi / 2,
                maxBlastForce: 6,
                minBlastForce: 2,
                emissionFrequency: 0.06,
                numberOfParticles: 60,
                gravity: 0.15,
                colors: const [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.gold,
                  AppColors.accent
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BMI Calculator',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textLight,
              ),
            ),
            Text(
              'Track your health journey',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showGoalDialog,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.gold.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Icon(Icons.flag_rounded,
                    color: AppColors.gold, size: 22),
                if (_goalBMI != null)
                  Text(
                    _goalBMI!.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildGoalBanner() {
    final diff = _bmi != null ? _goalBMI! - _bmi! : null;
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withOpacity(0.12),
            AppColors.primary.withOpacity(0.06)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.track_changes_rounded,
              color: AppColors.gold, size: 18),
          const SizedBox(width: 10),
          Text(
            'Goal BMI: ${_goalBMI!.toStringAsFixed(1)}',
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.gold),
          ),
          const Spacer(),
          Text(
            diff != null
                ? '${diff.abs().toStringAsFixed(1)} pts ${diff > 0 ? 'below' : 'above'} goal'
                : 'Calculate to see progress',
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameCtrl,
      style:
      GoogleFonts.poppins(color: AppColors.textLight, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Patient / Person Name',
        hintStyle: GoogleFonts.poppins(
            color: AppColors.textMuted, fontSize: 14),
        prefixIcon: const Icon(Icons.person_outline_rounded,
            color: AppColors.primary, size: 22),
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _noteCtrl,
      maxLines: 2,
      style:
      GoogleFonts.poppins(color: AppColors.textLight, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Add a note (optional)',
        hintStyle: GoogleFonts.poppins(
            color: AppColors.textMuted, fontSize: 13),
        prefixIcon: const Icon(Icons.notes_rounded,
            color: AppColors.primary, size: 22),
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(child: _genderCard('Male', Icons.male_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _genderCard('Female', Icons.female_rounded)),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _genderCard(String gender, IconData icon) {
    final sel = _gender == gender;
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: sel
              ? const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary])
              : null,
          color: sel ? null : AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sel ? Colors.transparent : AppColors.cardBorder,
            width: 1,
          ),
          boxShadow: sel
              ? [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 44,
                color: sel ? Colors.white : AppColors.textMuted),
            const SizedBox(height: 6),
            Text(
              gender,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: sel ? Colors.white : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Height',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _unitToggle('cm', !_useFeet,
                            () => setState(() => _useFeet = false)),
                    _unitToggle('ft', _useFeet,
                            () => setState(() => _useFeet = true)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _useFeet
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_feet',
                style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textLight),
              ),
              Text("' ",
                  style: GoogleFonts.poppins(
                      fontSize: 22, color: AppColors.primary)),
              Text(
                '$_inches',
                style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textLight),
              ),
              Text('"',
                  style: GoogleFonts.poppins(
                      fontSize: 22, color: AppColors.primary)),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _heightCm.toInt().toString(),
                style: GoogleFonts.poppins(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textLight),
              ),
              Text(' cm',
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: AppColors.primary)),
            ],
          ),
          if (!_useFeet) ...[
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.cardLight,
                thumbColor: Colors.white,
                overlayColor: AppColors.primary.withOpacity(0.15),
                thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape:
                const RoundSliderOverlayShape(overlayRadius: 22),
                trackHeight: 5,
              ),
              child: Slider(
                value: _heightCm,
                min: 100,
                max: 250,
                onChanged: _updateHeightFromSlider,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('100 cm',
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.textMuted)),
                Text('250 cm',
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ] else ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Feet',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _counterBtn(Icons.remove_rounded, () {
                            if (_feet > 3) {
                              _feet--;
                              _updateHeightFromFeetInches();
                            }
                          }),
                          const SizedBox(width: 16),
                          Text('$_feet',
                              style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textLight)),
                          const SizedBox(width: 16),
                          _counterBtn(Icons.add_rounded, () {
                            if (_feet < 8) {
                              _feet++;
                              _updateHeightFromFeetInches();
                            }
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 1,
                    height: 50,
                    color: AppColors.cardBorder),
                Expanded(
                  child: Column(
                    children: [
                      Text('Inches',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _counterBtn(Icons.remove_rounded, () {
                            if (_inches > 0) {
                              _inches--;
                              _updateHeightFromFeetInches();
                            }
                          }),
                          const SizedBox(width: 16),
                          Text('$_inches',
                              style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textLight)),
                          const SizedBox(width: 16),
                          _counterBtn(Icons.add_rounded, () {
                            if (_inches < 11) {
                              _inches++;
                              _updateHeightFromFeetInches();
                            }
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '≈ ${_heightCm.toInt()} cm',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1);
  }

  Widget _buildWeightCard() {
    final displayValue = _useLbs ? _weightLbs : _weightKg;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weight',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textMuted)),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    _unitToggle('kg', !_useLbs,
                            () => setState(() => _useLbs = false)),
                    _unitToggle('lbs', _useLbs,
                            () => setState(() => _useLbs = true)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            displayValue.toStringAsFixed(1),
            style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.textLight),
          ),
          Text(
            _useLbs ? 'lbs' : 'kg',
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _counterBtn(Icons.remove_rounded, () {
                if (_useLbs) {
                  if (_weightLbs > 44) _updateWeightLbs(_weightLbs - 0.5);
                } else {
                  if (_weightKg > 20) _updateWeightKg(_weightKg - 0.5);
                }
              }),
              const SizedBox(width: 16),
              _counterBtn(Icons.add_rounded, () {
                if (_useLbs) {
                  _updateWeightLbs(_weightLbs + 0.5);
                } else {
                  _updateWeightKg(_weightKg + 0.5);
                }
              }),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildAgeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Age',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textMuted)),
              Text('yrs',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$_age',
            style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.textLight),
          ),
          Text('years',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.primary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _counterBtn(Icons.remove_rounded, () {
                if (_age > 1) setState(() => _age--);
              }),
              const SizedBox(width: 16),
              _counterBtn(
                  Icons.add_rounded, () => setState(() => _age++)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.1);
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
    );
  }

  Widget _unitToggle(
      String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary])
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _bmiColor.withOpacity(0.12),
            AppColors.cardDark
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
            color: _bmiColor.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        children: [
          Text('Your Result',
              style: GoogleFonts.poppins(
                  fontSize: 16, color: AppColors.textMuted)),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _bmiColor.withOpacity(0.3), width: 12),
                  boxShadow: [
                    BoxShadow(
                        color: _bmiColor.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    _bmi!.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: _bmiColor),
                  ),
                  Text('BMI',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: _bmiColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border:
              Border.all(color: _bmiColor.withOpacity(0.3)),
            ),
            child: Text(
              _category,
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _bmiColor),
            ),
          ),
          const SizedBox(height: 20),
          _buildBMIScale(),
          if (_goalBMI != null) ...[
            const SizedBox(height: 16),
            _buildGoalProgress(),
          ],
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildGoalProgress() {
    final diff = _goalBMI! - _bmi!;
    final isClose = diff.abs() < 2;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isClose
            ? AppColors.secondary.withOpacity(0.1)
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isClose
                ? AppColors.secondary.withOpacity(0.3)
                : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(
            isClose
                ? Icons.check_circle_rounded
                : Icons.info_outline_rounded,
            color: isClose ? AppColors.secondary : AppColors.textMuted,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isClose
                  ? 'You are very close to your goal!'
                  : 'You are ${diff.abs().toStringAsFixed(1)} BMI points ${diff > 0 ? 'below' : 'above'} your goal',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color:
                isClose ? AppColors.secondary : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIScale() {
    double position = ((_bmi! - 10) / 30).clamp(0.0, 1.0);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.underweight,
                    AppColors.normal,
                    AppColors.overweight,
                    AppColors.obese
                  ],
                ),
              ),
            ),
            Positioned(
              left:
              position * (MediaQuery.of(context).size.width - 88) -
                  4,
              top: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: _bmiColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: _bmiColor.withOpacity(0.5),
                        blurRadius: 8)
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _scaleLabel(
                'Underweight', '<18.5', AppColors.underweight),
            _scaleLabel('Normal', '18.5–24.9', AppColors.normal),
            _scaleLabel('Overweight', '25–29.9', AppColors.overweight),
            _scaleLabel('Obese', '≥30', AppColors.obese),
          ],
        ),
      ],
    );
  }

  Widget _scaleLabel(String label, String range, Color color) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 8,
                color: color,
                fontWeight: FontWeight.w600)),
        Text(range,
            style: GoogleFonts.poppins(
                fontSize: 7, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _save,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [
                      AppColors.secondary,
                      Color(0xFF00A882)
                    ]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.secondary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Save Record',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _reset,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.refresh_rounded,
                color: AppColors.primary, size: 22),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }
}

// ==================== HISTORY PAGE ====================
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BMIRecord> _records = [];
  List<String> _favorites = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  // FIX: Public reload method so parent can call it
  Future<void> reload() async {
    await _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final r = await BMIService.getRecords();
    final f = await BMIService.getFavorites();
    if (!mounted) return;
    setState(() {
      _records = r.reversed.toList();
      _favorites = f;
      _loading = false;
    });
    debugPrint('HistoryPage loaded ${_records.length} records');
  }

  List<BMIRecord> get _filtered {
    if (_search.isEmpty) return _records;
    return _records
        .where((r) =>
    r.name.toLowerCase().contains(_search.toLowerCase()) ||
        r.category.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  Future<void> _delete(String id) async {
    await BMIService.deleteRecord(id);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Record deleted',
              style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _toggleFav(String id) async {
    await BMIService.toggleFavorite(id);
    await _load();
  }

  Future<void> _share(BMIRecord r) async {
    final text = '''
📊 BMI Record – ${r.name}
BMI: ${r.bmi.toStringAsFixed(1)} – ${r.category}
${r.gender}, ${r.age} yrs, ${r.weightKg.toStringAsFixed(1)} kg, ${r.heightCm.toInt()} cm
Date: ${r.date}
${r.note != null ? 'Note: ${r.note}' : ''}

Made by Farhat – BMI Calculator Pro
''';
    await Share.share(text.trim());
  }

  Future<void> _clearAll() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Clear All?',
            style: GoogleFonts.poppins(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600)),
        content: Text(
            'This will permanently delete all records.',
            style: GoogleFonts.poppins(
                color: AppColors.textMuted, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              await BMIService.clearAll();
              if (mounted) {
                Navigator.pop(ctx);
                await _load();
              }
            },
            child: Text('Delete All',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text('History',
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.primary),
            onPressed: _load,
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded,
                color: AppColors.primary),
            onPressed: () async {
              final text = await BMIService.exportAsText();
              Share.share(text, subject: 'BMI Report by Farhat');
            },
          ),
          if (_records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded,
                  color: AppColors.accent),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _loading
          ? const Center(
          child: CircularProgressIndicator(
              color: AppColors.primary))
          : Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (v) =>
                  setState(() => _search = v),
              style: GoogleFonts.poppins(
                  color: AppColors.textLight, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by name or category...',
                hintStyle: GoogleFonts.poppins(
                    color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.primary, size: 22),
                filled: true,
                fillColor: AppColors.cardDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_rounded,
                      size: 64,
                      color: AppColors.textMuted
                          .withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    _search.isEmpty
                        ? 'No records yet'
                        : 'No matches found',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.textMuted),
                  ),
                  if (_search.isEmpty)
                    Text(
                      'Calculate & save your first BMI!',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textMuted
                              .withOpacity(0.6)),
                    ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    16, 0, 16, 20),
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final r = _filtered[i];
                  // FIX: Use the bmiColor getter from model
                  final color = r.bmiColor;
                  final isFav =
                  _favorites.contains(r.id);
                  return Container(
                    margin: const EdgeInsets.only(
                        bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius:
                      BorderRadius.circular(20),
                      border: Border.all(
                          color: color.withOpacity(0.25),
                          width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color
                                      .withOpacity(0.15),
                                  border: Border.all(
                                      color: color
                                          .withOpacity(
                                          0.3),
                                      width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    r.bmi
                                        .toStringAsFixed(
                                        1),
                                    style: GoogleFonts
                                        .poppins(
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight
                                            .w700,
                                        color: color),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      r.name,
                                      style: GoogleFonts
                                          .poppins(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          color: AppColors
                                              .textLight),
                                    ),
                                    const SizedBox(
                                        height: 2),
                                    Text(
                                      '${r.gender} • ${r.age} yrs • ${r.weightKg.toStringAsFixed(1)} kg • ${r.heightCm.toInt()} cm',
                                      style: GoogleFonts
                                          .poppins(
                                          fontSize: 11,
                                          color: AppColors
                                              .textMuted),
                                    ),
                                    const SizedBox(
                                        height: 6),
                                    Container(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 10,
                                          vertical: 3),
                                      decoration:
                                      BoxDecoration(
                                        color: color
                                            .withOpacity(
                                            0.15),
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            20),
                                      ),
                                      child: Text(
                                        r.category,
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight:
                                            FontWeight
                                                .w600,
                                            color: color),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _toggleFav(r.id),
                                    child: Icon(
                                      isFav
                                          ? Icons
                                          .favorite_rounded
                                          : Icons
                                          .favorite_border_rounded,
                                      color: isFav
                                          ? AppColors
                                          .accent
                                          : AppColors
                                          .textMuted,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 10),
                                  GestureDetector(
                                    onTap: () =>
                                        _share(r),
                                    child: const Icon(
                                        Icons
                                            .share_rounded,
                                        color: AppColors
                                            .primary,
                                        size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (r.note != null &&
                              r.note!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding:
                              const EdgeInsets.all(
                                  10),
                              decoration: BoxDecoration(
                                color:
                                AppColors.darkBackground,
                                borderRadius:
                                BorderRadius.circular(
                                    10),
                              ),
                              child: Text(
                                r.note!,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color:
                                    AppColors.textMuted,
                                    fontStyle:
                                    FontStyle.italic),
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                r.date,
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color:
                                    AppColors.textMuted),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _delete(r.id),
                                child: Container(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                      horizontal: 12,
                                      vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent
                                        .withOpacity(0.12),
                                    borderRadius:
                                    BorderRadius
                                        .circular(8),
                                    border: Border.all(
                                        color: AppColors
                                            .accent
                                            .withOpacity(
                                            0.3)),
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color:
                                        AppColors.accent,
                                        fontWeight:
                                        FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate()
                      .fadeIn(delay: (i * 60).ms)
                      .slideY(begin: 0.1);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}

// ==================== ANALYTICS PAGE ====================
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<BMIRecord> _records = [];
  bool _loading = true;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  // FIX: Public reload method so parent can call it
  Future<void> reload() async {
    await _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final r = await BMIService.getRecords();
    if (!mounted) return;
    setState(() {
      _records = r;
      _stats = BMIService.getStatistics(r);
      _loading = false;
    });
    debugPrint('AnalyticsPage loaded ${_records.length} records');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text('Analytics',
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.primary),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(
          child: CircularProgressIndicator(
              color: AppColors.primary))
          : _records.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded,
                size: 70,
                color:
                AppColors.textMuted.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('No data yet',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Text('Save a BMI record to see analytics',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textMuted
                        .withOpacity(0.6))),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _load,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStatsGrid(),
              const SizedBox(height: 20),
              if (_records.length > 1) ...[
                _buildBMIChart(),
                const SizedBox(height: 20),
                _buildTrendCard(),
                const SizedBox(height: 20),
              ],
              _buildCategoryDistribution(),
              const SizedBox(height: 20),
              _buildRecentEntries(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _statCard('Total Records', '${_stats['total']}',
            Icons.folder_rounded, AppColors.primary),
        _statCard(
            'Average BMI',
            ((_stats['average'] as num?) ?? 0)
                .toDouble()
                .toStringAsFixed(1),
            Icons.bar_chart_rounded,
            AppColors.secondary),
        _statCard(
            'Lowest BMI',
            ((_stats['min'] as num?) ?? 0)
                .toDouble()
                .toStringAsFixed(1),
            Icons.arrow_downward_rounded,
            AppColors.underweight),
        _statCard(
            'Highest BMI',
            ((_stats['max'] as num?) ?? 0)
                .toDouble()
                .toStringAsFixed(1),
            Icons.arrow_upward_rounded,
            AppColors.obese),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _statCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textLight,
                      height: 1)),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBMIChart() {
    final spots = _records.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(),
          double.parse(e.value.bmi.toStringAsFixed(1)));
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.show_chart_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Text('BMI Trend',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight)),
              const Spacer(),
              Text('${_records.length} records',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (v) => FlLine(
                      color: AppColors.cardLight, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 32,
                      getTitlesWidget: (v, m) => Text(
                        v.toInt().toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (v, m) {
                        final idx = v.toInt();
                        if (idx >= 0 &&
                            idx < _records.length) {
                          return Padding(
                            padding:
                            const EdgeInsets.only(top: 4),
                            child: Text(
                              '#${idx + 1}',
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: AppColors.textMuted),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles:
                      SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles:
                      SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: 10,
                maxY: 45,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(colors: [
                      AppColors.primary,
                      AppColors.secondary
                    ]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, pct, bar, idx) =>
                          FlDotCirclePainter(
                            radius: 5,
                            color: AppColors.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.25),
                          AppColors.primary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: List.generate(_records.length,
                            (i) => FlSpot(i.toDouble(), 18.5)),
                    isCurved: false,
                    color: AppColors.normal.withOpacity(0.4),
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                    dashArray: [4, 4],
                  ),
                  LineChartBarData(
                    spots: List.generate(_records.length,
                            (i) => FlSpot(i.toDouble(), 24.9)),
                    isCurved: false,
                    color: AppColors.normal.withOpacity(0.4),
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                    dashArray: [4, 4],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chartLegend(AppColors.primary, 'BMI'),
              const SizedBox(width: 16),
              _chartLegend(AppColors.normal,
                  'Normal Range (18.5 – 24.9)'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _chartLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildCategoryDistribution() {
    final cats =
        _stats['categories'] as Map<String, int>? ?? {};
    final total = (_stats['total'] as int?) ?? 1;
    final Map<String, Color> colorMap = {
      'Underweight': AppColors.underweight,
      'Normal Weight': AppColors.normal,
      'Overweight': AppColors.overweight,
      'Obese': AppColors.obese,
    };

    if (cats.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.pie_chart_rounded,
                    color: AppColors.purple, size: 18),
              ),
              const SizedBox(width: 12),
              Text('Category Distribution',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight)),
            ],
          ),
          const SizedBox(height: 16),
          ...cats.entries.map((e) {
            final color =
                colorMap[e.key] ?? AppColors.primary;
            final pct =
            (e.value / total * 100).toStringAsFixed(0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text(e.key,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.textLight)),
                        ],
                      ),
                      Text(
                        '$pct% (${e.value})',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: e.value / total,
                      backgroundColor: AppColors.darkBackground,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildTrendCard() {
    if (_records.length < 2) return const SizedBox.shrink();
    final bmis = _records.map((r) => r.bmi).toList();
    final trend = bmis.last - bmis[bmis.length - 2];
    final improving = trend < 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (improving ? AppColors.secondary : AppColors.obese)
                .withOpacity(0.1),
            AppColors.cardDark,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (improving
              ? AppColors.secondary
              : AppColors.obese)
              .withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (improving
                  ? AppColors.secondary
                  : AppColors.obese)
                  .withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              improving
                  ? Icons.trending_down_rounded
                  : Icons.trending_up_rounded,
              color: improving
                  ? AppColors.secondary
                  : AppColors.obese,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latest Trend',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textMuted)),
                Row(
                  children: [
                    Text(
                      '${improving ? "▼" : "▲"} ${trend.abs().toStringAsFixed(1)}',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: improving
                            ? AppColors.secondary
                            : AppColors.obese,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('BMI',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textMuted)),
                  ],
                ),
                Text(
                  improving
                      ? '🎉 BMI decreasing – Keep going!'
                      : '⚠️ BMI increasing – Watch your diet!',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms);
  }

  Widget _buildRecentEntries() {
    final recent = _records.reversed.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.access_time_rounded,
                    color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 12),
              Text('Recent Entries',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight)),
            ],
          ),
          const SizedBox(height: 14),
          ...recent.map((r) {
            // FIX: Use bmiColor getter
            final color = r.bmiColor;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(14),
                border:
                Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.15)),
                    child: Center(
                      child: Text(
                        r.bmi.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(r.name,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLight)),
                        Text(r.date,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(r.category,
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

// ==================== PROFILE PAGE ====================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = '';
  int _totalRecords = 0;
  double? _goalBMI;
  int _favCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // FIX: Public reload method so parent can call it
  Future<void> reload() async {
    await _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final records = await BMIService.getRecords();
    final favs = await BMIService.getFavorites();
    final goal = await BMIService.getGoal();
    if (!mounted) return;
    setState(() {
      _email = prefs.getString('userEmail') ?? 'User';
      _totalRecords = records.length;
      _favCount = favs.length;
      _goalBMI = goal;
    });
    debugPrint('ProfilePage loaded. Records: $_totalRecords');
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
            (r) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary
                      ]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5)
                  ],
                ),
                child: const Icon(Icons.person_rounded,
                    size: 52, color: Colors.white),
              ).animate().fadeIn().scale(
                  begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 16),
              Text(_email,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight))
                  .animate()
                  .fadeIn(delay: 100.ms),
              const SizedBox(height: 4),
              Text('BMI Calculator Pro User',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textMuted))
                  .animate()
                  .fadeIn(delay: 150.ms),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _quickStat('$_totalRecords', 'Records',
                        AppColors.primary, Icons.folder_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickStat('$_favCount', 'Favorites',
                        AppColors.accent, Icons.favorite_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickStat(
                        _goalBMI?.toStringAsFixed(1) ?? '—',
                        'BMI Goal',
                        AppColors.gold,
                        Icons.flag_rounded),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 20),
              _profileCard('App Version', '2.0.0 Pro',
                  Icons.info_outline_rounded, AppColors.purple),
              const SizedBox(height: 12),
              _profileCard(
                  'BMI Goal',
                  _goalBMI?.toStringAsFixed(1) ?? 'Not set',
                  Icons.flag_rounded,
                  AppColors.gold),
              const SizedBox(height: 12),
              _profileCard('Total Records', '$_totalRecords saved',
                  Icons.folder_rounded, AppColors.primary),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.accent.withOpacity(0.15),
                    foregroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                          color: AppColors.accent, width: 1),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: Text('Logout',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }

  Widget _quickStat(
      String value, String label, Color color, IconData icon) {
    return Container(
      padding:
      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textLight)),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _profileCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textMuted)),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}