import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/data/models/result_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

class SymbolicOptionsWidget extends ConsumerWidget {
  final SymbolicQuestion currentQuestion;
  final int totalQuestions;
  final double width;
  final double height;
  final DateTime sessionStartTime;
  final DateTime startTime;

  SymbolicOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.width,
    this.height,
    this.sessionStartTime, {
    super.key,
  }) : startTime = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(children: buildOptionWidgets(context, ref, height));
  }

  List<Widget> buildOptionWidgets(
      BuildContext context, WidgetRef ref, double height) {
    final options = currentQuestion.options.asMap().entries.toList();
    List<Widget> widgets = [];

    for (int i = 0; i < options.length; i++) {
      final optionWidget = Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return InkWell(
                onTap: () => submitAnswer(context, ref, options[i].key),
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: SizedBox(
                      width: constraints.maxWidth,
                      height: height * 0.5,
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
        widgets.add(Container(
          width: 3.0,
          height: height * 0.5,
          color: Theme.of(context).colorScheme.secondary,
        ));
      }
    }
    return widgets;
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
