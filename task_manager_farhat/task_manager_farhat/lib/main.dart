import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show pi;
import 'dart:ui';

// ==================== SETTINGS SERVICE ====================
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isDarkMode => _prefs?.getBool('dark_mode') ?? false;
  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool('dark_mode', value);
  }

  bool get notificationsEnabled => _prefs?.getBool('notifications') ?? true;
  Future<void> setNotifications(bool value) async {
    await _prefs?.setBool('notifications', value);
  }

  bool get soundEnabled => _prefs?.getBool('sound') ?? true;
  Future<void> setSound(bool value) async {
    await _prefs?.setBool('sound', value);
  }

  bool get vibrationEnabled => _prefs?.getBool('vibration') ?? true;
  Future<void> setVibration(bool value) async {
    await _prefs?.setBool('vibration', value);
  }
}

// ==================== NOTIFICATION SERVICE ====================
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<bool> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    return await _plugin.initialize(settings) ?? false;
  }

  Future<void> showTestNotification() async {
    const android = AndroidNotificationDetails(
      'channel_id', 'Task Manager',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      playSound: true,
      color: Color(0xFF6C63FF),
    );
    const details = NotificationDetails(android: android);
    await _plugin.show(0, '✅ Test', 'Task Manager by Farhat!', details);
  }

  Future<void> scheduleNotification(String id, String title, String body, DateTime time) async {
    if (time.isBefore(DateTime.now())) return;

    final android = AndroidNotificationDetails(
      'task_$id', title,
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: SettingsService().vibrationEnabled,
      playSound: SettingsService().soundEnabled,
      color: const Color(0xFF6C63FF),
    );
    final details = NotificationDetails(android: android);

    await _plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> cancelNotification(String id) async {
    await _plugin.cancel(id.hashCode);
  }
}

// ==================== MODELS ====================
enum TaskCategory { work, personal, shopping, health, study, other }

enum RepeatType { none, daily, weekly }

class Task {
  final String id;
  String title;
  String description;
  DateTime dueDate;
  TimeOfDay dueTime;
  bool isCompleted;
  TaskCategory category;
  RepeatType repeatType;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    required this.dueTime,
    this.isCompleted = false,
    this.category = TaskCategory.other,
    this.repeatType = RepeatType.none,
  });

  DateTime get dateTime => DateTime(
    dueDate.year, dueDate.month, dueDate.day, dueTime.hour, dueTime.minute,
  );

  bool get isToday {
    final now = DateTime.now();
    return dueDate.year == now.year && dueDate.month == now.month && dueDate.day == now.day;
  }

  bool get isRepeated => repeatType != RepeatType.none;
}

// ==================== GLOBAL STATE ====================
class AppData {
  static final List<Task> tasks = [];
  static bool isDarkMode = false;

  static List<Task> get todayTasks => tasks.where((t) => t.isToday && !t.isCompleted).toList();
  static List<Task> get completedTasks => tasks.where((t) => t.isCompleted).toList();
  static List<Task> get repeatedTasks => tasks.where((t) => t.isRepeated && !t.isCompleted).toList();

  static void addTask(Task task) {
    tasks.add(task);
    NotificationService().scheduleNotification(
      task.id, '⏰ ${task.title}', task.description.isNotEmpty ? task.description : 'Task due!', task.dateTime,
    );
    final reminder = task.dateTime.subtract(const Duration(minutes: 10));
    if (reminder.isAfter(DateTime.now())) {
      NotificationService().scheduleNotification(
        '${task.id}_reminder', '🔔 Upcoming', '${task.title} in 10 min', reminder,
      );
    }
  }

  static void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    NotificationService().cancelNotification(id);
  }

  static void toggleTask(String id) {
    final task = tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) NotificationService().cancelNotification(id);
  }

  static void clearAll() {
    NotificationService().cancelAll();
    tasks.clear();
  }
}

// ==================== COLOR PALETTE ====================
class AppColors {
  static const List<Color> gradient1 = [Color(0xFF667eea), Color(0xFF764ba2)];
  static const List<Color> gradient2 = [Color(0xFFf093fb), Color(0xFFf5576c)];
  static const List<Color> gradient3 = [Color(0xFF4facfe), Color(0xFF00f2fe)];
  static const List<Color> gradient4 = [Color(0xFF43e97b), Color(0xFF38f9d7)];
  static const List<Color> gradient5 = [Color(0xFFfa709a), Color(0xFFfee140)];
  static const List<Color> darkGradient = [Color(0xFF232526), Color(0xFF414345)];

  static const Color primary = Color(0xFF6C63FF);
  static const Color accent = Color(0xFF00BFA6);
  static const Color warning = Color(0xFFFFB800);
  static const Color danger = Color(0xFFFF5252);
}

