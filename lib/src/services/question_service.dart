import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/config.dart';
import 'package:assess_math/src/models/question.dart';
import 'package:assess_math/src/models/result.dart';
import 'package:assess_math/src/utils/http_request.dart';

class QuestionService {
  final String baseUrl = Config.apiUrl;

  Future<List<Question>> getAllQuestions() async {
    const questionDataPath = 'assets/question_data.json';
    try {
      final jsonString = await rootBundle.loadString(questionDataPath);
      final jsonData = json.decode(jsonString);

      List<Question> questions = (jsonData['questions'] as List)
          .map((item) => Question.fromJson(item))
          .toList();
      return questions;
    } catch (e) {
      // Load empty list
      return [];
    }
  }

  Future<Map<String, dynamic>> addResultService(ResultCreate result) async {
    final url = '$baseUrl/result';
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
