import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme_colors.dart';
import '../../core/utils/app_snack.dart';
import '../../models/quiz_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/animated_button.dart';

class QuizPlayScreen extends ConsumerStatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  ConsumerState<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> {
  int _questionIdx = 0;
  int _score = 0;
  int? _selectedAns;
  int? _correctIndex;
  String? _explanation;
  bool _answered = false;
  bool _checking = false;
  bool _quizFinished = false;

  // User's picked option per question id (submitted to the server for grading).
  final Map<String, int> _answers = {};

  // Server-graded result of the final submission.
  bool _saving = false;
  bool _saveFailed = false;
  int? _savedScore;
  int? _savedTotal;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(quizProvider.notifier).fetchQuestions());
  }

  Future<void> _answerQuestion(QuizQuestion question, int index) async {
    if (_answered || _checking) return;
    setState(() {
      _selectedAns = index;
      _checking = true;
    });
    _answers[question.id] = index;
    try {
      final res =
          await ApiService.instance.checkQuizAnswer(question.id, index);
      if (!mounted) return;
      final isCorrect = res['isCorrect'] as bool? ?? false;
      setState(() {
        _answered = true;
        _checking = false;
        _correctIndex = res['correctIndex'] as int?;
        _explanation = res['explanation'] as String?;
        if (isCorrect) _score++;
      });
    } catch (_) {
      if (!mounted) return;
      // Verification failed — let the user pick again (nothing was revealed).
      setState(() {
        _checking = false;
        _selectedAns = null;
      });
      showAppSnack(
          context,
          "Couldn't verify that answer. Check your connection and try again.");
    }
  }

  void _nextQuestion(int totalQuestions) {
    if (_questionIdx < totalQuestions - 1) {
      setState(() {
        _questionIdx++;
        _selectedAns = null;
        _correctIndex = null;
        _explanation = null;
        _answered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    setState(() {
      _quizFinished = true;
      _saving = true;
      _saveFailed = false;
    });
    await _submitScore();
  }

  List<QuizAnswer> _buildAnswers() {
    // questions order is stable during a play-through
    final quizState = ref.read(quizProvider);
    return [
      for (final q in quizState.questions)
        if (_answers.containsKey(q.id))
          QuizAnswer(questionId: q.id, selectedIndex: _answers[q.id]!),
    ];
  }

  Future<void> _submitScore() async {
    final answers = _buildAnswers();
    try {
      final saved =
          await ref.read(quizProvider.notifier).submitAnswers(answers);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveFailed = false;
        _savedScore = saved.score;
        _savedTotal = saved.totalQuestions;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveFailed = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _questionIdx = 0;
      _score = 0;
      _selectedAns = null;
      _correctIndex = null;
      _explanation = null;
      _answered = false;
      _checking = false;
      _quizFinished = false;
      _saving = false;
      _saveFailed = false;
      _savedScore = null;
      _savedTotal = null;
      _answers.clear();
    });
  }

  Future<void> _exitQuiz() async {
    final popped = await Navigator.maybePop(context);
    if (!popped && mounted) context.go('/learn');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final quizState = ref.watch(quizProvider);

    // Guard: Guest lock screen
    if (authState.isRestricted) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Quiz Mode Locked',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Playing tax quizzes and tracking your knowledge scores requires an account. Log in or create an account to start playing.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Log In / Register'),
              ),
            ],
          ),
        ),
      );
    }

    if (quizState.isLoading && quizState.questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (quizState.questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No quiz questions available.'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  ref.read(quizProvider.notifier).fetchQuestions(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final questions = quizState.questions;
    // A provider refetch mid-play can shrink the list — never index past it.
    final idx = _questionIdx.clamp(0, questions.length - 1);

    // Show results at the end
    if (_quizFinished) {
      final score = _savedScore ?? _score;
      final total = _savedTotal ?? questions.length;
      final percentage = total > 0 ? (score / total) * 100 : 0.0;
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                percentage >= 60 ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 80,
                color: percentage >= 60 ? Colors.amber : theme.colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Quiz Finished!',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_saving) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                const Text('Saving your score…'),
              ] else ...[
                Text(
                  'You scored $score out of $total',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Percentage: ${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16,
                    color: percentage >= 60
                        ? (theme.brightness == Brightness.dark ? AppColors.darkSuccess : AppColors.success)
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              if (_saveFailed) ...[
                const SizedBox(height: 16),
                Card(
                  color: theme.colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Your score could not be saved.',
                          style: TextStyle(color: theme.colorScheme.onErrorContainer),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _submitScore,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Retry save'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AnimatedButton(
                      onPressed: _restartQuiz,
                      text: 'Play Again',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: AnimatedButton(
                      onPressed: () => context.push('/learn/quiz/history'),
                      text: 'View History',
                      isOutlined: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final q = questions[idx];

    return Scaffold(
      // Clears the floating bottom nav (extendBody injects bottom MediaQuery).
      body: SafeArea(
        top: false,
        child: Column(
        children: [
          // ─── Task-Focused Header ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: 'Exit quiz',
                      child: IconButton(
                        onPressed: _exitQuiz,
                        icon: const Icon(Icons.close, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Question ${idx + 1} of ${questions.length}',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (idx + 1) / questions.length,
                    backgroundColor: theme.colorScheme.outlineVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),

          // ─── Question Body ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '2025 NTA Reforms',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    q.question,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options
                  ...List.generate(q.options.length, (optIdx) {
                    final opt = q.options[optIdx];
                    Color? cardColor;
                    Color? textColor;
                    BorderSide? borderSide;
                    FontWeight fontWeight = FontWeight.w500;
                    double elevation = 0;

                    if (_answered) {
                      if (optIdx == _correctIndex) {
                        cardColor = theme.colorScheme.tertiaryContainer;
                        textColor = theme.brightness == Brightness.dark
                            ? AppColors.darkSuccess
                            : AppColors.success;
                        borderSide = BorderSide(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.darkSuccess
                              : AppColors.success,
                          width: 1.5,
                        );
                      } else if (_selectedAns == optIdx) {
                        cardColor = theme.colorScheme.errorContainer;
                        textColor = theme.colorScheme.error;
                        borderSide = BorderSide(color: theme.colorScheme.error, width: 1.5);
                      }
                    } else if (_selectedAns == optIdx) {
                      cardColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.1);
                      borderSide = BorderSide(color: theme.colorScheme.primary, width: 2);
                      elevation = 2;
                      fontWeight = FontWeight.w600;
                    }

                    final optionLabel = String.fromCharCode(65 + optIdx); // A, B, C, D

                    return Card(
                      color: cardColor,
                      elevation: elevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: borderSide ?? BorderSide(color: theme.colorScheme.outlineVariant),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: _checking ? null : () => _answerQuestion(q, optIdx),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: textColor != null
                                      ? textColor.withValues(alpha: 0.1)
                                      : theme.colorScheme.surfaceContainerHigh,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: _checking && _selectedAns == optIdx
                                      ? SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme.colorScheme.primary,
                                          ),
                                        )
                                      : Text(
                                          optionLabel,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: textColor ?? theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  opt,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: fontWeight,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Explanation
                  if (_answered && _explanation != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 18,
                                  color: theme.brightness == Brightness.dark
                                      ? AppColors.darkSuccess
                                      : AppColors.success,
                                ),
                                const SizedBox(width: 6),
                                const Text('Explanation', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(_explanation!, style: const TextStyle(fontSize: 14, height: 1.5)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedButton(
                      onPressed: () => _nextQuestion(questions.length),
                      text: idx < questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
