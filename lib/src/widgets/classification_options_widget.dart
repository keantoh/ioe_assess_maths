import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/image_paint_option.dart';
import 'package:assess_math/src/models/question.dart';
import 'package:assess_math/src/models/result.dart';
import 'package:assess_math/src/notifiers/children_state_notifier.dart';
import 'package:assess_math/src/notifiers/question_state_notifier.dart';

class ClassificationOptionsWidget extends ConsumerWidget {
  final ClassificationQuestion currentQuestion;
  final int totalQuestions;
  final DateTime sessionStartTime;
  final DateTime startTime;

  ClassificationOptionsWidget(
    this.currentQuestion,
    this.totalQuestions,
    this.sessionStartTime, {
    super.key,
  }) : startTime = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;
          final selectedOptions =
              ref.watch(questionStateProvider).selectedOptions;
          return Stack(
            children: [
              ...currentQuestion.options.asMap().entries.map((entry) {
                ImagePaintOption option = entry.value;

                return Positioned(
                  top: height * option.y,
                  left: width * option.x,
                  child: InkWell(
                    onTap: () => handleOptionSelected(context, ref, entry.key,
                        option.isCorrect, currentQuestion.correctOption),
                    borderRadius: BorderRadius.circular(100),
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: selectedOptions.contains(entry.key)
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 4.0,
                                )
                              : null,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          option.image.imagePath,
                          height: height * option.height,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void handleOptionSelected(BuildContext context, WidgetRef ref,
      int selectedOption, bool isCorrect, int totalCorrect) {
    if (isCorrect) {
      ref
          .read(questionStateProvider.notifier)
          .addToSelectedOption(selectedOption);
      if (ref.read(questionStateProvider).selectedOptions.length ==
          totalCorrect) {
        submitAnswer(context, ref, totalCorrect);
      }
    } else {
      submitAnswer(context, ref, totalCorrect);
    }
  }

  Future<void> submitAnswer(
      BuildContext context, WidgetRef ref, int totalCorrect) async {
    final selectedChild = ref.read(childrenStateProvider).selectedChild;
    if (selectedChild == null) return;
    final correctSelections =
        ref.read(questionStateProvider).selectedOptions.length;

    final newResult = ResultCreate(
      childId: selectedChild.childId,
      sessionStartTime: sessionStartTime,
      questionId: currentQuestion.id,
      correctAnswer: totalCorrect,
      selectedAnswer: correctSelections,
      timeTaken: DateTime.now().toUtc().difference(startTime).inMilliseconds,
    );

    ref.read(questionStateProvider.notifier).addResult(context, newResult);
  }
}
