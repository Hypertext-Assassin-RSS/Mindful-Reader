// book_details_screen.dart
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Book Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book['formats']['image/jpeg'] != null)
              AspectRatio(
                aspectRatio: 1/ 0.7,
                child: Image.network(
                  book['formats']['image/jpeg']!,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              book['title'] ?? 'Unknown Title',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8),
            Text(
              'Author(s): ${book['authors']?.map((a) => a['name'])?.join(', ') ?? 'Unknown'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Subjects: ${book['subjects']?.join(', ') ?? 'None'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'This section would typically include a detailed description of the book. For now, this is a placeholder.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement download
              },
              child: const Text('Download Book'),
            ),
          ],
        ),
      ),
    );
  }
}
