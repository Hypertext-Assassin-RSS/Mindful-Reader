import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mindful_reader/src/widgets/bottomnav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false; 
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }


  bool _validateInputs() {
    if (isLogin) {
      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return false;
      }
    } else {
      if (_usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return false;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return false;
      }
    }
    return true;
  }


  Future<void> _login() async {
    if (!_validateInputs()) return;

    final username = _usernameController.text;
    final password = _passwordController.text;
    await dotenv.load(fileName: "assets/config/.env");

    try {
      final response = await Dio().post('${dotenv.env['API_BASE_URL']}/auth/login',
        data: {
          'email': username,
          'password': password,
        },
      );

      debugPrint(response.statusCode.toString());
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];

        // Save the JWT token in shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username);

        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            padding: const EdgeInsets.all(20),
            content: const Text('Login successful! Redirecting...'),
            leading: const Icon(Icons.check_circle_outline, color: Colors.green),
            backgroundColor: Colors.green[300],
            actions: <Widget>[
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                child: const Text('DISMISS'),
              ),
            ],
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
        });
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid login credentials')),
        );
      }
    } catch (error) {
      debugPrint('error: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the server')),
      );
    }
  }

  // Perform Signup
  Future<void> _signup() async {
    if (!_validateInputs()) return;

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    await dotenv.load(fileName: "assets/config/.env");

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_BASE_URL']}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'role':'reader',
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Save the JWT token in shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            padding: const EdgeInsets.all(20),
            content: const Text('Signup successful! Redirecting...'),
            leading: const Icon(Icons.check_circle_outline, color: Colors.green),
            backgroundColor: Colors.green[300],
            actions: <Widget>[
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                child: const Text('DISMISS'),
              ),
            ],
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
        });
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed')),
        );
      }
    } catch (error) {
      // Handle server errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the server')),
      );
    }
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
                  .then(delay: 200.ms),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: _buildTextField('Username', false, _usernameController)
                    .animate()
                    .fadeIn(duration: 700.ms),
              ),

              if (!isLogin) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: _buildTextField('Email', false, _emailController)
                      .animate()
                      .fadeIn(duration: 800.ms),
                ),
              ],

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: _buildPasswordTextField(
                  'Password', 
                  _passwordController, 
                  _passwordVisible,
                  () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  }
                ).animate().fadeIn(duration: 900.ms),
              ),

              if (!isLogin) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: _buildPasswordTextField(
                    'Confirm Password', 
                    _confirmPasswordController, 
                    _confirmPasswordVisible, 
                    () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    }
                  ).animate().fadeIn(duration: 1000.ms),
                ),
              ],

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: isLogin ? _login : _signup,
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

  Widget _buildTextField(String hint, bool obscureText, TextEditingController controller) {
    return TextField(
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      ),
    );
  }

  // Build a text field with password visibility toggle
  Widget _buildPasswordTextField(String hint, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white54,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
