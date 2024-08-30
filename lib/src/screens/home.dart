import 'package:flutter/cupertino.dart';
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

  void _onCategorySelected(String category) {
    print('Selected category: $category');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
          const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Welcome to Home Page'),
                  SizedBox(height: 20.0),
                  Text('Enjoy your stay!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
