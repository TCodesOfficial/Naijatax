import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/forum_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/animated_button.dart';

class TopicListScreen extends ConsumerStatefulWidget {
  const TopicListScreen({super.key});

  @override
  ConsumerState<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends ConsumerState<TopicListScreen> {
  String? _selectedTag;
  final List<String> _tags = ['All', 'PAYE', 'VAT', 'Corporate', 'Exemptions'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(forumProvider.notifier).fetchTopics());
  }

  void _showCreateTopicSheet(ThemeData theme, AuthState authState) {
    if (authState.isGuest || authState.status == AuthStatus.unauthenticated) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Required'),
          content: const Text('You must log in to create topics on the forum.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/login');
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      );
      return;
    }

    final titleController = TextEditingController();
    final contentController = TextEditingController();
    List<String> chosenTags = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create New Topic',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: titleController,
                  label: 'Topic Title',
                  hintText: 'e.g. Is my pension contribution tax-deductible?',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: contentController,
                  label: 'Description',
                  hintText: 'Explain your tax query in detail...',
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),
                Text('Tags', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _tags.where((t) => t != 'All').map((tag) {
                    return StatefulBuilder(
                      builder: (context, setInnerState) {
                        final isSelected = chosenTags.contains(tag);
                        return ChoiceChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setInnerState(() {
                              if (selected) {
                                chosenTags.add(tag);
                              } else {
                                chosenTags.remove(tag);
                              }
                            });
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                AnimatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                      ref.read(forumProvider.notifier).addNewTopic(
                            titleController.text.trim(),
                            contentController.text.trim(),
                            chosenTags,
                          );
                      Navigator.pop(context);
                    }
                  },
                  text: 'Submit Topic',
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final forumState = ref.watch(forumProvider);

    return Scaffold(
      body: Column(
        children: [
          // ─── Tag Filter Chips ─────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _tags.map((tag) {
                final isSelected = _selectedTag == tag || (_selectedTag == null && tag == 'All');
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTag = tag == 'All' ? null : tag;
                      });
                      ref.read(forumProvider.notifier).fetchTopics(tag: _selectedTag);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ─── Topic Feed ───────────────────────────────────────────────────
          Expanded(
            child: forumState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : forumState.topics.isEmpty
                    ? const Center(child: Text('No discussions found. Be the first to ask!'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: forumState.topics.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          final topic = forumState.topics[idx];
                          return Card(
                            child: ListTile(
                              title: Text(
                                topic.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Text(
                                    topic.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.comment, size: 14, color: theme.colorScheme.outline),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${topic.replyCount} replies',
                                        style: TextStyle(color: theme.colorScheme.outline, fontSize: 12),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'by ${topic.user.email.split('@').first}',
                                        style: TextStyle(color: theme.colorScheme.outline, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                context.go('/forum/${topic.id}');
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTopicSheet(theme, authState),
        child: const Icon(Icons.add),
      ),
    );
  }
}
