import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cgpa_provider.dart';
import '../theme/app_theme.dart';

class AddSemesterScreen extends StatefulWidget {
  const AddSemesterScreen({super.key});

  @override
  State<AddSemesterScreen> createState() => _AddSemesterScreenState();
}

class _AddSemesterScreenState extends State<AddSemesterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Add Semester'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Semester Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your semester information',
                  style: TextStyle(
                    color: Colors.white.withAlpha(153),
                  ),
                ),
                const SizedBox(height: 32),

                // Semester Name
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Semester Name',
                    hintText: 'e.g., Fall 2024',
                    prefixIcon: const Icon(Icons.school, color: AppTheme.accentColor),
                    labelStyle: TextStyle(color: Colors.white.withAlpha(178)),
                    hintStyle: TextStyle(color: Colors.white.withAlpha(102)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter semester name' : null,
                ),
                const SizedBox(height: 20),

                // Year
                TextFormField(
                  controller: _yearController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Year',
                    hintText: 'e.g., 2024',
                    prefixIcon: const Icon(Icons.calendar_today, color: AppTheme.accentColor),
                    labelStyle: TextStyle(color: Colors.white.withAlpha(178)),
                    hintStyle: TextStyle(color: Colors.white.withAlpha(102)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter year' : null,
                ),
                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withAlpha(102),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<CGPAProvider>().addSemester(
                            _nameController.text,
                            int.parse(_yearController.text),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Create Semester',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}