import 'package:flutter/material.dart';

import '../colors/color.dart';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              color: KFourthColor,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imagepic),
                fit: BoxFit.fill,
                onError: (Object error, StackTrace? stackTrace) {
                  // Error handling can be done here
                },
              ),
            ),
            // This is a fallback for when the network image fails to load
            child: Image.network(
              imagepic,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/imgae_not.jpg',
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            text1,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w800,
              color: KFifthColor,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text2,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: KFifthColor.withOpacity(0.7),
              ),
            )
          ],
        ),
      ],
    );
  }
}
