import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_reader/src/screens/itemcards.dart';
import 'package:mindful_reader/src/screens/login.dart';
import 'package:mindful_reader/src/widgets/category.dart';
import 'package:mindful_reader/src/widgets/details.dart';
import 'package:mindful_reader/src/widgets/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
    List books = [];
    List filteredBooks = [];
    bool isLoading = false;
    bool _isSearchVisible = false; 
    final TextEditingController _searchController = TextEditingController(); 
    final FocusNode _searchFocusNode = FocusNode(); 

      @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    if (books.isEmpty) {
      fetchBooks();
    }
    _searchController.addListener(_filterBooks);
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login to access bookmarks!')), 
            
          );
    }
  }



    Future<void> fetchBooks() async {
    debugPrint('Getting Bookmarks');
    await dotenv.load(fileName: "assets/config/.env");
      final prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
    try {
      final response = await Dio().get('${dotenv.env['API_BASE_URL']}/api/bookmarks/allbookmarks',
      data: {
          'username': username,
        },
      );


      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            books = response.data['productDetails'];
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
      body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : Column(
        children: [
          const SizedBox(height: 5),
          const CategoryCard(),
          const SizedBox(height: 5),
          Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 7.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(
                              imageUrl: book['cover_url'] ?? 'assets/images/image_not.jpg',
                              nextScreen: DetailsScreen(
                                imageUrl: book['cover_url'] ?? 'assets/images/image_not.jpg',
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
                        imagepic: book['cover_url'] ?? 'assets/images/image_not.jpg',
                        text1: book['title'] ?? 'Unknown Title',
                        text2: book['author'] ?? 'Unknown Author',
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}