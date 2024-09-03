import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookDetailsPopup extends StatelessWidget {
  final dynamic book;

  const BookDetailsPopup({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CupertinoActionSheet(
      message: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.83,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200.0,
                height: 300.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(book.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Column(
                children: [
                  Text(
                    book.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    book.author,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 24.0),
                      const SizedBox(width: 4.0),
                      Text("${book.rating}"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                onPressed: () {
                  // Action for "Get" button
                },
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.grey,
                child: const Text("GET"),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    // Action for "I Want This" button
                  },
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('I Want This'),
                ),
                const SizedBox(width: 16.0),
                OutlinedButton.icon(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    // Action for "Sample" button
                  },
                  icon: const Icon(Icons.book),
                  label: const Text('Sample'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: Text(
                  book.description ?? 'No description available.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(
              thickness: 1.0,
              color: Colors.grey,
            ),
            const SizedBox(height: 8.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChipWithBar('Size', '100 MB'),
                  _buildChipWithBar('Pages', '169 Pages'),
                  _buildChipWithBar('Category', 'Story'),
                  _buildChipWithBar('Published', '2024/09/02'),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            const Divider(
              thickness: 1.0,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      actions: <CupertinoActionSheetAction> [
        CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
      ],
    );
  }

  Widget _buildChipWithBar(String title, String value) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12.0),
        Container(
          width: 1.0,
          height: 45.0,
          color: Colors.black.withOpacity(0.5),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}
