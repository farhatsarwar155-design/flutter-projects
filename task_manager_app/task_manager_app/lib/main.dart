import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

// ─── Global notification plugin ───────────────────────────────────────────────
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Karachi')); // Pakistan timezone
  await _initNotifications();
  runApp(const MyApp());
}

Future<void> _initNotifications() async {
  const AndroidInitializationSettings android =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: android),
    onDidReceiveNotificationResponse: (r) =>
        debugPrint('Notification tapped: ${r.payload}'),
  );

  // Create high-importance channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'task_channel',
    'Task Notifications',
    description: 'Task reminder notifications',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// ─── App ──────────────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1B),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark),
      ),
      home: const LoginScreen(),
    );
  }
}

// ─── LOGIN SCREEN ─────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _ctrl;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, .6, curve: Curves.easeIn)));
    _scale = Tween<double>(begin: .8, end: 1).animate(CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, .6, curve: Curves.easeOutBack)));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // PUBLIC LOGIN - Koi bhi username/password chalega
  void _login() {
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError('Please enter both username and password');
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // PUBLIC ACCESS - No validation, direct login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TaskHomePage()),
      );
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F1B), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF4CAF50)]),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10))
                          ],
                        ),
                        child: const Icon(Icons.lock_outline,
                            size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Login to access Task Manager',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                        controller: _usernameCtrl,
                        hint: 'Username',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordCtrl,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: _isLoading ? null : _login,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: _isLoading
                                ? null
                                : const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF4CAF50)]),
                            color: _isLoading ? Colors.grey.shade700 : null,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _isLoading
                                ? []
                                : [
                              BoxShadow(
                                  color: const Color(0xFF6C63FF)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8))
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252542),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}

// ─── Priority ─────────────────────────────────────────────────────────────────
enum TaskPriority { low, medium, high }

extension TaskPriorityX on TaskPriority {
  String get label => ['Low', 'Medium', 'High'][index];
  Color get color => [Colors.green, Colors.orange, Colors.red][index];
  IconData get icon =>
      [Icons.arrow_downward, Icons.remove, Icons.arrow_upward][index];
}

// ─── Task Model ───────────────────────────────────────────────────────────────
class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  TimeOfDay dueTime;
  bool isCompleted;
  bool hasNotification;
  String repeatType; // 'None', 'Daily', 'Weekly', 'Monthly'
  TaskPriority priority;
  String category;
  List<String> subTasks;
  Map<String, bool> subTaskCompletion;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    this.isCompleted = false,
    this.hasNotification = false,
    this.repeatType = 'None',
    this.priority = TaskPriority.medium,
    this.category = 'General',
    List<String>? subTasks,
    Map<String, bool>? subTaskCompletion,
  })  : subTasks = subTasks ?? [],
        subTaskCompletion = subTaskCompletion ?? {};

  DateTime get taskDateTime => DateTime(
      dueDate.year, dueDate.month, dueDate.day, dueTime.hour, dueTime.minute);

  bool get isOverdue => !isCompleted && taskDateTime.isBefore(DateTime.now());

  double get subTaskProgress {
    if (subTasks.isEmpty) return 0;
    return subTaskCompletion.values.where((v) => v).length / subTasks.length;
  }
}

// ─── AM/PM Time Picker ────────────────────────────────────────────────────────
class AmPmTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  const AmPmTimePicker(
      {super.key, required this.initialTime, required this.onTimeChanged});
  @override
  State<AmPmTimePicker> createState() => _AmPmTimePickerState();
}

class _AmPmTimePickerState extends State<AmPmTimePicker> {
  late int _hour, _minute;
  late bool _isAm;

  @override
  void initState() {
    super.initState();
    final h = widget.initialTime.hour;
    _isAm = h < 12;
    _hour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    _minute = widget.initialTime.minute;
  }

  TimeOfDay get _tod {
    int h24 = _isAm ? (_hour == 12 ? 0 : _hour) : (_hour == 12 ? 12 : _hour + 12);
    return TimeOfDay(hour: h24, minute: _minute);
  }

  void _notify() => widget.onTimeChanged(_tod);