// ==================== MAIN ====================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService().init();
  await NotificationService().init();
  AppData.isDarkMode = SettingsService().isDarkMode;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void toggleTheme() {
    setState(() {
      AppData.isDarkMode = !AppData.isDarkMode;
      SettingsService().setDarkMode(AppData.isDarkMode);
    });
  }

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master by Farhat',
      debugShowCheckedModeBanner: false,
      themeMode: AppData.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: SplashScreen(onThemeToggle: toggleTheme, onRefresh: refresh),
    );
  }
}

// ==================== ANIMATED BACKGROUND WIDGET ====================
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;

  const AnimatedBackground({super.key, required this.child, required this.colors});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
              stops: [0, _controller.value, 1],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ==================== GLASSMORPHISM CARD ====================
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.2,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppData.isDarkMode;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: opacity * 0.3)
                : Colors.white.withValues(alpha: opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ==================== SPLASH SCREEN (UNIQUE) ====================
class SplashScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onRefresh;

  const SplashScreen({super.key, required this.onThemeToggle, required this.onRefresh});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              onThemeToggle: widget.onThemeToggle,
              onRefresh: widget.onRefresh,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: Listenable.merge([_controller, _pulseController]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value * (1 + _pulseController.value * 0.1),
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.white, Color(0xFFF0F0F0)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Center(
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(_rotateAnimation.value / (2 * pi) * 0.5),
                          child: const Icon(
                            Icons.check_circle_outline,
                            size: 70,
                            color: Color(0xFF667eea),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Title with shimmer effect
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFE0E0E0), Colors.white],
                  stops: [0, 0.5, 1],
                ).createShader(bounds),
                child: const Text(
                  'TASK MASTER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Created by Farhat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Loading indicator
              Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _controller.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== HOME SCREEN (UNIQUE) ====================
class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onRefresh;

  const HomeScreen({super.key, required this.onThemeToggle, required this.onRefresh});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<List<Color>> _pageGradients = [
    AppColors.gradient1,
    AppColors.gradient3,
    [Colors.green.shade400, Colors.teal.shade400],
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = AppData.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? AppColors.darkGradient : [const Color(0xFFF0F4F8), const Color(0xFFE8ECF1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _index,
          children: [
            TodayTasksScreen(onRefresh: widget.onRefresh, gradient: _pageGradients[0]),
            RepeatedTasksScreen(onRefresh: widget.onRefresh, gradient: _pageGradients[1]),
            CompletedTasksScreen(onRefresh: widget.onRefresh, gradient: _pageGradients[2]),
          ],
        ),
        bottomNavigationBar: GlassCard(
          opacity: 0.15,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.today, 'Today', 0, _pageGradients[0]),
                  _navItem(Icons.repeat, 'Repeat', 1, _pageGradients[1]),
                  _navItem(Icons.check_circle, 'Done', 2, _pageGradients[2]),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _fabButton(Icons.settings, Colors.grey[700]!, () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen(
                onThemeToggle: widget.onThemeToggle,
                onRefresh: widget.onRefresh,
              )),
            )),
            const SizedBox(height: 12),
            _fabButton(Icons.notification_important, Colors.red, () async {
              await NotificationService().showTestNotification();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🔔 Test notification sent!')),
                );
              }
            }),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.gradient1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                heroTag: 'add',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTaskScreen(onRefresh: widget.onRefresh)),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('New Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, List<Color> gradient) {
    final isSelected = _index == index;

    return GestureDetector(
      onTap: () => setState(() => _index = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: gradient) : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[500],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[500],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fabButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.small(
        heroTag: icon.toString(),
        onPressed: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

// ==================== TODAY TASKS (UNIQUE) ====================
class TodayTasksScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  final List<Color> gradient;

  const TodayTasksScreen({super.key, required this.onRefresh, required this.gradient});

  @override
  Widget build(BuildContext context) {
    final tasks = AppData.todayTasks;
    final isDark = AppData.isDarkMode;

    return CustomScrollView(
      slivers: [
        // Unique App Bar with Wave
        SliverToBoxAdapter(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Tasks',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${tasks.length} Pending',
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.calendar_today, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Center(
                      child: Text(
                        'Made by Farhat',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Tasks List
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: tasks.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 80,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No tasks for today!',
                        style: TextStyle(
                          fontSize: 20,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create a new task',
                        style: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: UniqueTaskCard(
                  task: tasks[index],
                  onToggle: () {
                    AppData.toggleTask(tasks[index].id);
                    onRefresh();
                  },
                  onDelete: () {
                    AppData.deleteTask(tasks[index].id);
                    onRefresh();
                  },
                  gradient: gradient,
                ),
              ),
              childCount: tasks.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== REPEATED TASKS (UNIQUE) ====================
class RepeatedTasksScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  final List<Color> gradient;

  const RepeatedTasksScreen({super.key, required this.onRefresh, required this.gradient});

  @override
  Widget build(BuildContext context) {
    final tasks = AppData.repeatedTasks;
    final isDark = AppData.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                title: Text('Made by Farhat', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                centerTitle: true,
                background: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Repeated Tasks', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                        Text('Daily & Weekly reminders', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: tasks.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.repeat, size: 80, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No repeated tasks', style: TextStyle(fontSize: 18, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UniqueTaskCard(
                    task: tasks[index],
                    onToggle: () {
                      AppData.toggleTask(tasks[index].id);
                      onRefresh();
                    },
                    onDelete: () {
                      AppData.deleteTask(tasks[index].id);
                      onRefresh();
                    },
                    gradient: gradient,
                  ),
                ),
                childCount: tasks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== COMPLETED TASKS (UNIQUE) ====================
class CompletedTasksScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  final List<Color> gradient;

  const CompletedTasksScreen({super.key, required this.onRefresh, required this.gradient});

  @override
  Widget build(BuildContext context) {
    final tasks = AppData.completedTasks;
    final isDark = AppData.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                title: Text('Made by Farhat', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                centerTitle: true,
                background: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Completed', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                        Text('Great job! Keep it up', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: tasks.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 80, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No completed tasks yet', style: TextStyle(fontSize: 18, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UniqueTaskCard(
                    task: tasks[index],
                    onToggle: () {
                      AppData.toggleTask(tasks[index].id);
                      onRefresh();
                    },
                    onDelete: () {
                      AppData.deleteTask(tasks[index].id);
                      onRefresh();
                    },
                    gradient: gradient,
                  ),
                ),
                childCount: tasks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== UNIQUE TASK CARD ====================
class UniqueTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final List<Color> gradient;

  const UniqueTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppData.isDarkMode;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 4),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.red, Colors.pink]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      onDismissed: (_) => onDelete(),
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Animated Checkbox
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: task.isCompleted
                            ? const LinearGradient(colors: [Colors.green, Colors.teal])
                            : null,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.isCompleted ? Colors.transparent : gradient[0],
                          width: 2,
                        ),
                      ),
                      child: task.isCompleted
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted
                                ? (isDark ? Colors.grey[600] : Colors.grey)
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        if (task.description.isNotEmpty)
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _categoryBadge(),
                ],
              ),
              const SizedBox(height: 12),
              // Time and Repeat Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          task.dueTime.format(context),
                          style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  if (task.isRepeated) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.repeat, size: 14, color: Colors.orange[700]),
                          const SizedBox(width: 4),
                          Text(
                            task.repeatType.name,
                            style: TextStyle(fontSize: 12, color: Colors.orange[700], fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryBadge() {
    final colors = {
      TaskCategory.work: Colors.blue,
      TaskCategory.personal: Colors.green,
      TaskCategory.shopping: Colors.orange,
      TaskCategory.health: Colors.red,
      TaskCategory.study: Colors.purple,
      TaskCategory.other: Colors.grey,
    };
    final icons = {
      TaskCategory.work: Icons.work_outline,
      TaskCategory.personal: Icons.person_outline,
      TaskCategory.shopping: Icons.shopping_bag_outlined,
      TaskCategory.health: Icons.favorite_outline,
      TaskCategory.study: Icons.school_outlined,
      TaskCategory.other: Icons.label_outline,
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors[task.category]!.withValues(alpha: 0.2), colors[task.category]!.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icons[task.category], size: 20, color: colors[task.category]),
    );
  }
}

// ==================== ADD TASK (UNIQUE) ====================
class AddTaskScreen extends StatefulWidget {
  final VoidCallback onRefresh;
  const AddTaskScreen({super.key, required this.onRefresh});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  TaskCategory _category = TaskCategory.other;
  RepeatType _repeat = RepeatType.none;

  final List<List<Color>> _catGradients = const [
    [Colors.blue, Colors.lightBlue],
    [Colors.green, Colors.lightGreen],
    [Colors.orange, Colors.deepOrange],
    [Colors.red, Colors.pink],
    [Colors.purple, Colors.deepPurple],
    [Colors.grey, Colors.blueGrey],
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = AppData.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? AppColors.darkGradient : [const Color(0xFFF0F4F8), const Color(0xFFE8ECF1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: AppColors.gradient1),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Text('Made by Farhat', style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildTextField(_titleController, 'Task Title', Icons.title, isDark),
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildTextField(_descController, 'Description', Icons.description, isDark, maxLines: 3),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(child: _buildDateCard(Icons.calendar_today, 'Date', DateFormat('MMM dd').format(_date), () => _pickDate(context))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDateCard(Icons.access_time, 'Time', _time.format(context), () => _pickTime(context))),
                  ],
                ),
                const SizedBox(height: 24),

                Text('Select Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: TaskCategory.values.length,
                    itemBuilder: (context, index) {
                      final cat = TaskCategory.values[index];
                      final selected = _category == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _category = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            gradient: selected ? LinearGradient(colors: _catGradients[index]) : null,
                            color: selected ? null : (isDark ? Colors.grey[850] : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: selected
                                    ? _catGradients[index][0].withValues(alpha: 0.4)
                                    : Colors.black.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_getCatIcon(cat), color: selected ? Colors.white : _catGradients[index][0], size: 32),
                              const SizedBox(height: 12),
                              Text(
                                cat.name.toUpperCase(),
                                style: TextStyle(
                                  color: selected ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                Text('Repeat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 16),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: RepeatType.values.map((type) {
                        final selected = _repeat == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _repeat = type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: selected ? const LinearGradient(colors: AppColors.gradient1) : null,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                type.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selected ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: AppColors.gradient1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Create Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isDark, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: InputBorder.none,
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildDateCard(IconData icon, String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCatIcon(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.work: return Icons.work;
      case TaskCategory.personal: return Icons.person;
      case TaskCategory.shopping: return Icons.shopping_bag;
      case TaskCategory.health: return Icons.favorite;
      case TaskCategory.study: return Icons.school;
      case TaskCategory.other: return Icons.label;
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _date = date);
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(context: context, initialTime: _time);
    if (time != null) setState(() => _time = time);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    AppData.addTask(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descController.text,
      dueDate: _date,
      dueTime: _time,
      category: _category,
      repeatType: _repeat,
    ));

    widget.onRefresh();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Task created!'), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}

// ==================== SETTINGS (UNIQUE) ====================
class SettingsScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onRefresh;

  const SettingsScreen({super.key, required this.onThemeToggle, required this.onRefresh});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = AppData.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? AppColors.darkGradient : [const Color(0xFFF0F4F8), const Color(0xFFE8ECF1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: AppColors.gradient1),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Text('Made by Farhat', style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Appearance'),
              GlassCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
                      ),
                      title: Text('Dark Mode', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) {
                          widget.onThemeToggle();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _sectionTitle('Notifications'),
              GlassCard(
                child: Column(
                  children: [
                    _switchTile('Enable Notifications', Icons.notifications, AppColors.gradient1,
                        SettingsService().notificationsEnabled, (v) async {
                          await SettingsService().setNotifications(v);
                          if (!v) await NotificationService().cancelAll();
                          setState(() {});
                        }),
                    const Divider(height: 1, indent: 70),
                    _switchTile('Sound', Icons.volume_up, AppColors.gradient3,
                        SettingsService().soundEnabled, (v) async {
                          await SettingsService().setSound(v);
                          setState(() {});
                        }, enabled: SettingsService().notificationsEnabled),
                    const Divider(height: 1, indent: 70),
                    _switchTile('Vibration', Icons.vibration, AppColors.gradient5,
                        SettingsService().vibrationEnabled, (v) async {
                          await SettingsService().setVibration(v);
                          setState(() {});
                        }, enabled: SettingsService().notificationsEnabled),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _sectionTitle('Statistics'),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat('Total', AppData.tasks.length.toString(), AppColors.gradient1),
                      _stat('Pending', AppData.tasks.where((t) => !t.isCompleted).length.toString(), AppColors.gradient3),
                      _stat('Done', AppData.completedTasks.length.toString(), AppColors.gradient4),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _sectionTitle('Data'),
              GlassCard(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.red, Colors.pink]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_forever, color: Colors.white),
                  ),
                  title: Text('Clear All Tasks', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  trailing: ElevatedButton(
                    onPressed: () => _showClearDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: GlassCard(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('© 2026 Task Master by Farhat', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppData.isDarkMode ? Colors.grey[300] : Colors.grey[700]),
      ),
    );
  }

  Widget _switchTile(String title, IconData icon, List<Color> gradient, bool value, Function(bool) onChanged, {bool enabled = true}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title, style: TextStyle(color: AppData.isDarkMode ? Colors.white : Colors.black87)),
      trailing: Switch(value: value, onChanged: enabled ? onChanged : null),
    );
  }

  Widget _stat(String label, String value, List<Color> gradient) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All?'),
        content: const Text('This will delete all tasks permanently.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              AppData.clearAll();
              widget.onRefresh();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}