class ForumUser {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  const ForumUser({required this.id, this.displayName, this.avatarUrl});
  factory ForumUser.fromJson(Map<String, dynamic> json) => ForumUser(
    id: json['id'] as String,
    displayName: json['displayName'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
  );
  String get name =>
      (displayName?.isNotEmpty ?? false) ? displayName!.trim() : 'Member';
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
  final int upVotes;
  final int downVotes;

  /// Signed-in viewer's vote (1, -1) or null when unvoted/anonymous.
  final int? myVote;
  final DateTime createdAt;
  final List<ForumReply>? replies;

  const ForumTopic({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.user,
    required this.replyCount,
    this.upVotes = 0,
    this.downVotes = 0,
    this.myVote,
    required this.createdAt,
    this.replies,
  });

  ForumTopic copyWith({
    int? upVotes,
    int? downVotes,
    int? myVote,
    bool clearMyVote = false,
    List<ForumReply>? replies,
  }) =>
      ForumTopic(
        id: id,
        title: title,
        content: content,
        tags: tags,
        user: user,
        replyCount: replyCount,
        upVotes: upVotes ?? this.upVotes,
        downVotes: downVotes ?? this.downVotes,
        myVote: clearMyVote ? null : (myVote ?? this.myVote),
        createdAt: createdAt,
        replies: replies ?? this.replies,
      );

  int get score => upVotes - downVotes;

  factory ForumTopic.fromJson(Map<String, dynamic> json) => ForumTopic(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    tags: (json['tags'] as List).map((e) => e.toString()).toList(),
    user: ForumUser.fromJson(json['user'] as Map<String, dynamic>),
    replyCount:
        (json['_count'] as Map<String, dynamic>?)?['replies'] as int? ?? 0,
    upVotes: json['upVotes'] as int? ?? 0,
    downVotes: json['downVotes'] as int? ?? 0,
    myVote: json['myVote'] as int?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    replies: json['replies'] != null
        ? (json['replies'] as List)
              .map((e) => ForumReply.fromJson(e as Map<String, dynamic>))
              .toList()
        : null,
  );
}
