import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:markme/absentees_page.dart';
import 'package:markme/models/student_model.dart';
import 'package:markme/api_service.dart';

class AttendanceListPage extends StatefulWidget {
  const AttendanceListPage({Key? key}) : super(key: key);

  @override
  State<AttendanceListPage> createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  final ApiService _apiService = ApiService(); // Use the new API service
  late Future<List<Student>> _studentsFuture;
  List<Student> _students = [];

  DateTime _selectedDate = DateTime.now();
  String _activeSlot = '9:00 – 11:00'; // Default active slot
  final List<String> _timeSlots = const ['9:00 – 11:00', '11:15 – 1:15', '2:00 – 4:00'];

  @override
  void initState() {
    super.initState();
    _studentsFuture = _initializeStudents();
  }

  Future<List<Student>> _initializeStudents() async {
    try {
      final students = await _apiService.fetchStudents();
      if (mounted) {
        setState(() {
          _students = students;
        });
      }
      return students;
    } catch (e) {
      print("Error initializing students: $e");
      // The FutureBuilder will handle showing the error in the UI
      return Future.error(e);
    }
  }

  // No need for dispose method to close DB connection anymore

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // TODO: Re-fetch attendance data for the new date from the API
        // and update the state of the `_students` list.
      });
    }
  }

  void _toggleAttendance(Student student, String slot) {
    final currentStatus = student.attendance[slot];
    if (currentStatus == AttendanceStatus.present) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Confirm Absence'),
          content: Text('USN ${student.usn} is absent. Confirm?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _updateAttendanceStatus(student, slot, AttendanceStatus.absent);
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      _updateAttendanceStatus(student, slot, AttendanceStatus.present);
    }
  }

  void _updateAttendanceStatus(Student student, String slot, AttendanceStatus status) {
    setState(() {
      student.attendance[slot] = status;
    });
    _apiService.saveAttendance(
      usn: student.usn,
      date: _selectedDate,
      timeSlot: slot,
      status: status,
    ).catchError((error) {
      // If the API call fails, revert the state and show an error
      setState(() {
        student.attendance[slot] = status == AttendanceStatus.present 
            ? AttendanceStatus.absent 
            : AttendanceStatus.present;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save attendance: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF00A884); // Professional green accent
    const darkBgColor = Color(0xFF121B22);

    return Scaffold(
      backgroundColor: darkBgColor,
      appBar: AppBar(
        title: const Text('Attendance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildDatePicker(context),
                  const SizedBox(height: 20),
                  Expanded(child: _buildStudentAttendanceList(accentColor)),
                  _buildAbsenteesButton(context, accentColor),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A3942),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),
            ),
            Icon(Icons.calendar_today_rounded, color: Colors.white.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentAttendanceList(Color accentColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: const Color(0xFF2A3942),
        child: Column(
          children: [
            _buildHeaderRow(accentColor),
            Divider(height: 1, thickness: 1, color: Colors.white.withOpacity(0.1)),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: _studentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: accentColor));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white70)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No students found.', style: TextStyle(color: Colors.white70)));
                  }

                  return ListView.separated(
                    itemCount: _students.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      return _buildStudentRow(student);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(Color accentColor) {
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white.withOpacity(0.7));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: Colors.white.withOpacity(0.05),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('USN', style: headerStyle)),
          Expanded(flex: 4, child: Text('Name', style: headerStyle)),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _timeSlots.map((slot) {
                final isActive = _activeSlot == slot;
                return InkWell(
                  onTap: () => setState(() => _activeSlot = slot),
                  child: Text(
                    slot.split(' ')[0], // Show only start time
                    textAlign: TextAlign.center,
                    style: headerStyle.copyWith(
                      color: isActive ? accentColor : Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRow(Student student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(student.usn, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)))),
          Expanded(flex: 4, child: Text(student.name, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9)), overflow: TextOverflow.ellipsis)),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _timeSlots.map((slot) {
                final isEnabled = slot == _activeSlot;
                final status = student.attendance[slot];
                final icon = status == AttendanceStatus.present
                    ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22)
                    : const Icon(Icons.cancel_rounded, color: Colors.red, size: 22);

                return IconButton(
                  icon: icon,
                  onPressed: isEnabled ? () => _toggleAttendance(student, slot) : null,
                  tooltip: isEnabled ? 'Toggle Status' : 'Select this time slot to mark attendance',
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenteesButton(BuildContext context, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            final absentees = _students                .where((s) => s.attendance[_activeSlot] == AttendanceStatus.absent)                
                .toList();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AbsenteesPage(
                  date: _selectedDate,
                  timeSlot: _activeSlot,
                   absentees: absentees,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          child: const Text(
            'View Absentees List',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}