  Widget _spinner(int value, int min, int max, ValueChanged<int> onChange,
      {String Function(int)? fmt}) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        icon: const Icon(Icons.keyboard_arrow_up, color: Color(0xFF6C63FF)),
        onPressed: () {
          onChange(value >= max ? min : value + 1);
        },
      ),
      Container(
        width: 56,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF252542),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF6C63FF), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(fmt != null ? fmt(value) : '$value',
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      IconButton(
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6C63FF)),
        onPressed: () {
          onChange(value <= min ? max : value - 1);
        },
      ),
    ]);
  }

  Widget _ampmBtn(
      String label, bool active, VoidCallback onTap, BorderRadius radius) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 40,
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4CAF50)])
              : null,
          color: active ? null : const Color(0xFF252542),
          borderRadius: radius,
          border: Border.all(color: const Color(0xFF6C63FF), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : Colors.grey,
                fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.4)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _spinner(_hour, 1, 12, (v) {
          setState(() => _hour = v);
          _notify();
        }, fmt: (v) => v.toString().padLeft(2, '0')),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(':',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        _spinner(_minute, 0, 59, (v) {
          setState(() => _minute = v);
          _notify();
        }, fmt: (v) => v.toString().padLeft(2, '0')),
        const SizedBox(width: 16),
        Column(children: [
          _ampmBtn('AM', _isAm, () {
            setState(() => _isAm = true);
            _notify();
          }, const BorderRadius.vertical(top: Radius.circular(12))),
          const SizedBox(height: 2),
          _ampmBtn('PM', !_isAm, () {
            setState(() => _isAm = false);
            _notify();
          }, const BorderRadius.vertical(bottom: Radius.circular(12))),
        ]),
      ]),
    );
  }
}

// ─── Home Page ────────────────────────────────────────────────────────────────
class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});
  @override
  State<TaskHomePage> createState() => TaskHomePageState();
}

class TaskHomePageState extends State<TaskHomePage> {
  final List<Task> tasks = [];
  int selectedIndex = 0;
  String _searchQuery = '';
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _autoDeleteTimer;

  final List<String> _categories = [
    'General',
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Study'
  ];

  // Different colorful backgrounds for each tab
  final List<Color> _tabColors = [
    const Color(0xFF1A237E), // Today - Deep Blue
    const Color(0xFF1B5E20), // Done - Dark Green
    const Color(0xFF4A148C), // Repeat - Deep Purple
    const Color(0xFFB71C1C), // Overdue - Dark Red
  ];

  final List<Color> _tabAccentColors = [
    const Color(0xFF536DFE), // Today accent - Light Blue
    const Color(0xFF66BB6A), // Done accent - Light Green
    const Color(0xFFAB47BC), // Repeat accent - Light Purple
    const Color(0xFFEF5350), // Overdue accent - Light Red
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _startAutoDeleteTimer();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _autoDeleteTimer?.cancel();
    super.dispose();
  }

