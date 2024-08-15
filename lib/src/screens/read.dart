import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadBookScreen extends StatelessWidget {
  final String bookUrl;

  const ReadBookScreen({super.key, required this.bookUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Book'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: bookUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
