import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/data/models/result_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

class MissingNoOptionsWidget extends ConsumerWidget {
  final MissingNoQuestion currentQuestion;
  final int totalQuestions;
  final DateTime sessionStartTime;
  final DateTime startTime;

  MissingNoOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.sessionStartTime, {
    super.key,
  }) : startTime = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Equation
        Expanded(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
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
  }

  Widget optionWidget(
      BuildContext context, WidgetRef ref, double height, int optionIndex) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () => submitAnswer(context, ref, optionIndex),
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            height: height * 0.4,
            width: height * 0.4,
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
