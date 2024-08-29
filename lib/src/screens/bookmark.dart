import 'package:flutter/material.dart';

class Bookmark extends StatelessWidget {
  const Bookmark({super.key, Text? title});
  
    @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for
    // the major Material Components.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: const [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      // body is the majority of the screen.
      body: const Center(
        child: Text('Bookmarks!'),
      ),
    );
  }



}

class MyScaffold extends StatelessWidget {

  const MyScaffold({super.key});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  
}


