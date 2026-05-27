import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../models/semester.dart';
import '../services/hive_service.dart';
import '../services/calculator_service.dart';

class CGPAProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<Semester> _semesters = [];
  List<Course> _allCourses = [];

  List<Semester> get semesters => _semesters;
  List<Course> get allCourses => _allCourses;

  Future<void> loadData() async {
    _semesters = _hiveService.getAllSemesters();
    _allCourses = _hiveService.courseBox.values.toList();
    notifyListeners();
  }

  Future<void> addSemester(String name, int year) async {
    final semester = Semester(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      year: year,
      order: _semesters.length + 1,
      courseIds: [],
    );

    await _hiveService.addSemester(semester);
    await loadData();
  }

  Future<void> addCourse(String semesterId, String name, double creditHours,
      double gradePoints, String gradeLetter) async {
    final course = Course(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      creditHours: creditHours,
      gradePoints: gradePoints,
      gradeLetter: gradeLetter,
      semesterId: semesterId,
    );

    await _hiveService.addCourse(course);

    final semester = _hiveService.semesterBox.get(semesterId);
    if (semester != null) {
      semester.courseIds.add(course.id);
      await semester.save();
    }

    await loadData();
  }

  double getSemesterGPA(String semesterId) {
    final courses = _hiveService.getCoursesBySemester(semesterId);
    return CalculatorService.calculateGPA(courses);
  }

  double get getCGPA => CalculatorService.calculateCGPA(_semesters, _allCourses);

  Future<void> deleteCourse(String id) async {
    await _hiveService.deleteCourse(id);
    await loadData();
  }

  Future<void> deleteSemester(String id) async {
    await _hiveService.deleteSemester(id);
    await loadData();
  }
}