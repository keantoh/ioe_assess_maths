import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';
import 'package:math_assessment/src/services/question_service.dart';

class QuestionRepository {
  final List<Question> _questions = [];
  final QuestionService _questionService;

  QuestionRepository(this._questionService);

  List<Question> get questions => List.unmodifiable(_questions);

  Future<void> getAllQuestions() async {
    final results = await _questionService.getAllQuestions();
    _questions.clear();
    _questions.addAll(results);
  }
}

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  final questionService = ref.watch(questionServiceProvider);

  return QuestionRepository(questionService);
});
