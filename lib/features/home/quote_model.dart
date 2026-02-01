class QuoteModel {
  final String day;
  final String quote;
  final String author;

  QuoteModel({
    required this.day,
    required this.quote,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      day: json['Day']?.toString().trim() ?? '',
      quote: json['quote']?.toString().trim() ?? '',
      author: json['author']?.toString().trim() ?? '',
    );
  }
}
