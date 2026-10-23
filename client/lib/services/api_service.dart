import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

import '../core/constants/app_constants.dart';

class ApiService {
  static ApiService? _instance;
  late final Dio _dio;

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 12),
      headers: {'Content-Type': 'application/json'},
    ));

    // Inject Supabase JWT on every authenticated request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            options.headers['Authorization'] = 'Bearer ${session.accessToken}';
          }
        } catch (_) {}
        handler.next(options);
      },
      onError: (error, handler) async {
        // Unwrap the server's {error:{message}} envelope so UI error states
        // show the friendly server message instead of raw DioException text.
        if (error.type == DioExceptionType.badResponse) {
          final data = error.response?.data;
          if (data is Map && data['error'] is Map) {
            final serverMsg = (data['error'] as Map)['message'];
            if (serverMsg is String && serverMsg.isNotEmpty) {
              handler.next(DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                type: error.type,
                error: serverMsg,
                message: serverMsg,
              ));
              return;
            }
          }
        }
        // Pass 401 errors through — Supabase handles session expiry
        // via onAuthStateChange. Auto-signing out here destroys the
        // user's session when the server JWT secret is misconfigured.
        handler.next(error);
      },
    ));
  }

  static ApiService get instance => _instance ??= ApiService._();

  // ── Tax ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> calculateTax(Map<String, dynamic> body) async {
    final res = await _dio.post('/tax/calculate', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getLatestTaxProfile() async {
    final res = await _dio.get('/tax/profiles/latest');
    return res.data['data'] as Map<String, dynamic>?;
  }

  Future<List<dynamic>> getTaxHistory() async {
    final res = await _dio.get('/tax/profiles/history');
    return res.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> parseStatement(MultipartFile file) async {
    final formData = FormData.fromMap({'statement': file});
    final res = await _dio.post('/tax/parse-statement', data: formData);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> searchVat({String? query, String? status}) async {
    final params = <String, dynamic>{};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (status != null) params['status'] = status;
    final res = await _dio.get('/tax/vat', queryParameters: params);
    return res.data['data'] as List<dynamic>;
  }

  // ── AI Chat ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> sendChatMessage(String content,
      {String? sessionId}) async {
    final data = <String, dynamic>{'content': content};
    if (sessionId != null) data['sessionId'] = sessionId;
    // AI generation needs more headroom than regular endpoints: 20s here
    // (server hard-caps Gemini at ~17s and answers before this fires).
    final res = await _dio.post(
      '/ai/message',
      data: data,
      options: Options(receiveTimeout: const Duration(seconds: 20)),
    );
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getChatSessions() async {
    final res = await _dio.get('/ai/sessions');
    return res.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getSessionDetail(String id) async {
    final res = await _dio.get('/ai/sessions/$id');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteSession(String id) async {
    await _dio.delete('/ai/sessions/$id');
  }

  // ── Forum ────────────────────────────────────────────────────────────────
  Future<List<dynamic>> getTopics({String? tag, String? q}) async {
    final res = await _dio.get(
      '/forum',
      queryParameters: {
        if (tag != null && tag.isNotEmpty) 'tag': tag,
        if (q != null && q.isNotEmpty) 'q': q,
      },
    );
    return res.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getTopicDetail(String id) async {
    final res = await _dio.get('/forum/$id');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> createTopic(
      String title, String content, List<String> tags) async {
    await _dio.post('/forum',
        data: {'title': title, 'content': content, 'tags': tags});
  }

  Future<void> createReply(String topicId, String content) async {
    await _dio.post('/forum/$topicId/replies', data: {'content': content});
  }

  /// Casts a vote — returns the persisted vote plus counter deltas.
  Future<Map<String, dynamic>> voteTopic(String topicId, int direction) async {
    final res = await _dio.post('/forum/$topicId/votes',
        data: {'direction': direction});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> retractVote(String topicId) async {
    await _dio.delete('/forum/$topicId/votes');
  }

  Future<void> acceptReply(String replyId) async {
    await _dio.patch('/forum/replies/$replyId/accept');
  }

  // ── Quiz ─────────────────────────────────────────────────────────────────
  Future<List<dynamic>> getQuizQuestions({int count = 7}) async {
    final res = await _dio.get('/quiz/questions', queryParameters: {'count': count});
    return res.data['data'] as List<dynamic>;
  }

  /// Ask the server to grade one answer — returns
  /// `{isCorrect, correctIndex, explanation}`.
  Future<Map<String, dynamic>> checkQuizAnswer(
      String questionId, int selectedIndex) async {
    final res = await _dio.post('/quiz/questions/$questionId/check',
        data: {'selectedIndex': selectedIndex});
    return res.data['data'] as Map<String, dynamic>;
  }

  /// Submit the full answer set; the server computes and persists the score.
  Future<Map<String, dynamic>> submitScore(
      List<Map<String, dynamic>> answers) async {
    final res = await _dio.post('/quiz/scores', data: {'answers': answers});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getScoreHistory() async {
    final res = await _dio.get('/quiz/scores/history');
    return res.data['data'] as List<dynamic>;
  }

  // ── News ─────────────────────────────────────────────────────────────────
  Future<List<dynamic>> getPublicArticles({bool featured = false, String? category, int limit = 50}) async {
    final queryParams = <String, dynamic>{
      'featured': featured,
      'limit': limit,
    };
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    final res =
        await _dio.get('/news/public', queryParameters: queryParams);
    return res.data['data'] as List<dynamic>;
  }

  Future<dynamic> getInflationData({int years = 10}) async {
    final res = await _dio.get('/news/inflation', queryParameters: {'years': years});
    return res.data['data'];
  }

  // ── User Profile ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getMe() async {
    final res = await _dio.get('/users/me');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? phone,
    String? address,
  }) async {
    final data = <String, dynamic>{};
    if (displayName != null) data['displayName'] = displayName;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    final res = await _dio.patch('/users/profile', data: data);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAvatar(String avatarUrl) async {
    final res = await _dio.patch('/users/avatar', data: {'avatarUrl': avatarUrl});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> completeOnboarding() async {
    await _dio.patch('/users/onboarded');
  }

  Future<Map<String, dynamic>> getOnboardedStatus() async {
    final res = await _dio.get('/users/onboarded');
    return res.data['data'] as Map<String, dynamic>;
  }
}
