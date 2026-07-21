import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/forum_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/forum_provider.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/custom_text_field.dart';

class TopicListScreen extends ConsumerStatefulWidget {
  const TopicListScreen({super.key});

  @override
  ConsumerState<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends ConsumerState<TopicListScreen> {
  String? _selectedTag;
  final List<String> _tags = ['All', 'PAYE', 'VAT', 'Business Tax', 'General'];

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: titleController,
                  label: 'Topic Title',
                  hintText: 'e.g. Is pension tax-deductible?',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: contentController,
                  label: 'Description',
                  hintText: 'Explain your query...',
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
                    if (titleController.text.isNotEmpty &&
                        contentController.text.isNotEmpty) {
                      ref
                          .read(forumProvider.notifier)
                          .addNewTopic(
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
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search discussions...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _showCreateTopicSheet(theme, authState),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Ask'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _tags.map((tag) {
                final isSelected =
                    _selectedTag == tag ||
                    (_selectedTag == null && tag == 'All');
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Tooltip(
                    message: 'Filter by $tag',
                    child: ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      onSelected: (selected) {
                        setState(() => _selectedTag = tag == 'All' ? null : tag);
                        ref
                            .read(forumProvider.notifier)
                            .fetchTopics(tag: _selectedTag);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Topics
          Expanded(
            child: forumState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : forumState.topics.isEmpty
                ? const Center(
                    child: Text('No discussions yet. Be the first to ask!'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: forumState.topics.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final topic = forumState.topics[idx];
                      return _topicCard(theme, topic);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _topicCard(ThemeData theme, ForumTopic topic) {
    final replyCount = topic.replyCount;
    final tagList = List<String>.from(topic.tags);

    return Card(
      child: InkWell(
        onTap: () => context.go('/forum/${topic.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vote column
              Column(
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Text(
                    '${topic.upVotes}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            topic.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (replyCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2FBE9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$replyCount replies',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF15803D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      topic.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (tagList.isNotEmpty) ...[
                          ...tagList
                              .take(2)
                              .map(
                                (t) => Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        theme.colorScheme.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    t,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            'by ${topic.user.email.split('@').first}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
