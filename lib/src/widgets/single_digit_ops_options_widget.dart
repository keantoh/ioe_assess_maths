import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';
import 'package:math_assessment/src/models/result.dart';
import 'package:math_assessment/src/notifiers/children_state_notifier.dart';
import 'package:math_assessment/src/notifiers/question_state_notifier.dart';

class SingleDigitsOpsOptionsWidget extends ConsumerWidget {
  final SingleDigitOpsQuestion currentQuestion;
  final int totalQuestions;
  final DateTime sessionStartTime;
  final DateTime startTime;

  SingleDigitsOpsOptionsWidget(
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
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(currentQuestion.equation,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
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
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(builder: (context, constraints) {
              final double height = constraints.maxHeight;
              return Row(
                children: [
                  optionWidget(context, ref, height, 0, Alignment.topCenter),
                  optionWidget(context, ref, height, 1, Alignment.bottomCenter),
                ],
              );
            }),
          ),
        )
      ],
    );
  }

  Widget optionWidget(BuildContext context, WidgetRef ref, double height,
      int optionIndex, AlignmentGeometry alignment) {
    return Expanded(
      child: Align(
        alignment: alignment,
        child: InkWell(
          onTap: () => submitAnswer(context, ref, optionIndex),
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            height: height * 0.5,
            width: height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
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
