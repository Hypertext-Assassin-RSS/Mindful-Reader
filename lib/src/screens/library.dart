import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_reader/src/screens/itemcards.dart';
import 'package:mindful_reader/src/screens/login.dart';
import 'package:mindful_reader/src/widgets/details.dart';
import 'package:mindful_reader/src/widgets/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  late String username;
  late String userId;
  bool _isSearchVisible = false; 
  final TextEditingController _searchController = TextEditingController(); 
  final FocusNode _searchFocusNode = FocusNode(); 

  List<dynamic> books = [];
  bool isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    fetchLibraryBooks();
  }

    void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchFocusNode.requestFocus();
      } else {
        _searchFocusNode.unfocus();
        _searchController.clear();
        books = books;
      }
    });
  }

  Future<void> _checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
  else {
    _isLoggedIn = true;
  }
}

  Future<void> fetchLibraryBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username') ?? '';
      userId = prefs.getString('userId') ?? '';

      await dotenv.load(fileName: "assets/config/.env");

      if (username.isNotEmpty) {
        var dio = Dio();
        final response = await dio.get(
          '${dotenv.env['API_BASE_URL']}/library/' + userId,
        );

        if (response.statusCode == 200) {
          setState(() {
            books = response.data;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch library books')),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to access library!')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while fetching books')),
      );
    }
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
          const SizedBox(height: 5),
          Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Center(
                    child: InkWell(
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
