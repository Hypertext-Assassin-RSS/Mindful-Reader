import 'package:flutter/cupertino.dart';

import 'package:mindful_reader/src/screens/bookmark.dart';
import 'package:mindful_reader/src/screens/explore.dart';
import 'package:mindful_reader/src/screens/home.dart';
import 'package:mindful_reader/src/screens/profile.dart';
import 'package:mindful_reader/src/screens/search.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({super.key});

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int currentIndex = 0;
  final screens = [
    const Home(),
    const Search(),
    const Bookmark(),
    const Profile(),
  ];

  Color _getBackgroundColor(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return CupertinoColors.darkBackgroundGray.withOpacity(0.9);
    } else {
      return CupertinoColors.lightBackgroundGray.withOpacity(0.9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: _getBackgroundColor(context),
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home,size: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search,size: 25),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark_fill,size: 25),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle,size: 25),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return screens[index];
          },
        );
      },
    );
  }
}
