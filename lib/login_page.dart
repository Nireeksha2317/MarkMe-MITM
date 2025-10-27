import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'home_screen.dart';

void main() {
  runApp(const MarkMeApp());
}

class MarkMeApp extends StatelessWidget {
  const MarkMeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'MarkMe - Faculty Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF21808D),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF21808D),
          secondary: const Color(0xFF21808D),
        ),
      ),
      home: const FacultyLoginScreen(),
    );
  }
}

class FacultyLoginScreen extends StatefulWidget {
  const FacultyLoginScreen({Key? key}) : super(key: key);

  @override
  State<FacultyLoginScreen> createState() => _FacultyLoginScreenState();
}

class _FacultyLoginScreenState extends State<FacultyLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _facultyNameController = TextEditingController();
  final _facultyIdController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedSemester;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showSuccessMessage = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _facultyNameController.dispose();
    _facultyIdController.dispose();
    _passwordController.dispose();
    // No need to dispose _selectedSemester as it's a simple String
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _showSuccessMessage = true;
      });

      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }

      // The success message and form reset can be removed if you navigate away permanently.
      // I'll leave them here in case you want to pop back to the login screen.

      setState(() {
        _showSuccessMessage = false;
      });

      // Reset form
      _formKey.currentState!.reset();
      _facultyNameController.clear();
      _facultyIdController.clear();
      _passwordController.clear();
      setState(() {
        _selectedSemester = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/mit_college_building.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
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
            ),
          ),

          // Login Form
          SafeArea(
            child: Center(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 24 : 40,
                  vertical: 20,
                ),
                children: [
                  FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Card(
                        elevation: 24,
                        shadowColor: Colors.black.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(isSmallScreen ? 32 : 40),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.96),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // MIT Logo
                                _buildLogo(isSmallScreen),

                                SizedBox(height: isSmallScreen ? 24 : 28),

                                // Institution Name
                                Text(
                                  'Maharaja Institute of Technology',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 21 : 24,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1D3B4B),
                                    height: 1.3,
                                    letterSpacing: -0.5,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // Location
                                Text(
                                  'Mysore',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 15 : 17,
                                    color: const Color(0xFF626C71),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),

                                SizedBox(height: isSmallScreen ? 28 : 36),

                                // Login Title
                                Text(
                                  'Faculty Login',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 26 : 30,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF21808D),
                                    letterSpacing: -0.8,
                                  ),
                                ),

                                SizedBox(height: isSmallScreen ? 28 : 36),

                                // Success Message
                                if (_showSuccessMessage) _buildSuccessMessage(),

                                // Faculty Name Field
                                _buildTextField(
                                  controller: _facultyNameController,
                                  label: 'Faculty Name',
                                  hint: 'Enter your full name',
                                  icon: Icons.person_outline_rounded,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your faculty name';
                                    }
                                    if (value.trim().length < 3) {
                                      return 'Name must be at least 3 characters';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                // Faculty ID Field
                                _buildTextField(
                                  controller: _facultyIdController,
                                  label: 'Faculty ID',
                                  hint: 'e.g., FAC2025001',
                                  icon: Icons.badge_outlined,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your faculty ID';
                                    }
                                    if (!RegExp(r'^[A-Za-z0-9]+$')
                                        .hasMatch(value.trim())) {
                                      return 'Faculty ID: letters and numbers only';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                // Semester Dropdown
                                _buildSemesterDropdown(),

                                const SizedBox(height: 22),

                                // Password Field
                                _buildPasswordField(isSmallScreen),

                                SizedBox(height: isSmallScreen ? 32 : 40),

                                // Login Button
                                _buildLoginButton(isSmallScreen),

                                SizedBox(height: isSmallScreen ? 28 : 32),

                                // Footer
                                _buildFooter(isSmallScreen),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isSmallScreen) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: isSmallScreen ? 110 : 130,
            height: isSmallScreen ? 110 : 130,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mit_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF21808D).withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF21808D).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.check_circle_rounded, color: Color(0xFF21808D), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Login successful! Redirecting...',
              style: TextStyle(
                color: Color(0xFF21808D),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D3B4B),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1D3B4B),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFF626C71).withOpacity(0.5),
              fontSize: 15,
            ),
            suffixIcon: Icon(icon, color: const Color(0xFF21808D), size: 22),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF21808D).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF21808D).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF21808D),
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC0152F),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC0152F),
                width: 2.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterDropdown() {
    const List<String> semesters = ['1st sem', '3rd sem', '5th sem'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Semester',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D3B4B),
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedSemester,
          hint: Text(
            'Select a semester',
            style: TextStyle(
              color: const Color(0xFF626C71).withOpacity(0.5),
              fontSize: 15,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded,
              color: Color(0xFF21808D)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF21808D).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF21808D).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF21808D),
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC0152F),
                width: 1.5,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          items: semesters.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedSemester = newValue;
            });
          },
          validator: (value) =>
              value == null ? 'Please select a semester' : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Department Password',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D3B4B),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the department password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1D3B4B),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Enter department password',
            hintStyle: TextStyle(
              color: const Color(0xFF626C71).withOpacity(0.5),
              fontSize: 15,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: const Color(0xFF21808D),
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF21808D).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF21808D).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF21808D),
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC0152F),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC0152F),
                width: 2.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 54 : 58,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF21808D),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFF21808D).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          disabledBackgroundColor: const Color(0xFF21808D).withOpacity(0.6),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Logging in',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 14),
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ],
              )
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: isSmallScreen ? 17 : 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter(bool isSmallScreen) {
    return Column(
      children: [
        Container(
          height: 1.5,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFF21808D).withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Text(
          'Maharaja Institute of Technology',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            color: const Color(0xFF626C71),
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Belawadi, Srirangapatna Tq., Mysore - 571438',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: const Color(0xFF626C71).withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}