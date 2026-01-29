
enum ContentType { markdown, html }

class Chapter {
  int? id;
  int? bookId;
  String title;
  String content;
  ContentType contentType;
  int? chapterOrder; // Add this line

  Chapter({
    this.id,
    this.bookId,
    required this.title,
    required this.content,
    this.contentType = ContentType.markdown,
    this.chapterOrder, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'title': title,
      'content': content,
      'content_type': contentType.index,
      'chapter_order': chapterOrder, // Add this line
    };
  }

  static Chapter fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      bookId: map['book_id'],
      title: map['title'],
      content: map['content'],
      contentType: ContentType.values[map['content_type'] ?? 0],
      chapterOrder: map['chapter_order'], // Add this line
    );
  }
}
