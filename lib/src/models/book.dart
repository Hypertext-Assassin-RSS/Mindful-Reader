class Book {
  final String imageUrl;
  final String title;
  final String author;
  final String description;
  final String bookUrl;

  Book({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.description,
    required this.bookUrl,
  });

  // Factory constructor to create a Book instance from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      imageUrl: json['cover_url'] ?? 'assets/images/image_not.jpg',
      title: json['title'] ?? 'Unknown Title',
      author: json['author'] ?? 'Unknown Author',
      description: json['description'] ?? 'No description available.',
      bookUrl: json['pdf_url'] ?? '',
    );
  }
}
