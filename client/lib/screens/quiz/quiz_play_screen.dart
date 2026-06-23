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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_questionIdx + 1}/${questions.length}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text('Score: $_score', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_questionIdx + 1) / questions.length,
              backgroundColor: theme.colorScheme.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),

            // Question Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  q.question,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Options List
            ...List.generate(q.options.length, (idx) {
              final opt = q.options[idx];
              Color? cardColor;
              Color? textColor;
              BorderSide? borderSide;

              if (_answered) {
                if (idx == q.correctIndex) {
                  cardColor = const Color(0xFFE2FBE9); // Correct green
                  textColor = const Color(0xFF15803D);
                  borderSide = const BorderSide(color: Color(0xFF15803D), width: 1.5);
                } else if (_selectedAns == idx) {
                  cardColor = const Color(0xFFFBEBEB); // Incorrect red
                  textColor = const Color(0xFFB91C1C);
                  borderSide = const BorderSide(color: Color(0xFFB91C1C), width: 1.5);
                }
              }

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: borderSide ?? BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _answerQuestion(idx, q.correctIndex),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Explanation panel
            if (_answered) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info, size: 18, color: Colors.blue),
                          SizedBox(width: 6),
                          Text('Explanation', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(q.explanation, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedButton(
                onPressed: () => _nextQuestion(questions.length),
                text: _questionIdx < questions.length - 1 ? 'Next Question' : 'Finish Quiz',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
