import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:markme/attendance_list_page.dart';
import 'package:markme/mentor_dashboard_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF003366); // Navy Blue

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur and Gradient
          _buildBackground(),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // AIML Logo
                _buildLogo(),
                const SizedBox(height: 20),
                // Department Titles
                _buildTitles(),
                const Spacer(),
                // Feature Cards
                _buildFeatureCards(context),
                const Spacer(),
                // Footer
                _buildFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/mit_college_building.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF003366).withOpacity(0.5),
                const Color(0xFF003366).withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: const Icon(
        Icons.computer_rounded, // Placeholder for AIML logo
        color: Colors.white,
        size: 50,
      ),
    );
  }

  Widget _buildTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text(
            'Maharaja Institute of Technology Mysore',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(blurRadius: 10.0, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Artificial Intelligence and Machine Learning',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              shadows: const [
                Shadow(blurRadius: 8.0, color: Colors.black45),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: _buildFeatureCard(
              context: context,
              title: 'Attendance',
              icon: Icons.checklist_rtl_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AttendanceListPage()),
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildFeatureCard(
              context: context,
              title: 'Mentoring',
              icon: Icons.handshake_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MentorDashboardPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF003366); // Navy Blue

    return AspectRatio(
      aspectRatio: 0.9,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            splashColor: primaryColor.withOpacity(0.1),
            highlightColor: primaryColor.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.1), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(icon, size: 40, color: primaryColor),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      '© Copyright • Mentoring Tracker',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 12,
      ),
    );
  }
}

