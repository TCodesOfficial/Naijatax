import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/guest_restriction_dialog.dart';
import '../../widgets/user_avatar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
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

  Future<void> _sendMessage({String? text}) async {
    final authState = ref.read(authProvider);
    if (authState.isGuest || authState.status == AuthStatus.unauthenticated) {
      showGuestRestrictionDialog(context);
      return;
    }

    final msg = text ?? _messageController.text.trim();
    if (msg.isEmpty) return;

    _messageController.clear();
    final now = DateFormat('h:mm a').format(DateTime.now());
    setState(() {
      _messages.add({'role': 'user', 'content': msg, 'time': now});
      _isLoading = true;
    });
    Future.microtask(_scrollToBottom);

    try {
      final res = await ApiService.instance.sendChatMessage(msg, sessionId: _sessionId);
      final replyTime = DateFormat('h:mm a').format(DateTime.now());
      final content = res['message']['content'] as String;
      final isBusy = content.contains('busy processing') || content.contains('unable to process');
      setState(() {
        _sessionId = res['sessionId'] as String?;
        if (!isBusy) {
          _messages.add({'role': 'assistant', 'content': content, 'time': replyTime});
        }
        _isLoading = false;
      });
      if (isBusy && mounted) {
        final busyTheme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(content),
            backgroundColor: busyTheme.colorScheme.errorContainer,
            action: SnackBarAction(
              label: 'Retry',
              textColor: busyTheme.colorScheme.onErrorContainer,
              onPressed: () => _sendMessage(text: msg),
            ),
          ),
        );
      }
      Future.microtask(_scrollToBottom);
    } catch (e) {
      final replyTime = DateFormat('h:mm a').format(DateTime.now());
      String errorMsg;
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          errorMsg = 'Session expired. Please log in again.';
        } else if (statusCode == 429) {
          errorMsg = 'AI is busy. Please try again in a moment.';
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errorMsg = 'Server is taking too long to respond. Try again.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMsg = 'Cannot reach the server. Check your connection.';
        } else {
          errorMsg = 'Something went wrong. Please try again.';
        }
      } else {
        errorMsg = 'Sorry, I couldn\'t process your request. Please try again.';
      }
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': errorMsg,
          'time': replyTime,
        });
        _isLoading = false;
      });
      Future.microtask(_scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isGuest = authState.isGuest || authState.status == AuthStatus.unauthenticated;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    // Chat header
    final chatHeader = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.smart_toy, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Expert AI',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF15803D),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Assistant Online',
                        style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF15803D)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isGuest)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Guest Mode',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );

    // Messages list
    final messagesList = Expanded(
      child: _messages.isEmpty
          ? _buildWelcomeMessage(theme, isGuest)
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isUser = msg['role'] == 'user';
                return _chatBubble(
                  theme, isUser, msg['content'] ?? '', msg['time'] ?? '',
                  avatarUrl: isUser ? authState.user?.avatarUrl : null,
                );
              },
            ),
    );

    // Typing indicator
    final typingIndicator = _isLoading
        ? Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.smart_toy, size: 16, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 8),
                  _typingDots(theme),
                ],
              ),
            ),
          )
        : null;

    // Suggestion chips
    final suggestionChips = _messages.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _suggestionChip(theme, 'Am I tax exempt?', isGuest),
                _suggestionChip(theme, 'VAT on groceries?', isGuest),
                _suggestionChip(theme, 'New NTA 2025 rates', isGuest),
              ],
            ),
          )
        : null;

    // Input box
    final inputBox = Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 5,
              enabled: !isGuest,
              decoration: InputDecoration(
                hintText: isGuest ? 'Log in to chat with AI...' : 'Ask about the 2025 Tax Act...',
                prefixIcon: const Icon(Icons.attach_file, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, size: 20),
            onPressed: isGuest ? () => showGuestRestrictionDialog(context) : _sendMessage,
            style: IconButton.styleFrom(
              backgroundColor: isGuest
                  ? theme.colorScheme.surfaceContainerHigh
                  : theme.colorScheme.primary,
              foregroundColor: isGuest
                  ? theme.colorScheme.onSurfaceVariant
                  : Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );

    final disclaimer = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        isGuest
            ? 'Sign in to chat with the AI Tax Assistant.'
            : 'AI can make mistakes. Verify important financial decisions.',
        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
      ),
    );

    final chatBody = Column(
      children: [
        chatHeader,
        messagesList,
        if (typingIndicator != null) typingIndicator,
        if (suggestionChips != null) suggestionChips,
        inputBox,
        disclaimer,
      ],
    );

    if (isDesktop) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: chatBody,
        ),
      );
    }

    return chatBody;
  }

  Widget _buildWelcomeMessage(ThemeData theme, bool isGuest) {
    final now = DateFormat('h:mm a').format(DateTime.now());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Today, $now',
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              child: Icon(Icons.smart_toy, size: 20, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Text(
                  isGuest
                      ? 'Hello! I\'m your AI Tax Assistant. Sign in or create an account to start chatting about the Nigeria Tax Act (NTA) 2025, calculate potential liabilities, or ask specific questions about exemptions.'
                      : 'Hello! I\'m your AI Tax Assistant. I can help you understand the new Nigeria Tax Act (NTA) 2025, calculate potential liabilities, or answer specific questions about exemptions.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ),
            ),
          ],
        ),
        if (isGuest) ...[
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login, size: 18),
              label: const Text('Log In / Sign Up'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _chatBubble(ThemeData theme, bool isUser, String text, String time, {String? avatarUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              child: Icon(Icons.smart_toy, size: 20, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? theme.colorScheme.primary : theme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : theme.colorScheme.onSurface,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            UserAvatar(
              avatarUrl: avatarUrl,
              radius: 16,
              fallbackIcon: Icons.person,
              iconSize: 18,
              backgroundColor: theme.colorScheme.outlineVariant,
              iconColor: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }

  Widget _suggestionChip(ThemeData theme, String text, bool isGuest) {
    return ActionChip(
      label: Text(text, style: TextStyle(fontSize: 13, color: theme.colorScheme.primary)),
      side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      backgroundColor: theme.colorScheme.surface,
      onPressed: isGuest ? () => showGuestRestrictionDialog(context) : () => _sendMessage(text: text),
    );
  }

  Widget _typingDots(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
