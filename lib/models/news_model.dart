class NewsModel {
  final String title;
  final String description;
  final String imageUrl;
  final String url;
  final String? author;
  final DateTime? publishedAt;
  final String? sourceName;

  NewsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    this.author,
    this.publishedAt,
    this.sourceName,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      author: json['author'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      sourceName: json['source']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': imageUrl,
      'url': url,
      'author': author,
      'publishedAt': publishedAt?.toIso8601String(),
      'source': {'name': sourceName},
    };
  }

  bool get hasValidImage => imageUrl.isNotEmpty;

  String get shortDescription {
    if (description.length > 100) {
      return '${description.substring(0, 100)}...';
    }
    return description;
  }
}
