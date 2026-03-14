class QuoteModel {
  final int id;
  final String content;
  final String author;
  final String displayDate;

  QuoteModel({
    required this.id,
    required this.content,
    required this.author,
    required this.displayDate,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] ?? 0,
      content: json['content']?.toString().trim() ?? '',
      author: json['author']?.toString().trim() ?? '',
      displayDate: json['display_date']?.toString().trim() ?? '',
    );
  }
}