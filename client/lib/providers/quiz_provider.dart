import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_model.dart';
import '../services/api_service.dart';

class QuizState {
  final bool isLoading;
  final List<QuizQuestion> questions;
  final List<QuizScore> history;
  final String? error;

  const QuizState({
    this.isLoading = false,
    this.questions = const [],
    this.history = const [],
    this.error,
  });

  QuizState copyWith({
    bool? isLoading,
    List<QuizQuestion>? questions,
    List<QuizScore>? history,
    String? error,
  }) =>
      QuizState(
        isLoading: isLoading ?? this.isLoading,
        questions: questions ?? this.questions,
        history: history ?? this.history,
        error: error ?? this.error,
      );
}

class QuizNotifier extends Notifier<QuizState> {
  @override
  QuizState build() => const QuizState();

  Future<void> fetchQuestions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final List<dynamic> data = await ApiService.instance.getQuizQuestions(count: 7);
      final questions = data.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>)).toList();
      state = state.copyWith(isLoading: false, questions: questions);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchScoreHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final List<dynamic> data = await ApiService.instance.getScoreHistory();
      final history = data.map((e) => QuizScore.fromJson(e as Map<String, dynamic>)).toList();
      state = state.copyWith(isLoading: false, history: history);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitQuizScore(int score, int total) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ApiService.instance.submitScore(score, total);
      await fetchScoreHistory();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final quizProvider = NotifierProvider<QuizNotifier, QuizState>(QuizNotifier.new);
