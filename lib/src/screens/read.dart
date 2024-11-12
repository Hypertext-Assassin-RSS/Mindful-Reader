import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:no_screenshot/no_screenshot.dart';

class ReadBookScreen extends StatefulWidget {
  final String bookUrl;
  final String title;
  final int id;

  const ReadBookScreen({super.key, required this.bookUrl, required this.title, required  this.id});

  @override
  _ReadBookScreenState createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends State<ReadBookScreen> {
  final noScreenshot = NoScreenshot.instance;

  String? localPath;
  bool isLoading = true;
  int totalPages = 0;
  int currentPage = 0;
  PDFViewController? pdfViewController;

  @override
  void initState() {
    super.initState();
    noScreenshot.screenshotOff();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${widget.id}.pdf');

    if (await file.exists()) {
      debugPrint('Loading local PDF');

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } else {
      await _downloadAndSavePDF(file);
    }
  }

  Future<void> _downloadAndSavePDF(File file) async {
    debugPrint('Downloading PDF');
    try {
      final response = await http.get(Uri.parse(widget.bookUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error downloading PDF: $e');
    }
  }

  void _jumpToPage(int pageNumber) {
    if (pdfViewController != null && pageNumber >= 0 && pageNumber < totalPages) {
      pdfViewController!.setPage(pageNumber);
    }
  }

  void _nextPage() {
    if (pdfViewController != null && currentPage < totalPages - 1) {
      pdfViewController!.setPage(currentPage + 1);
    }
  }

  void _previousPage() {
    if (pdfViewController != null && currentPage > 0) {
      pdfViewController!.setPage(currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Text('Page $currentPage of $totalPages'),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
              ? Column(
                  children: [
                    Expanded(
                      child: PDFView(
                        filePath: localPath,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: false,
                        onViewCreated: (PDFViewController vc) {
                          setState(() {
                            pdfViewController = vc;
                          });
                        },
                        onRender: (pages) {
                          setState(() {
                            totalPages = pages!;
                          });
                        },
                        onPageChanged: (page, total) {
                          setState(() {
                            currentPage = page!;
                          });
                        },
                        onError: (error) {
                          print('Error displaying PDF: $error');
                        },
                        onPageError: (page, error) {
                          print('Error on page $page: $error');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _previousPage,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Go page',
                              ),
                              onSubmitted: (value) {
                                int page = int.tryParse(value) ?? 0;
                                _jumpToPage(page);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: _nextPage,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(child: Text('Failed to load PDF')),
    );
  }
}
