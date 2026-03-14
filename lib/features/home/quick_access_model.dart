class QuickAccessModel {
  final int id;
  final String title;
  final String contentType;

  final String? thumbnailUrl;
  final String? previewPage;
  final String? mediaUrl;

  final int? totalPages;

  QuickAccessModel({
    required this.id,
    required this.title,
    required this.contentType,
    this.thumbnailUrl,
    this.previewPage,
    this.mediaUrl,
    this.totalPages,
  });

  factory QuickAccessModel.fromJson(Map<String, dynamic> json) {
    return QuickAccessModel(
      id: json['id'],
      title: json['title'] ?? "",
      contentType: json['content_type'] ?? "",
      thumbnailUrl: json['thumbnail_url'],
      previewPage: json['preview_page'],
      mediaUrl: json['media_url'],
      totalPages: json['total_pages'],
    );
  }

  get meta => null;
}