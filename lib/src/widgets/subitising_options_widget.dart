import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/question.dart';
import 'package:math_assessment/src/models/result.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/utils/dot_painter.dart';
import 'package:math_assessment/src/utils/helper_functions.dart';

class SubitisingOptionsWidget extends ConsumerWidget {
  final SubitisingQuestion currentQuestion;
  final int totalQuestions;
  final DateTime sessionStartTime;
  final DateTime startTime;

  SubitisingOptionsWidget(
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
              final double width = constraints.maxWidth;
              final double height = constraints.maxHeight;
              return InkWell(
                onTap: () => submitAnswer(context, ref, options[i].key),
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: SizedBox(
                      width: width,
                      height: height,
                      child: CustomPaint(
                        painter: DotsPainter(options[i].value, width, height,
                            Theme.of(context).colorScheme.primary),
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
