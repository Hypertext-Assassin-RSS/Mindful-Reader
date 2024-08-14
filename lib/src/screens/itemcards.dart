import 'package:flutter/material.dart';

class ItemCards extends StatelessWidget {
  const ItemCards({
    super.key,
    required this.imagepic,
    required this.text1,
    required this.text2,
  });

  final String imagepic;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imagepic),
                fit: BoxFit.cover,
                onError: (Object error, StackTrace? stackTrace) {
                  // Error
                },
              ),
            ),
            child: Image.network(
              imagepic,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/image_not.jpg',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SizedBox(
              width: 150,  // Fixed width for the text
              child: Text(
                text1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 150,  // Fixed width for the text
            child: Text(
              text2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
