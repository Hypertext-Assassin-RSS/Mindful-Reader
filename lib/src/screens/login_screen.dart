import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title with Slide & Fade Animation
              Text(
                isLogin ? 'Welcome Back' : 'Create Account',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              .animate()
              .slideY(begin: -0.3, duration: 600.ms)
              .fadeIn(duration: 600.ms)
              .then(delay: 200.ms), // Chained animation
              
              const SizedBox(height: 40),

              // Email Field with Padding and Fade Animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: _buildTextField('Email', false)
                  .animate()
                  .fadeIn(duration: 800.ms),
              ),

              const SizedBox(height: 20),

              // Password Field with Padding and Fade Animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: _buildTextField('Password', true)
                  .animate()
                  .fadeIn(duration: 900.ms),
              ),

              if (!isLogin) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: _buildTextField('Confirm Password', true)
                    .animate()
                    .fadeIn(duration: 100.ms),
                ),
              ],

              const SizedBox(height: 40),

              // Button with Scale & Fade Animation
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  isLogin ? 'Login' : 'Sign Up',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
              .animate()
              .scale(duration: 500.ms, curve: Curves.easeInOut)
              .fadeIn(duration: 500.ms),

              const SizedBox(height: 20),

              // Toggle between Login and Signup with Fade & Slide Animation
              GestureDetector(
                onTap: toggleForm,
                child: Text(
                  isLogin
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Login",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
              .animate()
              .slideY(begin: 0.3, duration: 600.ms)
              .fadeIn(duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, bool obscureText) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),  // Added padding
      ),
    );
  }
}
