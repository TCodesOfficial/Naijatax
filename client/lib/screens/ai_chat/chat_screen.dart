import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String? _sessionId;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    Future.microtask(_scrollToBottom);

    try {
      final res = await ApiService.instance.sendChatMessage(text, sessionId: _sessionId);
      setState(() {
        _sessionId = res['sessionId'] as String?;
        final content = res['message']['content'] as String;
        _messages.add({'role': 'assistant', 'content': content});
        _isLoading = false;
      });
      Future.microtask(_scrollToBottom);
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'content': 'Sorry, I couldn\'t process your request. Check your server connection.'});
        _isLoading = false;
      });
      Future.microtask(_scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    // If guest, show lock overlay screen
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
                'AI Assistant Locked',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Chatting with the AI Tax Assistant is reserved for registered users. Create an account or log in to continue.',
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

    return Column(
      children: [
        // ─── Chat Message Bubble List ─────────────────────────────────────
        Expanded(
          child: _messages.isEmpty
              ? _buildWelcomeMessage(theme)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, idx) {
                    final msg = _messages[idx];
                    final isUser = msg['role'] == 'user';
                    return _chatBubble(theme, isUser, msg['content'] ?? '');
                  },
                ),
        ),

        // ─── Typing Indicator ─────────────────────────────────────────────
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.psychology, size: 14, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 8),
                  Text('AI is thinking...', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),

        // ─── Message Input Box ────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Ask about the 2025 Tax Act (e.g. rent reliefs...)',
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'AI Tax Assistant',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'How can I help you today? You can ask me questions about individual PAYE brackets, company income tax thresholds, or tax exemptions under the 2025 Act.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatBubble(ThemeData theme, bool isUser, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.psychology, size: 18, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
                  bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : theme.colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.outlineVariant,
              child: const Icon(Icons.person, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}
