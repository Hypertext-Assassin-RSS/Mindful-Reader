import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final void Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final backgroundColor = brightness == Brightness.dark
        ? CupertinoColors.darkBackgroundGray.withOpacity(0.9)
        : CupertinoColors.lightBackgroundGray.withOpacity(0.9);

    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: (MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? Colors.grey.withOpacity(0.9)
                          : Colors.grey.withOpacity(0.9)),
              borderRadius: BorderRadius.circular(20.0),
              onPressed: () {
                onCategorySelected(categories[index]);
              },
              child: Text(
                categories[index],
                style: TextStyle(
                  color: (MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? Colors.black
                          : Colors.black)
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
