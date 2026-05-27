import 'package:hive/hive.dart';

part 'course.g.dart';

@HiveType(typeId: 0)
class Course extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double creditHours;

  @HiveField(3)
  double gradePoints;

  @HiveField(4)
  String gradeLetter;

  @HiveField(5)
  String semesterId;

  Course({
    required this.id,
    required this.name,
    required this.creditHours,
    required this.gradePoints,
    required this.gradeLetter,
    required this.semesterId,
  });

  double get qualityPoints {
    return creditHours * gradePoints;
  }
}