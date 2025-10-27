import 'package:flutter/material.dart';
import 'package:markme/models/student_model.dart';

class StudentInfoPage extends StatelessWidget {
  final Student student;

  const StudentInfoPage({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        backgroundColor: const Color(0xFF2C3E50), // Matching the new theme
      ),
      body: Center(child: Text('Detailed Profile for ${student.usn}')),
    );
  }
}