import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/quiz_provider.dart';

class QuizHistoryScreen extends ConsumerStatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  ConsumerState<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends ConsumerState<QuizHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(quizProvider.notifier).fetchScoreHistory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/learn/quiz'),
        ),
        title: const Text('Quiz Performance History'),
      ),
      body: quizState.isLoading && quizState.history.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : quizState.history.isEmpty
              ? const Center(child: Text('No quiz records found yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizState.history.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final item = quizState.history[idx];
                    final String formattedDate = DateFormat.yMMMd().add_jm().format(item.createdAt);
                    final isExcellent = item.percentage >= 80;
                    final isGood = item.percentage >= 60;

                    Color gradeColor;
                    if (isExcellent) {
                      gradeColor = const Color(0xFF15803D);
                    } else if (isGood) {
                      gradeColor = theme.colorScheme.primary;
                    } else {
                      gradeColor = theme.colorScheme.error;
                    }

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: gradeColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${item.score}/${item.totalQuestions}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: gradeColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.grade,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${item.percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: gradeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
