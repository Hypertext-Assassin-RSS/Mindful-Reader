import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'banner.dart';
import 'category.dart';
import 'itemcards.dart';
import 'trends.dart';

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
      final response = await http.get(Uri.parse('https://gutendex.com/books'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data['results'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        isLoading = false;
      });
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
                      // Handle book click
                    },
                    child: ItemCards(
                      imagepic: book['formats']['image/jpeg'] ?? 'assets/images/imgae_not.jpg', // Fallback image
                      text1: book['title'] ?? 'Unknown Title',
                      text2: book['authors'].isNotEmpty ? book['authors'][0]['name'] : 'Unknown Author',
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
                      // Handle book click
                    },
                    child: ItemCards(
                      imagepic: book['formats']['image/jpeg'] ?? 'assets/images/imgae_not.jpg',
                      text1: book['title'] ?? 'Unknown Title',
                      text2: book['authors'].isNotEmpty ? book['authors'][0]['name'] : 'Unknown Author',
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
