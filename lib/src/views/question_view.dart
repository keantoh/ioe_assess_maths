import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/question.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/widgets/non_symbolic_options_widget.dart';
import 'package:math_assessment/src/widgets/subitising_options_widget.dart';
import 'package:math_assessment/src/widgets/symbolic_options_widget.dart';

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

class QuestionViewState extends ConsumerState<QuestionView> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late final DateTime sessionStartTime;

  Future<void> _playAudio(String localeName, int id) async {
    await audioPlayer.stop();
    if (id >= 1 && id <= 5) {
      id = 1;
    } else if (id >= 6 && id <= 10) {
      id = 6;
    }
    final audioPath = 'audios/$localeName/$id.mp3';
    await audioPlayer.play(AssetSource(audioPath));
  }

  @override
  void initState() {
    super.initState();
    sessionStartTime = DateTime.now().toUtc();
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
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                  value:
                                      (currentQuestionIndex) / questions.length,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
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
                          buildQuestionOptions(
                              currentQuestion,
                              questions.length,
                              width,
                              height,
                              sessionStartTime),
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
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                    shadows: <Shadow>[
                      Shadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 4.0)
                    ],
                  )
                : Container(height: 12),
          );
        }),
      ),
    );
  }

  Widget buildQuestionOptions(Question currentQuestion, int totalQuestions,
      double width, double height, DateTime sessionStartTime) {
    if (currentQuestion is SubitisingQuestion) {
      return SubitisingOptionsWidget(
          currentQuestion, totalQuestions, width, height, sessionStartTime);
    } else if (currentQuestion is NonSymbolicQuestion) {
      return NonSymbolicOptionsWidget(
          currentQuestion, totalQuestions, width, height, sessionStartTime);
    } else if (currentQuestion is SymbolicQuestion) {
      return SymbolicOptionsWidget(
          currentQuestion, totalQuestions, width, height, sessionStartTime);
    }
    // Add more cases for other question types here
    return Center(
        child: Text(AppLocalizations.of(context)!.unknownQuestionType));
  }
}
