import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';

class ApiService {
  static ApiService? _instance;
  late final Dio _dio;

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ));

    // Inject Supabase JWT on every authenticated request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Log errors but let them propagate for UI handling
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

  Future<Map<String, dynamic>> parseStatement(MultipartFile file) async {
    final formData = FormData.fromMap({'statement': file});
    final res = await _dio.post('/tax/parse-statement', data: formData);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> searchVat(String query) async {
    final res = await _dio.get('/tax/vat', queryParameters: {'q': query});
    return res.data['data'] as List<dynamic>;
  }

  // ── AI Chat ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> sendChatMessage(String content, {String? sessionId}) async {
    final res = await _dio.post('/ai/message', data: {
      'content': content,
      if (sessionId != null) 'sessionId': sessionId,
    });
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
  Future<List<dynamic>> getTopics({String? tag}) async {
    final res = await _dio.get('/forum', queryParameters: tag != null ? {'tag': tag} : null);
    return res.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getTopicDetail(String id) async {
    final res = await _dio.get('/forum/$id');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> createTopic(String title, String content, List<String> tags) async {
    await _dio.post('/forum', data: {'title': title, 'content': content, 'tags': tags});
  }

  Future<void> createReply(String topicId, String content) async {
    await _dio.post('/forum/$topicId/replies', data: {'content': content});
  }

  // ── Quiz ─────────────────────────────────────────────────────────────────
  Future<List<dynamic>> getQuizQuestions() async {
    final res = await _dio.get('/quiz/questions');
    return res.data['data'] as List<dynamic>;
  }

  Future<void> submitScore(int score, int total) async {
    await _dio.post('/quiz/scores', data: {'score': score, 'totalQuestions': total});
  }

  Future<List<dynamic>> getScoreHistory() async {
    final res = await _dio.get('/quiz/scores/history');
    return res.data['data'] as List<dynamic>;
  }

  // ── News ─────────────────────────────────────────────────────────────────
  Future<List<dynamic>> getArticles({bool featured = false}) async {
    final res = await _dio.get('/news', queryParameters: {'featured': featured});
    return res.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getEconomicMetrics() async {
    final res = await _dio.get('/news/metrics');
    return res.data['data'] as Map<String, dynamic>;
  }
}
