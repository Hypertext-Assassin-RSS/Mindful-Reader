import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindful_reader/src/models/book.dart';

class BookListWidget extends StatelessWidget {
  final List<dynamic> books;

  const BookListWidget({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 120.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(book.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    book.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    book.author,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
