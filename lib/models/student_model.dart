enum AttendanceStatus { present, absent }

class Student {
  final String usn;
  final String name;
  final String fatherPhone; // Added for absentee tracking
  Map<String, AttendanceStatus> attendance;

  Student({
    required this.usn,
    required this.name,
    required this.fatherPhone,
    required this.attendance,
  });

  // Factory constructor to create a student with default present status for all slots
  factory Student.create(String usn, String name, String fatherPhone, List<String> timeSlots) {
    return Student(
      usn: usn,
      name: name,
      fatherPhone: fatherPhone,
      attendance: {for (var slot in timeSlots) slot: AttendanceStatus.present},
    );
  }

  // Factory to create a Student from a JSON object from the API
  factory Student.fromJson(Map<String, dynamic> json, List<String> timeSlots) {
    return Student(
      usn: json['Student USN'] as String? ?? 'Unknown USN',
      name: json['Student Name'] as String? ?? 'Unknown Name',
      fatherPhone: json['Student Phone Number'] as String? ?? 'No Phone',
      // Initialize attendance with default 'present' status
      attendance: {for (var slot in timeSlots) slot: AttendanceStatus.present},
    );
  }
}
