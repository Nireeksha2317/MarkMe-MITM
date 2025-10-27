// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:markme/models/student_model.dart';
import 'config.dart'; // Your configuration file

class ApiService {
  final String _baseUrl = apiBaseUrl;

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('$_baseUrl/students'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final documents = data['data'] as List;
      const timeSlots = ['9:00 – 11:00', '11:15 – 1:15', '2:00 – 4:00'];

      return documents.map((doc) => Student.fromJson(doc, timeSlots)).toList();
    } else {
      throw Exception('Failed to load students: ${response.body}');
    }
  }

  Future<void> saveAttendance({
    required String usn,
    required DateTime date,
    required String timeSlot,
    required bool isPresent,
  }) async {
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final response = await http.post(
      Uri.parse('$_baseUrl/attendance/mark'),
      headers: _headers,
      body: json.encode({
        'usn': usn,
        'date': dateString,
        'slot': timeSlot,
        'present': isPresent,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save attendance: ${response.body}');
    }
  }

  Future<List<String>> fetchAbsentees(String date, String timeSlot) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/attendance/absentees?date=$date&slot=$timeSlot'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final documents = data['absentees'] as List;
      return documents.map((doc) => doc.toString()).toList();
    } else {
      throw Exception('Failed to fetch absentees: ${response.body}');
    }
  }
  
  Future<Student> fetchStudentDetails(String usn) async {
    final response = await http.get(Uri.parse('$_baseUrl/students/$usn'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      const timeSlots = ['9:00 – 11:00', '11:15 – 1:15', '2:00 – 4:00'];
      return Student.fromJson(data['student'], timeSlots);
    } else {
      throw Exception('Failed to load student details: ${response.body}');
    }
  }
}