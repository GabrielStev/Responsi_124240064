class Book {
  final Map<String, dynamic> data;

  Book({required this.data});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(data: Map<String, dynamic>.from(json));
  }

  String get name {
    return (data['originalTitle'] ??
            data['title'] ??
            data['releaseDate'] ??
            'Unknown Book')
        .toString();
  }

  String get cover {
    return (data['cover'] ?? '').toString();
  }
}
