class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json['id'] as String,
        question: json['question'] as String,
        options: (json['options'] as List).map((e) => e.toString()).toList(),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String,
      );
}

class QuizScore {
  final String id;
  final int score;
  final int totalQuestions;
  final DateTime createdAt;

  const QuizScore({
    required this.id,
    required this.score,
    required this.totalQuestions,
    required this.createdAt,
  });

  double get percentage => totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;

  String get grade {
    final p = percentage;
    if (p >= 80) return 'Excellent';
    if (p >= 60) return 'Good';
    if (p >= 40) return 'Fair';
    return 'Needs Practice';
  }

  factory QuizScore.fromJson(Map<String, dynamic> json) => QuizScore(
        id: json['id'] as String,
        score: json['score'] as int,
        totalQuestions: json['totalQuestions'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
