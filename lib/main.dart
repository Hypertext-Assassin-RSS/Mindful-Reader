import 'package:flutter/material.dart';
import 'src/screens/login.dart';
// ignore: unused_import
import 'package:mindful_reader/src/widgets/bottomnav.dart';
import './src/colors/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: KFifthColor
      ),
      // home: const BottomNavBar(),
      home: const LoginScreen(),
    );
  }
}
