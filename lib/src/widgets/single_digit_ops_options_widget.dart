import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/data/models/result_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

class SingleDigitsOpsOptionsWidget extends ConsumerWidget {
  final SingleDigitOpsQuestion currentQuestion;
  final int totalQuestions;
  final double width;
  final double height;
  final DateTime sessionStartTime;
  final DateTime startTime;

  SingleDigitsOpsOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.width,
    this.height,
    this.sessionStartTime, {
    super.key,
  }) : startTime = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Equation
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(currentQuestion.equation,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
          ),
        ),
        // Separator
        Container(
          width: 3.0,
          height: height * 0.5,
          color: Theme.of(context).colorScheme.secondary,
        ),
        // Options
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: height * 0.5,
              child: Row(
                children: [
                  optionWidget(context, ref, 0, Alignment.topCenter),
                  optionWidget(context, ref, 1, Alignment.bottomCenter),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget optionWidget(BuildContext context, WidgetRef ref, int optionIndex,
      AlignmentGeometry alignment) {
    return Expanded(
      child: Align(
        alignment: alignment,
        child: InkWell(
          onTap: () => submitAnswer(context, ref, optionIndex),
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            height: height * 0.2,
            width: height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: Center(
              child: Text(
                currentQuestion.options[optionIndex].toString(),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
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