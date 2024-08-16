import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';
import 'package:math_assessment/src/models/result.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

class ClassificationOptionsWidget extends ConsumerWidget {
  final ClassificationQuestion currentQuestion;
  final int totalQuestions;
  final double width;
  final double height;
  final DateTime sessionStartTime;
  final DateTime startTime;

  ClassificationOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.width,
    this.height,
    this.sessionStartTime, {
    super.key,
  }) : startTime = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.amber,
      child: Stack(
        children: [
          Positioned(
            left: 50, // X coordinate
            top: 50, // Y coordinate
            child: Image.asset(
              'assets/images/avatar_bird.jpeg',
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return Icon(Icons.error);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> submitAnswer(
      BuildContext context, WidgetRef ref, int selectedAnswer) async {
    final selectedChild = ref.read(selectedChildProvider);
    if (selectedChild == null) return;

    final newResult = ResultCreate(
      childId: selectedChild.childId,
      sessionStartTime: sessionStartTime,
      questionId: currentQuestion.id,
      correctAnswer: currentQuestion.correctOption,
      selectedAnswer: selectedAnswer,
      timeTaken: DateTime.now().toUtc().difference(startTime).inMilliseconds,
    );

    HelperFunctions.submitResult(context, ref, newResult);
  }
}
