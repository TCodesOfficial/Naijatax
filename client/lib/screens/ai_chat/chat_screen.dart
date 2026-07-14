import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String _sessionTitle = 'New Conversation';
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _sessions = [];
  bool _isLoadingSessions = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    try {
      final res = await ApiService.instance.getChatSessions();
      if (mounted) {
        setState(() {
          _sessions = res.cast<Map<String, dynamic>>();
          _isLoadingSessions = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingSessions = false);
    }
  }

  Future<void> _loadSession(String sessionId) async {
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
    try {
      final res = await ApiService.instance.getSessionDetail(sessionId);
      final msgs = (res['messages'] as List<dynamic>).cast<Map<String, dynamic>>();
      if (mounted) {
        setState(() {
          _sessionId = sessionId;
          _sessionTitle = res['title'] as String? ?? 'Conversation';
          _messages
            ..clear()
            ..addAll(msgs.map((m) => {
              'role': m['role'],
              'content': m['content'],
              'time': DateFormat('h:mm a').format(DateTime.parse(m['createdAt'])),
            }));
        });
        Future.microtask(_scrollToBottom);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load conversation')),
        );
      }
    }
  }

  void _newSession() {
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
    setState(() {
      _sessionId = null;
      _sessionTitle = 'New Conversation';
      _messages.clear();
    });
  }

  Future<void> _deleteSession(String sessionId) async {
    try {
      await ApiService.instance.deleteSession(sessionId);
      setState(() {
        _sessions.removeWhere((s) => s['id'] == sessionId);
        if (_sessionId == sessionId) {
          _sessionId = null;
          _sessionTitle = 'New Conversation';
          _messages.clear();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete conversation')),
        );
      }
    }
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
        final newSessionId = res['sessionId'] as String?;
        if (_sessionId == null && newSessionId != null) {
          _sessionId = newSessionId;
          _sessionTitle = res['sessionTitle'] as String? ?? msg.substring(0, msg.length.clamp(0, 40));
          _sessions.insert(0, {
            'id': newSessionId,
            'title': _sessionTitle,
            'updatedAt': DateTime.now().toIso8601String(),
          });
        }
        _sessionId = newSessionId;
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
    final displayName = authState.user != null
        ? (authState.user!.displayName ??
              authState.user!.email?.split('@').first ??
              'User')
        : 'Guest';

    final chatBody = Scaffold(
      key: _scaffoldKey,
      drawer: isGuest ? null : _buildDrawer(theme, displayName),
      body: Column(
        children: [
          _buildChatHeader(theme, isGuest),
          Expanded(
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
                        displayName: isUser ? displayName : null,
                      );
                    },
                  ),
          ),
          if (_isLoading)
            Padding(
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
            ),
          if (_messages.isEmpty && !isGuest)
            Padding(
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
            ),
          Padding(
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              isGuest
                  ? 'Sign in to chat with the AI Tax Assistant.'
                  : 'AI can make mistakes. Verify important financial decisions.',
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ),
        ],
      ),
    );

    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;
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

  Widget _buildChatHeader(ThemeData theme, bool isGuest) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          if (!isGuest)
            IconButton(
              icon: const Icon(Icons.menu_rounded, size: 22),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              tooltip: 'Sessions',
            ),
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
                  _sessionId != null ? _sessionTitle : 'Tax Expert AI',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
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
          if (!isGuest)
            IconButton(
              icon: const Icon(Icons.add_comment_outlined, size: 20),
              onPressed: _newSession,
              tooltip: 'New Chat',
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
  }

  Widget _buildDrawer(ThemeData theme, String displayName) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              child: Row(
                children: [
                  UserAvatar(
                    avatarUrl: ref.read(authProvider).user?.avatarUrl,
                    displayName: displayName,
                    radius: 18,
                    fallbackIcon: Icons.person,
                    iconSize: 20,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    iconColor: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Chat',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${_sessions.length} conversation${_sessions.length == 1 ? '' : 's'}',
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _newSession,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Chat'),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: _isLoadingSessions
                  ? const Center(child: CircularProgressIndicator())
                  : _sessions.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 40, color: theme.colorScheme.outline),
                                const SizedBox(height: 12),
                                Text(
                                  'No conversations yet',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Start a new chat to begin',
                                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _sessions.length,
                          itemBuilder: (context, index) {
                            final session = _sessions[index];
                            final id = session['id'] as String;
                            final title = session['title'] as String? ?? 'Conversation';
                            final updatedAt = session['updatedAt'] as String?;
                            final isSelected = _sessionId == id;
                            final dateStr = updatedAt != null
                                ? DateFormat('MMM d, h:mm a').format(DateTime.parse(updatedAt))
                                : '';

                            return Dismissible(
                              key: ValueKey(id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer),
                              ),
                              confirmDismiss: (_) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Conversation'),
                                    content: Text('Delete "$title"?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (_) => _deleteSession(id),
                              child: ListTile(
                                selected: isSelected,
                                selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                leading: Icon(
                                  Icons.chat_bubble_outline,
                                  size: 18,
                                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                ),
                                title: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  dateStr,
                                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close, size: 16, color: theme.colorScheme.outline),
                                  onPressed: () => _deleteSession(id),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                onTap: () => _loadSession(id),
                              ),
                            );
                          },
                        ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Swipe left to delete',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _chatBubble(ThemeData theme, bool isUser, String text, String time, {String? avatarUrl, String? displayName}) {
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
                  child: isUser
                      ? Text(
                          text,
                          style: TextStyle(
                            color: isUser ? Colors.white : theme.colorScheme.onSurface,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: text,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 15,
                              height: 1.5,
                            ),
                            code: TextStyle(
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              fontFamily: 'monospace',
                              fontSize: 13.5,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            codeblockPadding: const EdgeInsets.all(12),
                            blockquote: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            blockquotePadding: const EdgeInsets.only(left: 12),
                            blockquoteDecoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 4,
                                ),
                              ),
                            ),
                            h1: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            h2: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            h3: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            listBullet: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 15,
                            ),
                            listIndent: 24,
                            tableHead: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            tableBody: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                            tableBorder: TableBorder(
                              horizontalInside: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                              verticalInside: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          onTapLink: (text, href, title) {
                            if (href != null) {
                              launchUrl(Uri.parse(href));
                            }
                          },
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
              displayName: displayName,
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
