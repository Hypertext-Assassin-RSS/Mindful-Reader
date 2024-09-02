import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_reader/src/models/book.dart';
import 'package:mindful_reader/src/widgets/bookList.dart';
import 'package:mindful_reader/src/widgets/categorySelector.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(),
      home: PageScaffold(),
    );
  }
}

class PageScaffold extends StatefulWidget {
  const PageScaffold({super.key});

  @override
  State<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold> {
  final List<String> categories = ["All", "Unread", "Favorites", "Archived"];
  List<Book> books = [];
  bool isLoading = true;

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

  void _onCategorySelected(String category) {
    print('Selected category: $category');
  }

  Color _getBackgroundColor(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return CupertinoColors.black;
    } else {
      return CupertinoColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: _getBackgroundColor(context),
      child: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text(
              'Home',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CategorySelector(
                categories: categories,
                onCategorySelected: _onCategorySelected,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Books',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : BookListWidget(books: books),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Free',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : BookListWidget(books: books),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
