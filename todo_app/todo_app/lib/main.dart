import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      // optional: handle taps if needed
    },
  );

  tz.initializeTimeZones();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(const MyApp());
}

// MyApp
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8E1F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9C27B0),
          foregroundColor: Colors.white,
        ),
        colorSchemeSeed: Colors.pink,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6A1B9A),
        ),
      ),
      home: TodoScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

// Todo model
class Todo {
  String title;
  bool isDone;
  String id;
  DateTime dueDate;
  bool isDaily;
  String priority;

  Todo({
    required this.title,
    this.isDone = false,
    this.priority = "Medium",
    required this.dueDate,
    this.isDaily = false,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'id': id,
      'dueDate': dueDate.toIso8601String(),
      'isDaily': isDaily,
      'priority': priority,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      isDone: map['isDone'],
      id: map['id'],
      dueDate: DateTime.parse(map['dueDate']),
      isDaily: map['isDaily'] ?? false,
      priority: map['priority'] ?? "Medium",
    );
  }
}

// TodoScreen
class TodoScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const TodoScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> tasks = [];
  List<Todo> filteredTasks = [];
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  late SharedPreferences _prefs;
  DateTime selectedDate = DateTime.now();
  bool isDailyReminder = false;
  String selectedPriority = "Medium";
  String sortOption = "None";

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    final data = _prefs.getString('tasks');
    if (data != null) {
      final decoded = List<Map<String, dynamic>>.from(jsonDecode(data));
      tasks = decoded.map((e) => Todo.fromMap(e)).toList();
    }

    // Remove expired non-daily tasks
    tasks.removeWhere(
            (task) => !task.isDaily && task.dueDate.isBefore(DateTime.now()));

    filteredTasks = List.from(tasks);
    _applyFilters();

    // Schedule auto-delete for all loaded tasks
    for (var task in tasks) {
      scheduleAutoDelete(task);
    }

    _saveTasks();
  }

  Future<void> _saveTasks() async {
    final taskMap = tasks.map((e) => e.toMap()).toList();
    await _prefs.setString('tasks', jsonEncode(taskMap));
  }

  void _applyFilters() {
    tasks.removeWhere(
            (task) => !task.isDaily && task.dueDate.isBefore(DateTime.now()));

    filteredTasks = tasks
        .where((t) =>
        t.title.toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();

    if (sortOption == "Priority") {
      filteredTasks.sort((a, b) {
        Map<String, int> priorityMap = {"High": 1, "Medium": 2, "Low": 3};
        return priorityMap[a.priority]!.compareTo(priorityMap[b.priority]!);
      });
    } else if (sortOption == "Due Date") {
      filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }

    setState(() {});
    _saveTasks();
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.redAccent;
      case "Medium":
        return Colors.orangeAccent;
      case "Low":
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  Future<void> scheduleNotification(Todo task) async {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = tz.TZDateTime.from(task.dueDate, tz.local);

    if (task.isDaily) {
      scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        task.dueDate.hour,
        task.dueDate.minute,
      );
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }
    } else if (scheduledTime.isBefore(now)) {
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode,
      "Task Reminder 🔔",
      task.title,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          channelDescription: 'Reminder notifications for tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
      task.isDaily ? DateTimeComponents.time : null,
    );
  }

  // ✅ Auto-delete function
  Future<void> scheduleAutoDelete(Todo task) async {
    if (task.isDaily) return;

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = tz.TZDateTime.from(task.dueDate, tz.local);
    if (scheduledTime.isBefore(now)) return;

    // Schedule low-priority notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode + 100000,
      "Deleting Task",
      "Task '${task.title}' will be removed automatically.",
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'delete_channel',
          'Task Deletion',
          channelDescription: 'Auto-deletes tasks when due',
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: task.id,
    );

    // Timer to delete task exactly at due time while app is open
    Duration diff = scheduledTime.difference(now);
    Future.delayed(diff, () {
      int index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        setState(() {
          tasks.removeAt(index);
          _applyFilters();
        });
      }
    });
  }

  void addTask() {
    if (controller.text.trim().isEmpty) return;

    final newTask = Todo(
      title: controller.text.trim(),
      dueDate: selectedDate,
      isDaily: isDailyReminder,
      priority: selectedPriority,
    );

    setState(() {
      tasks.add(newTask);
      scheduleNotification(newTask);
      scheduleAutoDelete(newTask);
      _applyFilters();
    });

    controller.clear();
    isDailyReminder = false;
    selectedPriority = "Medium";

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task Added Successfully!")),
    );
  }

  void toggleTaskIndex(int index, bool? value) {
    final originalTask = filteredTasks[index];
    int originalIndex = tasks.indexWhere((t) => t.id == originalTask.id);

    setState(() {
      tasks[originalIndex].isDone = value ?? false;
      if (tasks[originalIndex].isDone) {
        flutterLocalNotificationsPlugin
            .cancel(tasks[originalIndex].id.hashCode);
      }
      _applyFilters();
    });
  }

  void deleteTaskIndex(int index) {
    final originalTask = filteredTasks[index];
    int originalIndex = tasks.indexWhere((t) => t.id == originalTask.id);

    setState(() {
      flutterLocalNotificationsPlugin.cancel(tasks[originalIndex].id.hashCode);
      flutterLocalNotificationsPlugin
          .cancel(tasks[originalIndex].id.hashCode + 100000); // auto-delete
      tasks.removeAt(originalIndex);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task Deleted!")),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDate.hour,
        selectedDate.minute,
      );
      setState(() {});
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("🔥 Premium Todo App"),
            Text(
              "Made by Farhat",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          Switch(value: widget.isDarkMode, onChanged: widget.onThemeChanged),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // Input card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              shadowColor: Colors.pinkAccent,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Enter task...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.task_alt),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                            label: const Text("Date"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _selectTime(context),
                            icon: const Icon(Icons.access_time),
                            label: const Text("Time"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Daily Reminder"),
                            Switch(
                              value: isDailyReminder,
                              onChanged: (v) =>
                                  setState(() => isDailyReminder = v),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: selectedPriority,
                          items: ['High', 'Medium', 'Low']
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 6,
                                  backgroundColor: getPriorityColor(e),
                                ),
                                const SizedBox(width: 6),
                                Text(e),
                              ],
                            ),
                          ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedPriority = v ?? "Medium";
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: addTask,
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Search & sort
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search tasks...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (v) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: sortOption,
                  items: ["None", "Priority", "Due Date"]
                      .map((e) => DropdownMenuItem(
                      value: e, child: Text("Sort: $e")))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      sortOption = v ?? "None";
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Task list
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  Color priorityColor = getPriorityColor(task.priority);

                  return Dismissible(
                    key: Key(task.id),
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => deleteTaskIndex(index),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (v) => toggleTaskIndex(index, v),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                            "Due: ${task.dueDate.toLocal()} ${task.isDaily ? '(Daily)' : ''}"),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: priorityColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task.priority,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}