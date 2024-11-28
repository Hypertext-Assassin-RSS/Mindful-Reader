import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_reader/src/widgets/splashScreen.dart';

import '../widgets/category.dart';
import 'itemcards.dart';
import 'trends.dart';
import '../widgets/details.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List books = [];
  List filteredBooks = [];
  bool isLoading = true;
  bool _isSearchVisible = false; 
  final TextEditingController _searchController = TextEditingController(); 
  final FocusNode _searchFocusNode = FocusNode(); 

  @override
  void initState() {
    super.initState();
    if (books.isEmpty) {
      fetchBooks();
    }
    _searchController.addListener(_filterBooks);
  }

  Future<void> fetchBooks() async {
    debugPrint('Getting Books');
    await dotenv.load(fileName: "assets/config/.env");
    try {
      final response = await Dio().get('${dotenv.env['API_BASE_URL']}/api/products/all');
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            books = response.data;
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
      if (kDebugMode) {
        print('Error fetching books: $e');
      }
    }
  }

  void _filterBooks() {
    setState(() {
      filteredBooks = books
          .where((book) =>
              book['title'].toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
          if (kDebugMode) {
            print('Filtered Books: ${filteredBooks.length}');
          }
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchFocusNode.requestFocus();
      } else {
        _searchFocusNode.unfocus();
        _searchController.clear();
        filteredBooks = books;
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBooks);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for
    // the major Material Components.
    return Scaffold(
      appBar: AppBar(
        title: _isSearchVisible
            ? CupertinoSearchTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                placeholder: 'Search',
                style: const TextStyle(color: Colors.black),
              )
            : const Text('Search',
            style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
            ),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            tooltip: 'Search',
            onPressed: _toggleSearchBar,
          ),
        ],
      ),
      body: isLoading? Column(
                  children: [
                    const LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    // const Text(
                    //   "Loading books, please wait...",
                    //   style: TextStyle(fontSize: 16, color: Colors.grey),
                    // ),
                  ],
                )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const CategoryCard(),
                  const SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredBooks.map((book) {
                        return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(
                                imageUrl: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                                nextScreen: DetailsScreen(
                                  imageUrl: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                                  title: book['title'] ?? 'Unknown Title',
                                  author: book['author'] ?? 'Unknown Author',
                                  description: book['description'] ?? 'No description available.',
                                  bookUrl: book['pdf_url'],
                                  sample_url: book['sample_url'],
                                  isBookmarked: book['bookmarked'] ?? false,
                                  id: book['_id'],
                                  size: book['size'] ?? '00',
                                  pages: book['pages'] ?? '01',
                                  price: book['price'] ?? '00',
                                  rating: book['rating'] ?? '5.00',
                                ),
                              ),
                            ),
                          );
                        },
                          child: ItemCards(
                            imagepic: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                            text1: book['title'] ?? 'Unknown Title',
                            text2: book['author'] ?? 'Unknown Author',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Trends(),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: books.map((book) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplashScreen(
                                  imageUrl: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                                  nextScreen: DetailsScreen(
                                    imageUrl: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                                    title: book['title'] ?? 'Unknown Title',
                                    author: book['author'] ?? 'Unknown Author',
                                    description: book['description'] ?? 'No description available.',
                                    bookUrl: book['pdf_url'],
                                    sample_url: book['sample_url'],
                                    isBookmarked: book['bookmarked'] ?? false,
                                    id: book['_id'],
                                    size: book['size'] ?? '00',
                                    pages: book['pages'] ?? '01',
                                    price: book['price'] ?? '00',
                                    rating: book['rating'] ?? '5.00',
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ItemCards(
                            imagepic: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                            text1: book['title'] ?? 'Unknown Title',
                            text2: book['author'] ?? 'Unknown Author',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
