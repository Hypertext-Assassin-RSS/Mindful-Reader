import 'package:flutter/material.dart';
import 'package:mindful_reader/src/screens/login.dart';
import './src/colors/color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");
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
