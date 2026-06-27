class TaxArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String source;
  final String? url;
  final bool isFeatured;
  final DateTime createdAt;

  const TaxArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.source,
    this.url,
    required this.isFeatured,
    required this.createdAt,
  });

  factory TaxArticle.fromJson(Map<String, dynamic> json) => TaxArticle(
        id: json['id'] as String,
        title: json['title'] as String,
        summary: json['summary'] as String,
        content: json['content'] as String,
        source: json['source'] as String,
        url: json['url'] as String?,
        isFeatured: json['isFeatured'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'content': content,
        'source': source,
        'url': url,
        'isFeatured': isFeatured,
        'createdAt': createdAt.toIso8601String(),
      };
}
