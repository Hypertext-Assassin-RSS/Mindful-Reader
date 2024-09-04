import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_reader/src/models/book.dart';
import 'package:mindful_reader/src/widgets/bookList.dart';

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
  List<String> sliderImages = [];
  bool isLoading = true;

  int _current = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    fetchBooks();
    fetchSliderImages();
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

  Future<void> fetchSliderImages() async {
    await dotenv.load(fileName: "assets/config/.env");
    try {
      final response = await Dio().get('${dotenv.env['API_BASE_URL']}/sliders/slider-images');
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            sliderImages = (response.data as List)
                .map((sliderJson) => sliderJson['imageUrl'] as String)
                .toList();
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load slider images');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (kDebugMode) {
        print('Error fetching slider images: $e');
      }
    }
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
            child: CarouselSlider(
              items: sliderImages.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    );
                  },
                );
              }).toList(),
              carouselController: _carouselController,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sliderImages.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
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

