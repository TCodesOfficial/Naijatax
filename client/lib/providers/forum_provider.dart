import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forum_model.dart';
import '../services/api_service.dart';

class ForumState {
  final bool isLoading;
  final List<ForumTopic> topics;
  final ForumTopic? selectedTopic;
  final String? error;

  const ForumState({
    this.isLoading = false,
    this.topics = const [],
    this.selectedTopic,
    this.error,
  });

  ForumState copyWith({
    bool? isLoading,
    List<ForumTopic>? topics,
    ForumTopic? selectedTopic,
    String? error,
  }) =>
      ForumState(
        isLoading: isLoading ?? this.isLoading,
        topics: topics ?? this.topics,
        selectedTopic: selectedTopic ?? this.selectedTopic,
        error: error ?? this.error,
      );
}

class ForumNotifier extends Notifier<ForumState> {
  @override
  ForumState build() => const ForumState();

  Future<void> fetchTopics({String? tag}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final List<dynamic> data = await ApiService.instance.getTopics(tag: tag);
      final topics = data.map((e) => ForumTopic.fromJson(e as Map<String, dynamic>)).toList();
      state = state.copyWith(isLoading: false, topics: topics);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchTopicDetail(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await ApiService.instance.getTopicDetail(id);
      final topic = ForumTopic.fromJson(data);
      state = state.copyWith(isLoading: false, selectedTopic: topic);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addNewTopic(String title, String content, List<String> tags) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ApiService.instance.createTopic(title, content, tags);
      await fetchTopics(); // refresh
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> replyToTopic(String topicId, String content) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ApiService.instance.createReply(topicId, content);
      await fetchTopicDetail(topicId); // refresh detail with replies
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final forumProvider = NotifierProvider<ForumNotifier, ForumState>(ForumNotifier.new);
