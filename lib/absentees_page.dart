import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'dart:io';
import 'package:markme/models/student_model.dart';
import 'package:image_picker/image_picker.dart';

class AbsenteesPage extends StatefulWidget {
  final DateTime date;
  final String timeSlot;
  final List<Student> absentees;

  const AbsenteesPage({
    Key? key,
    required this.date,
    required this.timeSlot,
    required this.absentees,
  }) : super(key: key);

  @override
  State<AbsenteesPage> createState() => _AbsenteesPageState();
}

class _AbsenteesPageState extends State<AbsenteesPage> {
  // State to manage the status of each student
  late Map<String, bool> _communicationStatus;
  // State to manage uploaded screenshots for each student
  late Map<String, File?> _screenshots;
  // State to manage if the summary has been submitted for a student
  late Map<String, bool> _isSubmitted;

  @override
  void initState() {
    super.initState();
    // Initialize the status for each absentee. In a real app, you'd fetch this from a database.
    _communicationStatus = {for (var student in widget.absentees) student.usn: false};
    _screenshots = {for (var student in widget.absentees) student.usn: null};
    _isSubmitted = {for (var student in widget.absentees) student.usn: false};
  }

  Future<void> _pickImage(String usn) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image from the gallery.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _screenshots[usn] = File(image.path);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF0D1B2A);
    final formattedDate = DateFormat('d MMMM yyyy').format(widget.date);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Absentee Tracking', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: headerColor.withOpacity(0.85),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mit_college_building.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _buildInfoHeader(formattedDate),
                ),
                Expanded(
                  child: widget.absentees.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                          itemCount: widget.absentees.length,
                          itemBuilder: (context, index) {
                            final student = widget.absentees[index];
                            return _buildAbsenteeCard(student);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoHeader(String formattedDate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Text(
        'Date: $formattedDate  •  Slot: ${widget.timeSlot}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF0D1B2A),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 80,
            color: Colors.green.withOpacity(0.8),
          ),
          const SizedBox(height: 20),
          const Text(
            'All Students Accounted For',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no absentees for this slot.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenteeCard(Student student) {
    const accentColor = Color(0xFF0077B6); // Royal Blue
    final bool isDone = _communicationStatus[student.usn] ?? false;
    final bool hasBeenSubmitted = _isSubmitted[student.usn] ?? false;
    final File? screenshot = _screenshots[student.usn];

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: USN, Name, and Call Time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.usn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A))),
                      const SizedBox(height: 4),
                      Text(student.name, style: const TextStyle(fontSize: 18, color: Colors.black87)),
                    ],
                  ),
                ),
                Text(
                  'Call Time: --:--', // Placeholder
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Phone Number
            InkWell(
              onTap: () {
                // TODO: Implement phone call functionality using url_launcher
                print('Calling ${student.fatherPhone}...');
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, color: accentColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      student.fatherPhone, // Assuming Student model has this
                      style: const TextStyle(fontSize: 16, color: accentColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),

            // Conversation Summary
            const Text('Conversation Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              readOnly: hasBeenSubmitted,
              decoration: InputDecoration(
                hintText: 'Enter notes from the conversation...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Screenshot Upload
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: hasBeenSubmitted ? null : () => _pickImage(student.usn),
                  icon: const Icon(Icons.upload_file_rounded, size: 20),
                  label: const Text('Upload Screenshot'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: BorderSide(color: accentColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: screenshot != null
                      ? Row(
                          children: [
                            const Icon(Icons.image_rounded, color: Colors.green, size: 20),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                screenshot.path.split(Platform.pathSeparator).last,
                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : const Text('No file selected.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: hasBeenSubmitted ? null : () {
                  setState(() {
                    _isSubmitted[student.usn] = true;
                  });
                  // TODO: Implement actual save logic to database
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Summary for ${student.usn} submitted!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const Divider(height: 24),

            // Status Switch
            Center(
              child: Switch(
                value: isDone,
                onChanged: (value) {
                  setState(() {
                    _communicationStatus[student.usn] = value;
                  });
                },
                activeColor: Colors.green.shade600,
                activeTrackColor: Colors.green.shade200,
                inactiveThumbColor: Colors.red.shade600,
                inactiveTrackColor: Colors.red.shade200,
                thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Icon(Icons.check_rounded, color: Colors.white);
                  }
                  return const Icon(Icons.close_rounded, color: Colors.white);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}