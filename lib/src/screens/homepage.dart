import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'banner.dart';
import 'category.dart';
import 'itemcards.dart';
import 'trends.dart';
import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

Future<void> fetchBooks() async {
  try {
    final response = await Dio().get('http://192.168.56.1:5000/api/books'); // Replace with your server URL
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
    print('Error fetching books: $e');
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
              : BannerSection(book: randomBook),
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
                        builder: (context) => DetailsScreen(
                          imageUrl: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                          title: book['title'] ?? 'Unknown Title',
                          author: book['author'] ?? 'Unknown Author',
                          description: book['description'] ?? 'No description available.', 
                          bookUrl: book['pdf_url']
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
                        builder: (context) => DetailsScreen(
                          imageUrl: book['cover_url'] ?? 'assets/images/imgae_not.jpg',
                          title: book['title'] ?? 'Unknown Title',
                          author: book['author'] ?? 'Unknown Author',
                          description: book['description'] ?? 'No description available.', 
                          bookUrl: book['pdf_url']
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
