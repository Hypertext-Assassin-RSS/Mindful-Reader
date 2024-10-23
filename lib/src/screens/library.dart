import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  List<dynamic> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLibraryBooks();
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
          const SnackBar(content: Text('Username not found in SharedPreferences')),
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
        title: const Text('Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black54),
            tooltip: 'Search',
            onPressed: () {
              // search functionality
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text('No books found', style: TextStyle(fontSize: 18, color: Colors.black54)))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return GestureDetector(
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
                                  price: book['price'] ?? '0.00',
                                  rating: book['rating'] ?? 5,
                                  ),
                                ),
                              ),
                            );
                          },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  book['cover_url'],
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  book['title'] ?? 'Unknown Title',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  book['author'] ?? 'Unknown Author',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
