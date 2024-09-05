import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindful_reader/src/models/book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_reader/src/widgets/categorySelector.dart';
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
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    await dotenv.load(fileName: "assets/config/.env");
    try {
      final response = await Dio().get('${dotenv.env['API_BASE_URL']}/books');
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            books = (response.data as List)
                .map((bookJson) => Book.fromJson(bookJson))
                .toList();
            filteredBooks = books;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching books: $e');
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? CupertinoColors.black : CupertinoColors.white;
  }

  Color _getTextColor(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.black;
  }

  void _onCategorySelected(String category) {
    print('Selected category: $category');
  }

  void _filterBooks(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredBooks = books.where((book) {
        return book.title.toLowerCase().contains(searchQuery);
      }).toList();
    });
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
              _filterBooks(query);
            },
            onSubmitted: (query) {
              _filterBooks(query);
            },
          ),
        ),
        body: isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  child: Column(
                    children: [
                      CategorySelector(
                        categories: categories,
                        onCategorySelected: _onCategorySelected,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredBooks.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          Book book = filteredBooks[index];
                          return Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8.0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(book.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
