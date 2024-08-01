import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/result_api.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/data/models/result_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/utils/dot_painter.dart';

class SubitisingOptionsWidget extends ConsumerWidget {
  final SubitisingQuestion currentQuestion;
  final int totalQuestions;
  final double width;
  final double height;
  final DateTime sessionStartTime;

  const SubitisingOptionsWidget(
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
    return Row(
      children: currentQuestion.options.asMap().entries.map((entry) {
        int index = entry.key;
        return Expanded(
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
                      selectedAnswer: index,
                      timeTaken: DateTime.now()
                          .toUtc()
                          .difference(startTime)
                          .inMilliseconds,
                    );

                    final response = await addResult(newResult);
                    if (ref.read(currentQuestionIndexProvider) <
                            totalQuestions - 1 &&
                        response['status'] == 201) {
                      ref.read(currentQuestionIndexProvider.notifier).state +=
                          1;
                    }
                  },
                  child: Container(
                      width: constraints.maxWidth,
                      height: height * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: CustomPaint(
                        painter: DotsPainter(
                            entry.value,
                            width * 0.45,
                            height * 0.45,
                            Theme.of(context).colorScheme.primary),
                      )),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
