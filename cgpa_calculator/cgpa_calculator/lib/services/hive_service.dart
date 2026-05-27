import 'package:hive_flutter/hive_flutter.dart';
import '../models/course.dart';
import '../models/semester.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box<Course> courseBox;
  late Box<Semester> semesterBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CourseAdapter());
    Hive.registerAdapter(SemesterAdapter());

    courseBox = await Hive.openBox<Course>('courses');
    semesterBox = await Hive.openBox<Semester>('semesters');
  }

  Future<void> addCourse(Course course) async {
    await courseBox.put(course.id, course);
  }

  Future<void> deleteCourse(String id) async {
    await courseBox.delete(id);
  }

  List<Course> getCoursesBySemester(String semesterId) {
    return courseBox.values
        .where((course) => course.semesterId == semesterId)
        .toList();
  }

  Future<void> addSemester(Semester semester) async {
    await semesterBox.put(semester.id, semester);
  }

  Future<void> deleteSemester(String id) async {
    final courses = getCoursesBySemester(id);
    for (var course in courses) {
      await courseBox.delete(course.id);
    }
    await semesterBox.delete(id);
  }

  List<Semester> getAllSemesters() {
    return semesterBox.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}