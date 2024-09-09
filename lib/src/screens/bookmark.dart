import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({super.key, Text? title});
  
    @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for
    // the major Material Components.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
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


