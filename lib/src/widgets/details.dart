import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../colors/color.dart';
import '../screens/read.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String author;
  final String description;
  final String bookUrl;
  final int size;
  final int pages;
  final int price;
  final double rating;
  final bool isBookmarked;

  const DetailsScreen({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.description,
    required this.bookUrl,
    required this.isBookmarked,
    required this.size,
    required this.pages,
    required this.price,
    required this.rating,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool isBookmarked;
  late bool isPurchased = false; // Initialize the isPurchased flag
  String username = '';

  @override
  void initState() {
    fetchBookmarks();
    checkLibrary();
    super.initState();
    isBookmarked = widget.isBookmarked;
  }

  Future<void> fetchBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    try {
      final response = await Dio().get('${dotenv.env['API_BASE_URL']}/bookmarks/title',
          data: {
            "username": username,
            'title': widget.title,
          });
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        setState(() {
          isBookmarked = true;
        });
      } else {
        debugPrint('Failed to load bookmarks or Not Bookmark');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bookmarks: $e');
      }
    }
  }

  Future<void> checkLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    try {
      final response = await Dio().get('${dotenv.env['API_BASE_URL']}/library/library-book',
          data: {
            "username": username,
            'title': widget.title,
          });
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        setState(() {
          isPurchased = true;
          debugPrint('Book Purchased');
        });
      } else {
        debugPrint('Book is Not Purchased');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bookmarks: $e');
      }
    }
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    await dotenv.load(fileName: "assets/config/.env");

    setState(() {
      isBookmarked = !isBookmarked;
    });

    try {
      if (isBookmarked) {
        await Dio().post('${dotenv.env['API_BASE_URL']}/bookmarks/add',
          data: {
            'username': username,
            'title': widget.title,
          },
        );
      } else {
        await Dio().delete('${dotenv.env['API_BASE_URL']}/bookmarks/remove',
          data: {
            'username': username,
            'title': widget.title,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isBookmarked ? 'Bookmarked!' : 'Removed from bookmarks'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      setState(() {
        isBookmarked = !isBookmarked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update bookmark status. Please try again.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Function to open the URL in the browser
Future<void> _openUrlInBrowser() async {
 final Uri url = Uri.parse('https://frontend-cyan-eta.vercel.app/books/details/'+ widget.id);
 if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
 }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.yellow : Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/image_not.jpg',
                      fit: BoxFit.cover,
                      height: 300,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // If purchased, allow reading, else open URL in browser
                    InkWell(
                      onTap: () {
                        if (isPurchased) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadBookScreen(bookUrl: widget.bookUrl),
                            ),
                          );
                        } else {
                          _openUrlInBrowser();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          color: KFourthColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isPurchased ? 'Read' : 'Get Book',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: _toggleBookmark,
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          color: isBookmarked ? Colors.yellow[700] : KFourthColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isBookmarked ? 'Bookmarked' : 'Bookmark',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isBookmarked ? Colors.black : KPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pages: ${widget.pages}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Size: ${widget.size} MB',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rs: ${widget.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < widget.rating ? Icons.star : Icons.star_border,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
