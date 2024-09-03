import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindful_reader/src/screens/new_read.dart';

class BookDetailsPopup extends StatelessWidget {
  final dynamic book;
  
  

  const BookDetailsPopup({Key? key, required this.book}) : super(key: key);
  



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
    var brightness = MediaQuery.of(context).platformBrightness;
    debugPrint("Building BookDetailsPopup");
    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(16.0),
        color: _getBackgroundColor(context), // Set the background color here
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
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
                const SizedBox(height: 16.0),
                Center(
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: book.title,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: book.author,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: brightness == Brightness.dark
                                ? Colors.grey[300]
                                : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 24.0,
                            color: brightness == Brightness.dark
                                ? Colors.yellow
                                : Colors.black, // Adjust icon color for contrast
                          ),
                          const SizedBox(width: 4.0),
                          RichText(
                            text: TextSpan(
                              text: "${book.rating}",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black, // Adjust text color for contrast
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: () {
                      debugPrint("OK");
                      try {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                NewReadScreen(bookUrl: book.bookUrl),
                          ),
                        );
                      } catch (e) {
                        debugPrint('Navigation error: $e');
                      }
                    },
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey,
                    child: const Text("GET"),
                  ),
                ),
                const SizedBox(height: 16.0),
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
                        foregroundColor:
                            WidgetStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        // Action for "I Want This" button
                      },
                      icon: Icon(Icons.bookmark_border,
                      color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,),
                      label: RichText(
                        text: TextSpan(
                          text: 'I Want This',
                          style: TextStyle(
                            color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black, 
                          ),
                        ),
                      ),
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
                        foregroundColor:
                            WidgetStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        // Action for "Sample" button
                      },
                      icon: Icon(Icons.book,
                      color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                      ),
                      label: RichText(
                        text: TextSpan(
                          text: 'Sample',
                          style: TextStyle(
                            color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black, 
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: book.description ?? 'No description available.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black87, // Adjust text color for contrast
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
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
                      _buildChipWithBar(
                          'Size', '100 MB', brightness), // Pass brightness
                      _buildChipWithBar(
                          'Pages', '169 Pages', brightness), // Pass brightness
                      _buildChipWithBar(
                          'Category', 'Story', brightness), // Pass brightness
                      _buildChipWithBar('Published', '2024/09/02',
                          brightness), // Pass brightness
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
            Positioned(
              right: -10,
              top: -10,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context); // Close the popup
                },
                child: Icon(CupertinoIcons.clear_circled_solid,
                    color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipWithBar(String title, String value, Brightness brightness) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust text color for contrast
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust text color for contrast
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12.0),
        Container(
          width: 1.0,
          height: 45.0,
          color: brightness == Brightness.dark
              ? Colors.white.withOpacity(0.5)
              : Colors.black.withOpacity(0.5), // Adjust divider color for contrast
        ),
        const SizedBox(width: 15.0),
      ],
    );
  }
}
