class Article {
  final String? id;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final String? author;
  final Map<String, dynamic>? source;
  final bool isActive;

  Article({
    this.id,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.author,
    this.source,
    this.isActive = true, // Default to active
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      source: json['source'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true, // Default to active for API articles
    );
  }
}