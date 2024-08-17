import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/config.dart';
import 'package:math_assessment/src/models/result.dart';
import 'package:math_assessment/src/utils/http_request.dart';

class QuestionService {
  final String baseUrl = Config.apiUrl;

  Future<Map<String, dynamic>> addResultService(ResultCreate result) async {
    final url = '$baseUrl/result';
    return {
      'status': 201,
      'response': {},
    };
    return await makeHttpRequest(url, 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: result.toJson());
  }
}

final questionServiceProvider = Provider<QuestionService>((ref) {
  return QuestionService();
});
