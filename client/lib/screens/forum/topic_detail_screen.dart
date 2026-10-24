import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/app_snack.dart';
import '../../widgets/guest_restriction_dialog.dart';
import '../../providers/auth_provider.dart';
import '../../providers/forum_provider.dart';
import '../../widgets/animated_button.dart';

class TopicDetailScreen extends ConsumerStatefulWidget {
  final String topicId;

  const TopicDetailScreen({super.key, required this.topicId});

  @override
  ConsumerState<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends ConsumerState<TopicDetailScreen> {
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(forumProvider.notifier).fetchTopicDetail(widget.topicId),
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _submitReply(AuthState authState) async {
    if (authState.isRestricted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Required'),
          content: const Text('You must log in to submit a reply.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                goToSignIn(context);
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      );
      return;
    }

    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    final err = await ref
        .read(forumProvider.notifier)
        .replyToTopic(widget.topicId, content);
    if (!mounted) return;
    if (err != null) {
      showAppSnack(context, err);
      return;
    }
    // Clear only on success so a failed reply keeps the user's draft.
    _replyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final forumState = ref.watch(forumProvider);
    final topic = forumState.selectedTopic;
    final isTopicOwner = topic != null &&
        authState.user != null &&
        authState.user!.id == topic.user.id;

    return Scaffold(
      appBar: AppBar(
        leading: Tooltip(
          message: 'Back to discussions',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/forum');
              }
            },
          ),
        ),
        title: const Text('Topic Discussion'),
      ),
      body: forumState.isLoading && topic == null
          ? const Center(child: CircularProgressIndicator())
          : topic == null
          ? const Center(child: Text('Discussion not found.'))
          // Clears the floating bottom nav (extendBody injects bottom MediaQuery).
          : SafeArea(
              top: false,
              child: Column(
              children: [
                // ─── Topic Header Card ──────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 1 + (topic.replies?.length ?? 0),
                    itemBuilder: (context, index) {
                      // First item: topic header
                      if (index == 0) {
                        return Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      topic.title,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Asked by ${topic.user.name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const Divider(height: 24),
                                    Text(
                                      topic.content,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Replies (${topic.replies?.length ?? 0})',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (topic.replies == null || topic.replies!.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Text(
                                    'No replies yet. Be the first to answer!',
                                  ),
                                ),
                              ),
                          ],
                        );
                      }

                      // Reply items (index 1 onwards)
                      final reply = topic.replies![index - 1];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      reply.user.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  if (reply.isAccepted)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.tertiaryContainer,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        'Best Answer',
                                        style: TextStyle(
                                          color: theme.colorScheme.onTertiaryContainer,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else if (isTopicOwner)
                                    TextButton.icon(
                                      onPressed: () async {
                                        final err = await ref
                                            .read(forumProvider.notifier)
                                            .acceptReply(
                                                widget.topicId, reply.id);
                                        if (!context.mounted) return;
                                        if (err != null) {
                                          showAppSnack(context, err);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.check_circle_outline,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                      label: Text(
                                        'Mark as best answer',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        visualDensity:
                                            VisualDensity.compact,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                reply.content,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ─── Input Answer Box ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _replyController,
                          decoration: const InputDecoration(
                            hintText: 'Share your tax knowledge...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedButton(
                        onPressed: () => _submitReply(authState),
                        text: 'Reply',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
