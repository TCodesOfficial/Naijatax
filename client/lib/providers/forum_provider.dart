import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forum_model.dart';
import '../services/api_service.dart';

class ForumState {
  final bool isLoading;
  final bool isSubmitting;
  final List<ForumTopic> topics;
  final ForumTopic? selectedTopic;
  final String? error;

  const ForumState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.topics = const [],
    this.selectedTopic,
    this.error,
  });

  ForumState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<ForumTopic>? topics,
    ForumTopic? selectedTopic,
    String? error,
    bool clearError = false,
    bool clearSelected = false,
  }) =>
      ForumState(
        isLoading: isLoading ?? this.isLoading,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        topics: topics ?? this.topics,
        selectedTopic:
            clearSelected ? null : (selectedTopic ?? this.selectedTopic),
        error: clearError ? null : (error ?? this.error),
      );
}

String _friendlyError(Object e) {
  if (e is DioException) {
    return e.message ?? 'Something went wrong. Please try again.';
  }
  return 'Something went wrong. Please try again.';
}

class ForumNotifier extends Notifier<ForumState> {
  @override
  ForumState build() => const ForumState();

  Future<void> fetchTopics({String? tag, String? q}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final List<dynamic> data =
          await ApiService.instance.getTopics(tag: tag, q: q);
      // One malformed row must not blank the whole list.
      final topics = <ForumTopic>[];
      for (final e in data) {
        try {
          if (e is Map) {
            topics.add(ForumTopic.fromJson(Map<String, dynamic>.from(e)));
          }
        } catch (_) {}
      }
      state = state.copyWith(isLoading: false, topics: topics);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _friendlyError(e));
    }
  }

  Future<void> fetchTopicDetail(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await ApiService.instance.getTopicDetail(id);
      final topic = ForumTopic.fromJson(data);
      state = state.copyWith(isLoading: false, selectedTopic: topic);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _friendlyError(e));
    }
  }

  /// Returns null on success, a friendly message on failure.
  Future<String?> addNewTopic(
      String title, String content, List<String> tags) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await ApiService.instance.createTopic(title, content, tags);
      state = state.copyWith(isSubmitting: false);
      return null;
    } catch (e) {
      final msg = _friendlyError(e);
      state = state.copyWith(isSubmitting: false, error: msg);
      return msg;
    }
  }

  /// Returns null on success, a friendly message on failure. The caller
  /// clears the reply field only when this resolves to null.
  Future<String?> replyToTopic(String topicId, String content) async {
    try {
      await ApiService.instance.createReply(topicId, content);
      await fetchTopicDetail(topicId);
      return null;
    } catch (e) {
      final msg = _friendlyError(e);
      state = state.copyWith(error: msg);
      return msg;
    }
  }

  /// Applies a vote (or retract) using server-returned counter deltas so the
  /// list + detail stay in sync without a refetch.
  Future<String?> voteTopic(String topicId, int direction) async {
    final current = _myVote(topicId);
    try {
      if (current == direction) {
        await ApiService.instance.retractVote(topicId);
        _applyVote(
          topicId,
          current == 1 ? -1 : 0,
          current == -1 ? -1 : 0,
          retract: true,
        );
      } else {
        final vote = await ApiService.instance.voteTopic(topicId, direction);
        final up = vote['upVotesDelta'] as int? ?? 0;
        final down = vote['downVotesDelta'] as int? ?? 0;
        _applyVote(topicId, up, down, newVote: direction);
      }
      return null;
    } catch (e) {
      return _friendlyError(e);
    }
  }

  int? _myVote(String topicId) {
    for (final t in state.topics) {
      if (t.id == topicId) return t.myVote;
    }
    return state.selectedTopic?.id == topicId
        ? state.selectedTopic!.myVote
        : null;
  }

  void _applyVote(String topicId, int up, int down,
      {int? newVote, bool retract = false}) {
    final sel = state.selectedTopic;
    state = state.copyWith(
      topics: state.topics
          .map((t) => t.id == topicId
              ? t.copyWith(
                  upVotes: t.upVotes + up,
                  downVotes: t.downVotes + down,
                  myVote: newVote,
                  clearMyVote: retract,
                )
              : t)
          .toList(),
      selectedTopic: sel != null && sel.id == topicId
          ? sel.copyWith(
              upVotes: sel.upVotes + up,
              downVotes: sel.downVotes + down,
              myVote: newVote,
              clearMyVote: retract,
            )
          : sel,
    );
  }

  /// Marks a reply as the accepted answer (topic owner only server-side).
  /// Returns null on success, a friendly message on failure.
  Future<String?> acceptReply(String topicId, String replyId) async {
    try {
      await ApiService.instance.acceptReply(replyId);
      await fetchTopicDetail(topicId);
      return null;
    } catch (e) {
      return _friendlyError(e);
    }
  }
}

final forumProvider = NotifierProvider<ForumNotifier, ForumState>(
  ForumNotifier.new,
);
