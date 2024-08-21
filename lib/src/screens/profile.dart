import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../colors/color.dart';
import '../screens/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: SafeArea(
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: KFourthColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 70),
        SettingsMenu(
          svg: 'assets/icons/settings.svg',
          text1: 'Profile Settings',
        ),
        SizedBox(height: 20),
        SettingsMenu(
          svg: 'assets/icons/notification.svg',
          text1: 'Notification',
        ),
        SizedBox(height: 20),
        SettingsMenu(
          svg: 'assets/icons/security.svg',
          text1: 'Privacy & Security',
        ),
        SizedBox(height: 20),
        SettingsMenu(
          svg: 'assets/icons/back.svg',
          text1: 'Logout',
          isLogout: true,
        ),
      ],
    ));
  }
}

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
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
        width: 250,
        decoration: BoxDecoration(
          color: KPrimaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              SvgPicture.asset(
                svg,
                color: KFifthColor,
                fit: BoxFit.scaleDown,
              ),
              const SizedBox(width: 20),
              Text(
                text1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: KFifthColor.withOpacity(0.6),
                ),
              )
            ],
          ),
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

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}