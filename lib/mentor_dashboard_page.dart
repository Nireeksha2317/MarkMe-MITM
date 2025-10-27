import 'package:flutter/material.dart';
import 'package:markme/models/student_model.dart';
import 'package:markme/student_info_page.dart';

class MentorDashboardPage extends StatefulWidget {
  const MentorDashboardPage({Key? key}) : super(key: key);

  @override
  State<MentorDashboardPage> createState() => _MentorDashboardPageState();
}

class _MentorDashboardPageState extends State<MentorDashboardPage> {
  // In a real app, this data would be fetched from a database.
  final List<Student> _allMentees = [
    Student.create('4MT21AI001', 'Aarav Sharma', '9876543210', []),
    Student.create('4MT21AI002', 'Bhavana Rao', '9876543211', []),
    Student.create('4MT21AI003', 'Chetan Kumar', '9876543212', []),
    Student.create('4MT21AI004', 'Divya Singh', '9876543213', []),
    Student.create('4MT21AI005', 'Eshan Gupta', '9876543214', []),
    Student.create('4MT21AI006', 'Farah Khan', '9876543215', []),
    Student.create('4MT21AI007', 'Girish Reddy', '9876543216', []),
    Student.create('4MT21AI008', 'Harini Iyer', '9876543217', []),
    Student.create('4MT21AI009', 'Imran Pasha', '9876543218', []),
  ];

  late List<Student> _filteredMentees;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMentees = _allMentees;
    _searchController.addListener(_filterMentees);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMentees);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMentees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMentees = _allMentees.where((mentee) {
        final nameMatches = mentee.name.toLowerCase().contains(query);
        final usnMatches = mentee.usn.toLowerCase().contains(query);
        return nameMatches || usnMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF00A884); // A professional green accent
    const darkBgColor = Color(0xFF121B22);
    const cardBgColor = Color(0xFF2A3942);

    return Scaffold(
      backgroundColor: darkBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              color: cardBgColor,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      'Mentoring Dashboard',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _buildSearchBar(accentColor),
                  Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _filteredMentees.length,
                      separatorBuilder: (context, index) => Divider(indent: 80, endIndent: 20, color: Colors.white.withOpacity(0.1)),
                      itemBuilder: (context, index) {
                        final mentee = _filteredMentees[index];
                        return _buildMenteeTile(mentee, accentColor);
                      },
                    ),
                  ),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '[ Search Student by Name/USN ]',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accentColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildMenteeTile(Student mentee, Color accentColor) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate to the detailed student information page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentInfoPage(student: mentee)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: accentColor.withOpacity(0.8),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF2A3942),
                  child: Text('Student\nPhoto', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: Colors.white.withOpacity(0.6))),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mentee.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.9))),
                    const SizedBox(height: 4),
                    Text(mentee.usn, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.4), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      color: Colors.transparent,
      child: Text(
        'Total Mentees: ${_allMentees.length}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.6)),
      ),
    );
  }
}