  void _startAutoDeleteTimer() {
    _autoDeleteTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _autoDeleteExpiredTasks();
    });
  }

  void _autoDeleteExpiredTasks() {
    final now = DateTime.now();
    final expired = tasks.where((t) {
      final expireAt = t.taskDateTime.add(const Duration(minutes: 5));
      return expireAt.isBefore(now) && !t.isCompleted;
    }).toList();

    if (expired.isNotEmpty) {
      setState(() {
        for (final t in expired) {
          flutterLocalNotificationsPlugin.cancel(t.id.hashCode);
          tasks.removeWhere((task) => task.id == t.id);
        }
      });

      if (mounted && expired.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '🗑️ ${expired.length} expired task(s) automatically removed'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  // FIXED: Daily notification scheduling
  Future<void> scheduleNotification(Task task) async {
    if (!task.hasNotification) return;

    // Cancel old notification first
    await flutterLocalNotificationsPlugin.cancel(task.id.hashCode);

    final androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Task reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: task.title,
      enableVibration: true,
      playSound: true,
      fullScreenIntent: true,
      color: task.priority.color,
      styleInformation: BigTextStyleInformation(
        task.description.isEmpty ? 'Time to complete your task!' : task.description,
        summaryText: '${task.priority.label} Priority • ${task.category}',
      ),
    );

    try {
      // Calculate the scheduled time
      DateTime scheduledDate = task.taskDateTime;
      final now = DateTime.now();

      // For daily repeat, if time has passed today, schedule for tomorrow
      if (task.repeatType == 'Daily') {
        // Create a TZDateTime for today at the task time
        final todayAtTaskTime = DateTime(
            now.year, now.month, now.day,
            task.dueTime.hour, task.dueTime.minute
        );

        if (todayAtTaskTime.isBefore(now)) {
          // If today's time passed, schedule for tomorrow
          scheduledDate = todayAtTaskTime.add(const Duration(days: 1));
        } else {
          scheduledDate = todayAtTaskTime;
        }
      } else {
        // For non-repeating tasks
        if (scheduledDate.isBefore(now)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('⚠️ Please select a future time!'),
              backgroundColor: Colors.red,
            ));
          }
          return;
        }
      }

      // Schedule the notification
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id.hashCode,
        '🔔 Task Reminder: ${task.title}',
        task.description.isEmpty ? 'Tap to open Task Manager' : task.description,
        tzScheduledDate,
        NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        // KEY FIX: For daily repeat, use DateTimeComponents.time to repeat daily at same time
        matchDateTimeComponents: task.repeatType == 'Daily'
            ? DateTimeComponents.time
            : (task.repeatType == 'Weekly' ? DateTimeComponents.dayOfWeekAndTime : null),
      );

      if (mounted) {
        final repeatMsg = task.repeatType == 'Daily' ? ' (Daily repeat enabled)' : '';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '✅ Notification set for ${DateFormat('MMM dd, yyyy').format(scheduledDate)} at ${_formatTime(task.dueTime)}$repeatMsg',
          ),
          backgroundColor: const Color(0xFF6C63FF),
          duration: const Duration(seconds: 4),
        ));
      }
    } catch (e) {
      debugPrint('Notification schedule error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _showTaskDialog({Task? existingTask}) {
    final isEdit = existingTask != null;
    final titleCtrl =
    TextEditingController(text: isEdit ? existingTask.title : '');
    final descCtrl =
    TextEditingController(text: isEdit ? existingTask.description : '');
    final subCtrl = TextEditingController();

    DateTime selDate = isEdit ? existingTask.dueDate : DateTime.now();
    TimeOfDay selTime = isEdit ? existingTask.dueTime : TimeOfDay.now();
    bool hasNotif = isEdit ? existingTask.hasNotification : false;
    String repeat = isEdit ? existingTask.repeatType : 'None';
    TaskPriority priority = isEdit ? existingTask.priority : TaskPriority.medium;
    String category = isEdit ? existingTask.category : 'General';
    List<String> subTasks = isEdit ? List.from(existingTask.subTasks) : [];

    showDialog(
      context: context,
      builder: (dlgCtx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(isEdit ? 'Edit Task' : 'Add New Task',
              style: const TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field(titleCtrl, 'Task Title', Icons.title),
                  const SizedBox(height: 10),
                  _field(descCtrl, 'Description', Icons.description, maxLines: 2),
                  const SizedBox(height: 12),
                  const Text('Priority',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: TaskPriority.values.map((p) {
                      final sel = priority == p;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setDlg(() => priority = p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? p.color.withValues(alpha: 0.3)
                                  : const Color(0xFF252542),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: sel ? p.color : Colors.transparent,
                                  width: 2),
                            ),
                            child: Column(children: [
                              Icon(p.icon,
                                  color: sel ? p.color : Colors.grey, size: 18),
                              const SizedBox(height: 4),
                              Text(p.label,
                                  style: TextStyle(
                                      color: sel ? p.color : Colors.grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Category',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _categories.map((cat) {
                        final sel = category == cat;
                        return GestureDetector(
                          onTap: () => setDlg(() => category = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: sel
                                  ? const LinearGradient(colors: [
                                Color(0xFF6C63FF),
                                Color(0xFF4CAF50)
                              ])
                                  : null,
                              color: sel ? null : const Color(0xFF252542),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(cat,
                                style: TextStyle(
                                    color: sel ? Colors.white : Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Due Date',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                        DateFormat('EEE, MMM dd, yyyy').format(selDate),
                        style: const TextStyle(color: Colors.grey)),
                    trailing: const Icon(Icons.calendar_today,
                        color: Color(0xFF6C63FF)),
                    onTap: () async {
                      final p = await showDatePicker(
                        context: dlgCtx,
                        initialDate: selDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF6C63FF)),
                          ),
                          child: child!,
                        ),
                      );
                      if (p != null) setDlg(() => selDate = p);
                    },
                  ),
                  const Text('Reminder Time',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 6),
                  AmPmTimePicker(
                    initialTime: selTime,
                    onTimeChanged: (t) => setDlg(() => selTime = t),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: hasNotif
                          ? const Color(0xFF6C63FF).withValues(alpha: 0.1)
                          : const Color(0xFF252542),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasNotif
                            ? const Color(0xFF6C63FF)
                            : Colors.transparent,
                      ),
                    ),
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      title: Row(children: [
                        Icon(Icons.notifications_active,
                            color: hasNotif
                                ? const Color(0xFF6C63FF)
                                : Colors.grey,
                            size: 18),
                        const SizedBox(width: 8),
                        Text('Enable Notification',
                            style: TextStyle(
                                color: hasNotif ? Colors.white : Colors.grey)),
                      ]),
                      subtitle: Text(
                        hasNotif
                            ? 'Notification at ${_formatTime(selTime)}'
                            : 'No notification',
                        style: TextStyle(
                            fontSize: 11,
                            color: hasNotif
                                ? const Color(0xFF4CAF50)
                                : Colors.grey),
                      ),
                      value: hasNotif,
                      activeColor: const Color(0xFF6C63FF),
                      onChanged: (v) => setDlg(() => hasNotif = v),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: repeat,
                    dropdownColor: const Color(0xFF1A1A2E),
                    style: const TextStyle(color: Colors.white),
                    decoration: _deco('Repeat'),
                    items: ['None', 'Daily', 'Weekly', 'Monthly']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) => setDlg(() => repeat = v!),
                  ),
                  const SizedBox(height: 12),
                  const Text('Sub-tasks',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: subCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _deco('Add sub-task'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (subCtrl.text.trim().isNotEmpty) {
                          setDlg(() {
                            subTasks.add(subCtrl.text.trim());
                            subCtrl.clear();
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF4CAF50)]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ]),
                  ...subTasks.asMap().entries.map((e) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.radio_button_unchecked,
                        color: Color(0xFF6C63FF), size: 16),
                    title: Text(e.value,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.red, size: 16),
                      onPressed: () =>
                          setDlg(() => subTasks.removeAt(e.key)),
                    ),
                  )),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgCtx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dlgCtx).showSnackBar(const SnackBar(
                    content: Text('Please enter a title'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                if (isEdit) {
                  setState(() {
                    existingTask
                      ..title = titleCtrl.text.trim()
                      ..description = descCtrl.text.trim()
                      ..dueDate = selDate
                      ..dueTime = selTime
                      ..hasNotification = hasNotif
                      ..repeatType = repeat
                      ..priority = priority
                      ..category = category
                      ..subTasks = subTasks;
                  });
                  flutterLocalNotificationsPlugin
                      .cancel(existingTask.id.hashCode);
                  if (hasNotif) scheduleNotification(existingTask);
                } else {
                  final t = Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    dueDate: selDate,
                    dueTime: selTime,
                    hasNotification: hasNotif,
                    repeatType: repeat,
                    priority: priority,
                    category: category,
                    subTasks: subTasks,
                  );
                  setState(() => tasks.add(t));
                  if (hasNotif) scheduleNotification(t);
                }
                Navigator.pop(dlgCtx);
              },
              child: Text(isEdit ? 'Save Changes' : 'Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      {int maxLines = 1}) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }

  InputDecoration _deco(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF6C63FF)),
    ),
  );

  void _deleteTask(String id) {
    flutterLocalNotificationsPlugin.cancel(id.hashCode);
    setState(() => tasks.removeWhere((t) => t.id == id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task deleted'), backgroundColor: Colors.red));
  }

  void _toggleComplete(Task task) {
    setState(() => task.isCompleted = !task.isCompleted);
    if (task.isCompleted) {
      flutterLocalNotificationsPlugin.cancel(task.id.hashCode);
    }
  }

  String _countdown(Task task) {
    final diff = task.taskDateTime.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inDays > 0) return 'in ${diff.inDays}d ${diff.inHours % 24}h';
    if (diff.inHours > 0) return 'in ${diff.inHours}h ${diff.inMinutes % 60}m';
    if (diff.inMinutes > 0) return 'in ${diff.inMinutes}m';
    return 'in ${diff.inSeconds}s';
  }

  List<Task> get _filtered {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    List<Task> list = switch (selectedIndex) {
      0 => tasks.where((t) {
        final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
        return d == todayDate && !t.isCompleted;
      }).toList(),
      1 => tasks.where((t) => t.isCompleted).toList(),
      2 => tasks.where((t) => t.repeatType != 'None' && !t.isCompleted).toList(),
      3 => tasks.where((t) => t.isOverdue).toList(),
      _ => tasks,
    };

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((t) =>
      t.title.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q) ||
          t.category.toLowerCase().contains(q))
          .toList();
    }

    list.sort((a, b) {
      final p = b.priority.index.compareTo(a.priority.index);
      return p != 0 ? p : a.taskDateTime.compareTo(b.taskDateTime);
    });
    return list;
  }

  Map<String, int> get _stats {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return {
      'total': tasks.length,
      'completed': tasks.where((t) => t.isCompleted).length,
      'today': tasks.where((t) {
        final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
        return d == todayDate && !t.isCompleted;
      }).length,
      'overdue': tasks.where((t) => t.isOverdue).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats;
    final currentBgColor = _tabColors[selectedIndex];
    final currentAccentColor = _tabAccentColors[selectedIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            currentBgColor,
            currentBgColor.withValues(alpha: 0.8),
            const Color(0xFF0F0F1B),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: _showSearch
              ? TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search tasks...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Task Manager',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text(
                ['Today', 'Done', 'Repeat', 'Overdue'][selectedIndex],
                style: TextStyle(
                    fontSize: 12,
                    color: currentAccentColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(_showSearch ? Icons.close : Icons.search,
                  color: Colors.white),
              onPressed: () => setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              }),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [currentAccentColor, currentAccentColor.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_active, color: Colors.white),
                onPressed: () async {
                  await flutterLocalNotificationsPlugin.show(
                    999,
                    '🔔 Test Notification',
                    'Notifications are working correctly!',
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        'task_channel',
                        'Task Notifications',
                        importance: Importance.max,
                        priority: Priority.high,
                        enableVibration: true,
                      ),
                    ),
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('✅ Test notification sent!'),
                      backgroundColor: currentAccentColor,
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        body: Column(children: [
          if (!_showSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(children: [
                _statChip('Total', stats['total']!, Colors.white),
                _statChip('Today', stats['today']!, _tabAccentColors[0]),
                _statChip('Done', stats['completed']!, _tabAccentColors[1]),
                _statChip('Overdue', stats['overdue']!, _tabAccentColors[3]),
              ]),
            ),
          Expanded(
            child: _filtered.isEmpty
                ? _emptyState(currentAccentColor)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _taskCard(_filtered[i], currentAccentColor),
            ),
          ),
        ]),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [currentAccentColor, currentAccentColor.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: currentAccentColor.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _showTaskDialog(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, size: 30),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: currentBgColor.withValues(alpha: 0.95),
            border: Border(
                top: BorderSide(
                    color: currentAccentColor.withValues(alpha: 0.5))),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: selectedIndex,
            selectedItemColor: currentAccentColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (i) => setState(() => selectedIndex = i),
            items: [
              _navItem(Icons.today, 'Today', 0),
              _navItem(Icons.check_circle, 'Done', 1),
              _navItem(Icons.repeat, 'Repeat', 2),
              _navItem(Icons.warning_amber_rounded, 'Overdue', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(String label, int count, Color color) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(children: [
        Text('$count',
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ]),
    ),
  );

  BottomNavigationBarItem _navItem(IconData icon, String label, int idx) {
    final sel = selectedIndex == idx;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: sel
              ? LinearGradient(
              colors: [_tabAccentColors[idx], _tabAccentColors[idx].withValues(alpha: 0.7)])
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: sel ? Colors.white : Colors.grey),
      ),
      label: label,
    );
  }

  Widget _taskCard(Task task, Color accentColor) => Dismissible(
    key: Key(task.id),
    direction: DismissDirection.endToStart,
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.delete, color: Colors.red, size: 30),
    ),
    onDismissed: (_) => _deleteTask(task.id),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: task.isCompleted
              ? [const Color(0xFF2D2D44), const Color(0xFF2D2D44)]
              : task.isOverdue
              ? [const Color(0xFF2D1A1A), const Color(0xFF3D2020)]
              : [const Color(0xFF1A1A2E), const Color(0xFF252542)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: task.isCompleted
              ? Colors.grey.withValues(alpha: 0.3)
              : task.isOverdue
              ? Colors.red.withValues(alpha: 0.4)
              : accentColor.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
              color: accentColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
          leading: GestureDetector(
            onTap: () => _toggleComplete(task),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: task.isCompleted
                    ? const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF45A049)])
                    : null,
                border: task.isCompleted
                    ? null
                    : Border.all(color: task.priority.color, width: 2.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
          title: Row(children: [
            Expanded(
              child: Text(task.title,
                  style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: task.isCompleted ? Colors.grey : Colors.white)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: task.priority.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(task.priority.icon, size: 10, color: task.priority.color),
                const SizedBox(width: 3),
                Text(task.priority.label,
                    style: TextStyle(
                        fontSize: 10,
                        color: task.priority.color,
                        fontWeight: FontWeight.bold)),
              ]),
            ),
          ]),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(task.description,
                    style: TextStyle(
                        color:
                        task.isCompleted ? Colors.grey : Colors.white70,
                        fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 4, children: [
                _chip(Icons.calendar_today,
                    DateFormat('MMM dd').format(task.dueDate),
                    accentColor),
                _chip(Icons.access_time, _formatTime(task.dueTime),
                    accentColor),
                if (!task.isCompleted)
                  _chip(Icons.timer, _countdown(task),
                      task.isOverdue ? Colors.red : accentColor),
                _chip(Icons.folder_outlined, task.category, Colors.purple),
                if (task.isOverdue && !task.isCompleted)
                  _chip(Icons.warning_amber_rounded, 'Overdue', Colors.red),
                if (task.hasNotification)
                  _chip(Icons.notifications_active, 'Reminder set',
                      accentColor),
                if (task.repeatType != 'None')
                  _chip(Icons.repeat, task.repeatType, accentColor),
              ]),
            ],
          ),
          trailing: PopupMenuButton<String>(
            color: const Color(0xFF1A1A2E),
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onSelected: (v) {
              if (v == 'edit') _showTaskDialog(existingTask: task);
              if (v == 'delete') _deleteTask(task.id);
              if (v == 'complete') _toggleComplete(task);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'complete',
                child: Row(children: [
                  Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: const Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  Text(
                      task.isCompleted
                          ? 'Mark Incomplete'
                          : 'Mark Complete',
                      style: const TextStyle(color: Colors.white)),
                ]),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  Icon(Icons.edit, color: Color(0xFF6C63FF)),
                  SizedBox(width: 8),
                  Text('Edit', style: TextStyle(color: Colors.white)),
                ]),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ]),
              ),
            ],
          ),
        ),
        if (task.subTasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Sub-tasks: ${task.subTaskCompletion.values.where((v) => v).length}/${task.subTasks.length}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
                      Text('${(task.subTaskProgress * 100).toInt()}%',
                          style: TextStyle(
                              color: accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ]),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: task.subTaskProgress,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                ...task.subTasks.map((sub) {
                  final done = task.subTaskCompletion[sub] ?? false;
                  return GestureDetector(
                    onTap: () => setState(
                            () => task.subTaskCompletion[sub] = !done),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(children: [
                        Icon(
                            done
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 14,
                            color: done
                                ? accentColor
                                : Colors.grey),
                        const SizedBox(width: 6),
                        Text(sub,
                            style: TextStyle(
                                color: done ? Colors.grey : Colors.white70,
                                fontSize: 12,
                                decoration: done
                                    ? TextDecoration.lineThrough
                                    : null)),
                      ]),
                    ),
                  );
                }),
              ],
            ),
          )
        else
          const SizedBox(height: 12),
      ]),
    ),
  );

  Widget _chip(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _emptyState(Color accentColor) {
    final msgs = [
      'No tasks for today!',
      'No completed tasks yet!',
      'No repeated tasks!',
      'No overdue tasks! 🎉',
    ];
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: accentColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
            ],
          ),
          child: const Icon(Icons.task_alt, size: 70, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          _searchQuery.isNotEmpty
              ? 'No results for "$_searchQuery"'
              : msgs[selectedIndex],
          style: const TextStyle(
              fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text('Tap + to add a new task',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
      ]),
    );
  }
}