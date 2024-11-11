import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindful_reader/src/widgets/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/color.dart';
import '../screens/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = 'Username';
  String email = 'Email';
  bool _isLoggedIn = false;


  @override
  void initState() {
    _checkLoginStatus();
    _getUserData();
    super.initState();
  }

    Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
    else {
      _isLoggedIn = true;
    }
}


Future<void> _getUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    username = prefs.getString('username') ?? 'Username';
    email = prefs.getString('email') ?? 'Email';
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: KFourthColor,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KFourthColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/user.png'), // Replace with your profile picture
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    this.username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KFourthColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    this.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: KFourthColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Profile Options
            Expanded(
              child: ListView(
                children: [
                  ProfileMenu(
                    svg: 'assets/icons/privacy.svg',
                    text1: 'Privacy Policy',
                  ),
                  // ProfileMenu(
                  //   svg: 'assets/icons/settings.svg',
                  //   text1: 'Settings',
                  // ),
                  ProfileMenu(
                    svg: 'assets/icons/contact.svg',
                    text1: 'Contact Us',
                  ),
                  ProfileMenu(
                    svg: 'assets/icons/logout.svg',
                    text1: 'Log out',
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.svg,
    required this.text1,
    this.isLogout = false,
  });

  final String svg;
  final String text1;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLogout ? () => _showLogoutConfirmation(context) : null,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svg,
              color: KFourthColor,
              fit: BoxFit.scaleDown,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 20),
            Text(
              text1,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: KFourthColor.withOpacity(0.8),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: KFourthColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const BottomNavBar()),
  );
}

}