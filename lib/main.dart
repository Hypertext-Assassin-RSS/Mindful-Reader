import 'package:flutter/material.dart';
import 'package:mindful_reader/src/screens/home.dart';
import 'package:mindful_reader/src/widgets/bottomTabBar.dart';
import 'src/screens/login.dart';
// ignore: unused_import
import 'package:mindful_reader/src/widgets/bottomnav.dart';
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
      home: const BottomTabBar(),
    );
  }
}
