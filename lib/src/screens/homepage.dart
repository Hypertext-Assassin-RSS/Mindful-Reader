import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_reader/src/widgets/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'banner.dart';
import '../widgets/category.dart';
import 'itemcards.dart';
import 'trends.dart';
import '../widgets/details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List books = [];
  bool isLoading = true;
  String username = '';
  Set<int> bookmarkedBookIds = Set();

  @override
  void initState() {
    super.initState();
    fetchUsernameAndBooks();
  }

  Future<void> fetchUsernameAndBooks() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    
    if (books.isEmpty) {
      debugPrint(books.isEmpty.toString());
      await fetchBooks();
    }
  }

  Future<void> fetchBooks() async {
    debugPrint('Getting Books');
    await dotenv.load(fileName: "assets/config/.env");
    try {
      final response = await Dio().get('${dotenv.env['API_BASE_URL']}/books/all');
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            books = response.data;
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

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomBook = books.isNotEmpty ? books[random.nextInt(books.length)] : null;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : BannerSection(book: randomBook ?? {}),
            const SizedBox(height: 5),
            const CategoryCard(),
            const SizedBox(height: 5),
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
                              isBookmarked: book['bookmarked'] ?? false,
                              id: book['_id'],
                              size: book['size'],
                              pages: book['pages'],
                              price: book['price'],
                              rating: book['rating'],
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
                              isBookmarked: book['bookmarked'] ?? false,
                              id: book['_id'],
                              size: book['size'],
                              pages: book['pages'],
                              price: book['price'],
                              rating: book['rating'],
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
