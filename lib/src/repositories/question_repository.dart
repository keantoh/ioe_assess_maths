import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';

class QuestionRepository {
  final List<Question> _questions = [];
  final questionDataPath = 'assets/question_data.json';

  List<Question> get questions => List.unmodifiable(_questions);

  Future<List<Question>> getAllQuestions() async {
    try {
      final jsonString = await rootBundle.loadString(questionDataPath);
      final jsonData = json.decode(jsonString);

      List<Question> questions = (jsonData['questions'] as List)
          .map((item) => Question.fromJson(item))
          .toList();

      _questions.clear();
      _questions.addAll(questions);
      return questions;
    } catch (e) {
      // Load empty list
      _questions.clear();
      return questions;
    }
  }
}

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepository();
});
