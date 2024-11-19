import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(),
      home: Search(),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<String> categories = ["All", "Unread", "Favorites", "Archived"];

  Color _getBackgroundColor(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return CupertinoColors.black;
    } else {
      return CupertinoColors.white;
    }
  }


  Color _getTextColor(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.black;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SuperScaffold(
        appBar: SuperAppBar(
          title: Text(
            "Explore",
            style: TextStyle(
              color: _getTextColor(context),
            ),
          ),
          backgroundColor: _getBackgroundColor(context),
          largeTitle: SuperLargeTitle(
            enabled: true,
            largeTitle: "Search",
            textStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: _getTextColor(context),
            ),
          ),
          searchBar: SuperSearchBar(
            enabled: true,
            backgroundColor: isDarkMode ? CupertinoColors.darkBackgroundGray : CupertinoColors.lightBackgroundGray,
            textStyle: TextStyle(
              color: _getTextColor(context),
            ),
            onChanged: (query) {
              // Search Bar Changes
            },
            onSubmitted: (query) {
              // On Search Bar submitted
            },
          ),
        ),
      ),
    );
  }
}
