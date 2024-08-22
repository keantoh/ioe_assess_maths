import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';
import 'package:math_assessment/src/models/result.dart';
import 'package:math_assessment/src/notifiers/children_state_notifier.dart';
import 'package:math_assessment/src/notifiers/question_state_notifier.dart';

class PatterningOptionsWidget extends ConsumerWidget {
  final PatterningQuestion currentQuestion;
  final int totalQuestions;
  final DateTime sessionStartTime;
  final DateTime startTime;

  PatterningOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.sessionStartTime, {
    super.key,
  }) : startTime = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      final double height = constraints.maxHeight;

      return Row(
        children: [
          // Matching image (Question)
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceContainerHigh),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    currentQuestion.matchingImagePath!,
                    height: height * 0.4,
                    width: height * 0.4,
                  ),
                ),
              ),
            ),
          ),
          // Separator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Container(
              width: 3.0,
              height: 500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          // Options
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: LayoutBuilder(builder: (context, constraints) {
                final double height = constraints.maxHeight;
                return Row(
                  children: [
                    optionWidget(context, ref, height, 1),
                    Column(
                      children: [
                        optionWidget(context, ref, height, 0),
                        optionWidget(context, ref, height, 3),
                      ],
                    ),
                    optionWidget(context, ref, height, 2),
                  ],
                );
              }),
            ),
          )
        ],
      );
    });
  }

  Widget optionWidget(
      BuildContext context, WidgetRef ref, double height, int optionIndex) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () => submitAnswer(context, ref, optionIndex),
          borderRadius: BorderRadius.circular(100),
          child: Ink(
            height: height * 0.4,
            width: height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Image.asset(
                currentQuestion.options[optionIndex],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitAnswer(
      BuildContext context, WidgetRef ref, int selectedAnswer) async {
    final selectedChild = ref.read(childrenStateProvider).selectedChild;
    if (selectedChild == null) return;

    final newResult = ResultCreate(
      childId: selectedChild.childId,
      sessionStartTime: sessionStartTime,
      questionId: currentQuestion.id,
      correctAnswer: currentQuestion.correctOption,
      selectedAnswer: selectedAnswer,
      timeTaken: DateTime.now().toUtc().difference(startTime).inMilliseconds,
    );
    ref.read(questionStateProvider.notifier).addResult(context, newResult);
  }
}
