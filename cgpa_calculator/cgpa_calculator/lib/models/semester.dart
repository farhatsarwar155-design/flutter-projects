import 'package:hive/hive.dart';

part 'semester.g.dart';

@HiveType(typeId: 1)
class Semester extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int year;

  @HiveField(3)
  int order;

  @HiveField(4)
  List<String> courseIds;

  Semester({
    required this.id,
    required this.name,
    required this.year,
    required this.order,
    required this.courseIds,
  });
}