import '../models/course.dart';
import '../models/semester.dart';

class CalculatorService {
  static const Map<String, double> gradeScale = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'F': 0.0,
  };

  static double calculateGPA(List<Course> courses) {
    if (courses.isEmpty) return 0.0;

    double totalQualityPoints = 0;
    double totalCreditHours = 0;

    for (var course in courses) {
      totalQualityPoints += course.qualityPoints;
      totalCreditHours += course.creditHours;
    }

    if (totalCreditHours == 0) return 0.0;
    return totalQualityPoints / totalCreditHours;
  }

  static double calculateCGPA(List<Semester> semesters, List<Course> allCourses) {
    if (semesters.isEmpty) return 0.0;

    double totalQualityPoints = 0;
    double totalCreditHours = 0;

    for (var course in allCourses) {
      totalQualityPoints += course.qualityPoints;
      totalCreditHours += course.creditHours;
    }

    if (totalCreditHours == 0) return 0.0;
    return totalQualityPoints / totalCreditHours;
  }
}