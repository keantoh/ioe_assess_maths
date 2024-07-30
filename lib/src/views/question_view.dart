import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/dot_paint.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/utils/dot_painter.dart';

class QuestionView extends ConsumerStatefulWidget {
  const QuestionView({super.key});

  static const routeName = '/question';

  @override
  QuestionViewState createState() => QuestionViewState();
}

final questionListProvider = FutureProvider<List<Question>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/question_data.json');
  final jsonData = json.decode(jsonString);

  List<Question> questions = (jsonData['questions'] as List)
      .map((item) => Question.fromJson(item))
      .toList();

  return questions;
});

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

class QuestionViewState extends ConsumerState<QuestionView> {
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _playAudio(String localeName, int id) async {
    await audioPlayer.stop();
    final audioPath = 'audios/$localeName/$id.mp3';
    await audioPlayer.play(AssetSource(audioPath));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsyncValue = ref.watch(questionListProvider);
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final double height = constraints.maxHeight;

              return questionsAsyncValue.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                      child: Text(
                          AppLocalizations.of(context)!.errorLoadingQuestions)),
                  data: (questions) {
                    if (questions.isEmpty) {
                      return Center(
                          child: Text(AppLocalizations.of(context)!
                              .errorLoadingQuestions));
                    } else {
                      final currentQuestion = questions[currentQuestionIndex];
                      _playAudio(AppLocalizations.of(context)!.localeName,
                          currentQuestion.id);
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  minHeight: 12,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  value:
                                      (currentQuestionIndex) / questions.length,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(Icons.close,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                iconSize: 32,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _playAudio(
                                      AppLocalizations.of(context)!.localeName,
                                      currentQuestion.id);
                                },
                                icon: Icon(Icons.volume_up,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                iconSize: 32,
                              ),
                              Text(
                                currentQuestion.getQuestionInstruction(context),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const Spacer(),
                          (currentQuestion is SubitisingQuestion)
                              ? Row(
                                  children: currentQuestion.options
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                  int index = entry.key;
                                  return Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        return InkWell(
                                          onTap: () {
                                            if (currentQuestionIndex <
                                                questions.length - 1) {
                                              ref
                                                  .watch(
                                                      currentQuestionIndexProvider
                                                          .notifier)
                                                  .state += 1;
                                            }
                                          },
                                          child: Container(
                                            width: constraints.maxWidth,
                                            height: height * 0.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            child: subitisingOptions(
                                                width, height, entry.value),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }).toList())
                              : Container(),
                          const Spacer(),
                          progressStars(
                              width, currentQuestionIndex, questions.length)
                        ],
                      );
                    }
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget progressStars(width, completedQuestions, totalQuestions) {
    final double sectionWidth = width / totalQuestions;
    final double starSize = min(sectionWidth, 16);
    return Container(
      color: Colors.black,
      child: Row(
        children: List.generate(totalQuestions, (index) {
          bool isCompleted = index < completedQuestions;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            width: sectionWidth,
            alignment: Alignment.center,
            child: isCompleted
                ? Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: starSize,
                  )
                : Container(height: 12),
          );
        }),
      ),
    );
  }

  Widget subitisingOptions(
      double rowWidth, double rowHeight, List<DotPaint> option) {
    return CustomPaint(
        painter: DotsPainter(option, rowWidth * 0.45, rowHeight * 0.45,
            Theme.of(context).colorScheme.primary));
  }
}
