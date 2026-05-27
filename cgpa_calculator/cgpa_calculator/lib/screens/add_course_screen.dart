import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cgpa_provider.dart';
import '../services/calculator_service.dart';

class AddCourseScreen extends StatefulWidget {
  final String semesterId;

  const AddCourseScreen({super.key, required this.semesterId});

  @override
  AddCourseScreenState createState() => AddCourseScreenState();
}

class AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _creditController = TextEditingController();
  String _selectedGrade = 'A';

  final List<String> grades = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'F'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Course')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter course name' : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _creditController,
                decoration: InputDecoration(
                  labelText: 'Credit Hours',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter credit hours' : null,
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedGrade,
                decoration: InputDecoration(
                  labelText: 'Grade',
                  prefixIcon: Icon(Icons.grade),
                  border: OutlineInputBorder(),
                ),
                items: grades.map((grade) {
                  return DropdownMenuItem(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedGrade = value!),
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final gradePoints = CalculatorService.gradeScale[_selectedGrade]!;

                      context.read<CGPAProvider>().addCourse(
                        widget.semesterId,
                        _nameController.text,
                        double.parse(_creditController.text),
                        gradePoints,
                        _selectedGrade,
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add Course', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}