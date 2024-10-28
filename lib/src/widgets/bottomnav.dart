import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindful_reader/src/screens/bookmark.dart';
import '../colors/color.dart';
import '../screens/homepage.dart';
import '../screens/profile.dart';
import '../screens/explore.dart';
import '../screens/library.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  final screens = [
    const HomePage(),
    const ExploreScreen(),
    const Library(),
    const Bookmark(),
    const Profile(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: KFourthColor.withOpacity(0.4),
          selectedItemColor: KFourthColor,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: KFourthColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                color: KFourthColor,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/book-bookmark.svg',
                color: KFourthColor,
                width: 16,
                height: 19,
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bookmark-solid.svg',
                color: KFourthColor,
                width: 16,
                height: 19,
              ),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/user-solid.svg',
                color: KFourthColor,
                width: 16,
                height: 19,
              ),
              label: 'Profile',
            )  
          ]),
    );
  }
}