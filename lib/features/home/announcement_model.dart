class Announcement {
  final int id;
  final String title;
  final String message;
  final String? bannerImage;
  final DateTime? publishAt;
  final DateTime? expireAt;
  final DateTime? createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    this.bannerImage,
    this.publishAt,
    this.expireAt,
    this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json["id"],
      title: json["title"] ?? "",
      message: json["message_md"] ?? "",
      bannerImage: json["banner_image_key"],
      publishAt: json["publish_at"] != null
          ? DateTime.tryParse(json["publish_at"])
          : null,
      expireAt: json["expire_at"] != null
          ? DateTime.tryParse(json["expire_at"])
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
    );
  }
}