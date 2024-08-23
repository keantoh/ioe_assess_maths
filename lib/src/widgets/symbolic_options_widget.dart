import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/question.dart';
import 'package:assess_math/src/models/result.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/question_state_notifier.dart';

class SymbolicOptionsWidget extends ConsumerWidget {
  final SymbolicQuestion currentQuestion;
  final int totalQuestions;
  final DateTime sessionStartTime;
  final DateTime startTime;

  SymbolicOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.sessionStartTime, {
    super.key,
  }) : startTime = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(children: buildOptionWidgets(context, ref));
  }

  List<Widget> buildOptionWidgets(BuildContext context, WidgetRef ref) {
    final options = currentQuestion.options.asMap().entries.toList();
    List<Widget> widgets = [];

    for (int i = 0; i < options.length; i++) {
      final optionWidget = Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double height = constraints.maxHeight;
              return InkWell(
                onTap: () => submitAnswer(context, ref, options[i].key),
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  child: SizedBox(
                      width: constraints.maxWidth,
                      height: height,
                      child: Center(
                        child: Text(options[i].value.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      )),
                ),
              );
            },
          ),
        ),
      );

      widgets.add(optionWidget);

      if (i % 2 == 0) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Container(
            width: 3.0,
            height: 500,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ));
      }
    }
    return widgets;
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
