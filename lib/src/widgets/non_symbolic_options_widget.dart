import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/result_api.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/data/models/result_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/utils/dot_painter.dart';

class NonSymbolicOptionsWidget extends ConsumerWidget {
  final NonSymbolicQuestion currentQuestion;
  final int totalQuestions;
  final double width;
  final double height;
  final DateTime sessionStartTime;

  const NonSymbolicOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.width,
    this.height,
    this.sessionStartTime, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = DateTime.now().toUtc();
    return Row(children: buildOptionWidgets(context, ref, startTime, height));
  }

  List<Widget> buildOptionWidgets(
      BuildContext context, WidgetRef ref, DateTime startTime, double height) {
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
                onTap: () async {
                  final selectedChild = ref.read(selectedChildProvider);
                  if (selectedChild == null) return;

                  final newResult = ResultCreate(
                    childId: selectedChild.childId,
                    sessionStartTime: sessionStartTime,
                    questionId: currentQuestion.id,
                    correctAnswer: currentQuestion.correctOption,
                    selectedAnswer: options[i].key,
                    timeTaken: DateTime.now()
                        .toUtc()
                        .difference(startTime)
                        .inMilliseconds,
                  );

                  final response = await addResult(newResult);
                  if (ref.read(currentQuestionIndexProvider) <
                          totalQuestions - 1 &&
                      response['status'] == 201) {
                    ref.read(currentQuestionIndexProvider.notifier).state += 1;
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: SizedBox(
                      width: constraints.maxWidth,
                      height: height * 0.5,
                      child: CustomPaint(
                        painter: DotsPainter(
                            options[i].value,
                            width * 0.45,
                            height * 0.45,
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
        widgets.add(Container(
          width: 3.0,
          height: height * 0.5,
          color: Theme.of(context).colorScheme.secondary,
        ));
      }
    }

    return widgets;
  }
}
