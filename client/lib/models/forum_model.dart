class ForumUser {
  final String id;
  final String email;
  const ForumUser({required this.id, required this.email});
  factory ForumUser.fromJson(Map<String, dynamic> json) =>
      ForumUser(id: json['id'] as String, email: json['email'] as String);
}

class ForumReply {
  final String id;
  final String content;
  final ForumUser user;
  final bool isAccepted;
  final DateTime createdAt;

  const ForumReply({
    required this.id,
    required this.content,
    required this.user,
    required this.isAccepted,
    required this.createdAt,
  });

  factory ForumReply.fromJson(Map<String, dynamic> json) => ForumReply(
        id: json['id'] as String,
        content: json['content'] as String,
        user: ForumUser.fromJson(json['user'] as Map<String, dynamic>),
        isAccepted: json['isAccepted'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ForumTopic {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final ForumUser user;
  final int replyCount;
  final DateTime createdAt;
  final List<ForumReply>? replies;

  const ForumTopic({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.user,
    required this.replyCount,
    required this.createdAt,
    this.replies,
  });

  factory ForumTopic.fromJson(Map<String, dynamic> json) => ForumTopic(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        tags: (json['tags'] as List).map((e) => e.toString()).toList(),
        user: ForumUser.fromJson(json['user'] as Map<String, dynamic>),
        replyCount: (json['_count'] as Map<String, dynamic>?)?['replies'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        replies: json['replies'] != null
            ? (json['replies'] as List)
                .map((e) => ForumReply.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
      );
}
