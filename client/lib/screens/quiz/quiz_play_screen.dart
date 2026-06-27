import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
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
  bool _answered = false;
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(quizProvider.notifier).fetchQuestions());
  }

  void _answerQuestion(int index, int correctIndex) {
    if (_answered) return;
    setState(() {
      _selectedAns = index;
      _answered = true;
      if (index == correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion(int totalQuestions) {
    if (_questionIdx < totalQuestions - 1) {
      setState(() {
        _questionIdx++;
        _selectedAns = null;
        _answered = false;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
      // Save score to database
      ref.read(quizProvider.notifier).submitQuizScore(_score, totalQuestions);
    }
  }

  void _restartQuiz() {
    setState(() {
      _questionIdx = 0;
      _score = 0;
      _selectedAns = null;
      _answered = false;
      _quizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final quizState = ref.watch(quizProvider);

    // Guard: Guest lock screen
    if (authState.isGuest || authState.status == AuthStatus.unauthenticated) {
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
      return const Center(child: Text('No quiz questions available.'));
    }

    final questions = quizState.questions;

    // Show results at the end
    if (_quizFinished) {
      final percentage = (questions.isNotEmpty) ? (_score / questions.length) * 100 : 0.0;
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
              Text(
                'You scored $_score out of ${questions.length}',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Percentage: ${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  color: percentage >= 60 ? const Color(0xFF15803D) : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedButton(
                    onPressed: _restartQuiz,
                    text: 'Play Again',
                  ),
                  const SizedBox(width: 16),
                  AnimatedButton(
                    onPressed: () => context.go('/quiz/history'),
                    text: 'View History',
                    isOutlined: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final q = questions[_questionIdx];

    return Scaffold(
      body: Column(
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
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.close, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Question ${_questionIdx + 1} of ${questions.length}',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_questionIdx + 1) / questions.length,
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
                  ...List.generate(q.options.length, (idx) {
                    final opt = q.options[idx];
                    Color? cardColor;
                    Color? textColor;
                    BorderSide? borderSide;
                    FontWeight fontWeight = FontWeight.w500;
                    double elevation = 0;

                    if (_answered) {
                      if (idx == q.correctIndex) {
                        cardColor = const Color(0xFFE2FBE9);
                        textColor = const Color(0xFF15803D);
                        borderSide = const BorderSide(color: Color(0xFF15803D), width: 1.5);
                      } else if (_selectedAns == idx) {
                        cardColor = const Color(0xFFFBEBEB);
                        textColor = const Color(0xFFB91C1C);
                        borderSide = const BorderSide(color: Color(0xFFB91C1C), width: 1.5);
                      }
                    } else if (_selectedAns == idx) {
                      cardColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.1);
                      borderSide = BorderSide(color: theme.colorScheme.primary, width: 2);
                      elevation = 2;
                      fontWeight = FontWeight.w600;
                    }

                    final optionLabel = String.fromCharCode(65 + idx); // A, B, C, D

                    return Card(
                      color: cardColor,
                      elevation: elevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: borderSide ?? BorderSide(color: theme.colorScheme.outlineVariant),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _answerQuestion(idx, q.correctIndex),
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
                                  child: Text(
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
                  if (_answered) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFF15803D)),
                                SizedBox(width: 6),
                                Text('Explanation', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(q.explanation, style: const TextStyle(fontSize: 14, height: 1.5)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedButton(
                      onPressed: () => _nextQuestion(questions.length),
                      text: _questionIdx < questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
