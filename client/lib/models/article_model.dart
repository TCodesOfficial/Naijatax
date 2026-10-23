class TaxArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String source;
  final String category;
  final String? url;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime? publishedAt;

  const TaxArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.source,
    required this.category,
    this.url,
    required this.isFeatured,
    required this.createdAt,
    this.publishedAt,
  });

  factory TaxArticle.fromJson(Map<String, dynamic> json) => TaxArticle(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        content: json['content'] as String? ?? '',
        source: json['source'] as String? ?? '',
        category: json['category'] as String? ?? 'COMPLIANCE',
        url: json['url'] as String?,
        isFeatured: json['isFeatured'] as bool? ?? false,
        // Stable sentinel — DateTime.now() shifted cached dates on every
        // parse (articles re-sorted and displayed different dates).
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String) ??
                DateTime.fromMillisecondsSinceEpoch(0)
            : DateTime.fromMillisecondsSinceEpoch(0),
        publishedAt: json['publishedAt'] != null
            ? DateTime.tryParse(json['publishedAt'] as String)
            : null,
      );

  /// Original publish time when known, otherwise when we stored it.
  DateTime get effectiveDate => publishedAt ?? createdAt;
}
